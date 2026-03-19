library(tidyverse)
library(sf)
library(osmactive)
library(osmextract)

source("get_city_polygon.R")

get_city_metrics <- function(city_name, country_name) {
  message("=== City: ", city_name, ", ", country_name, " ===")
  cache_dir <- "data/cache/osm_cache"
  
  safe_city <- gsub("[^A-Za-z0-9]", "_", city_name)
  safe_country <- gsub("[^A-Za-z0-9]", "_", country_name)
  
  osm_path <- file.path(cache_dir, paste0("osm_", safe_country, "_", safe_city, ".rds"))
  cycle_path <- file.path(cache_dir, paste0("cycle_", safe_country, "_", safe_city, ".rds"))

  poly <- get_city_polygon(city_name, country_name)
  if (is.null(poly)) return(NULL)

  if (file.exists(osm_path)) {
    osm_city <- readRDS(osm_path)
  } else {
    return(NULL) # Skip if not cached for speed
  }
  
  if (file.exists(cycle_path)) {
     cyc_city <- readRDS(cycle_path)
  } else {
     cyc_city <- tryCatch({ osmactive::get_cycling_network(osm_city) }, error = function(e) NULL)
  }
  
  if (is.null(cyc_city)) cyc_city = sf::st_sf(geometry = sf::st_sfc(), crs = 4326)

  # Standard road types for both total length and LoS
  road_types = c("motorway", "motorway_link", "trunk", "trunk_link", "primary", "primary_link", "secondary", "secondary_link", "tertiary", "tertiary_link", "unclassified", "residential", "living_street")
  
  car_roads_city <- osm_city |> filter(highway %in% road_types)
  if (nrow(car_roads_city) == 0) return(NULL)

  car_roads_city$length_m <- sf::st_length(car_roads_city)
  total_road_km <- round(sum(as.numeric(car_roads_city$length_m), na.rm = TRUE) / 1000, 2)

  # LoS
  osm_city_prep = car_roads_city |>
    dplyr::mutate(
      cycle_segregation = if(nrow(cyc_city) > 0) {
        osmactive::classify_cycle_infrastructure(
          osmactive::distance_to_road(cyc_city, car_roads_city),
          include_mixed_traffic = TRUE
        )$cycle_segregation[sf::st_nearest_feature(car_roads_city, cyc_city)]
      } else { "Mixed Traffic Street" }
    ) |>
    dplyr::mutate(infrastructure = cycle_segregation)
  
  osm_los = tryCatch({ osmactive::level_of_service(osm_city_prep) }, error = function(e) NULL)
  if (!is.null(osm_los)) {
    osm_los$length_m = sf::st_length(osm_los)
    high_los_km = round(sum(as.numeric(osm_los$length_m[osm_los$`Level of Service` == "High"]), na.rm = TRUE) / 1000, 2)
    high_medium_los_km = round(sum(as.numeric(osm_los$length_m[osm_los$`Level of Service` %in% c("High", "Medium")]), na.rm = TRUE) / 1000, 2)
  } else { 
    high_los_km = 0 
    high_medium_los_km = 0
  }

  # Cycling types length
  cyc_classified <- tryCatch({ osmactive::classify_cycle_infrastructure(cyc_city) }, error = function(e) cyc_city)
  if (nrow(cyc_classified) > 0) {
    cyc_classified$length_m <- sf::st_length(cyc_classified)
    summary_df <- cyc_classified |> sf::st_drop_geometry() |> group_by(cycle_segregation) |> summarise(len_km = sum(as.numeric(length_m), na.rm = TRUE) / 1000) |> ungroup()
    get_len <- function(cat) { val <- summary_df$len_km[summary_df$cycle_segregation == cat]; if (length(val) == 0 || is.na(val)) 0 else val }
    total_cyc = round(sum(as.numeric(cyc_classified$length_m), na.rm = TRUE) / 1000, 2)
    off_road = round(get_len("Off Road Path"), 2)
    seg_w = round(get_len("Segregated Track (wide)"), 2)
    seg_n = round(get_len("Segregated Track (narrow)"), 2)
    painted = round(get_len("Painted Cycle Lane"), 2)
    shared = round(get_len("Shared Footway"), 2)
  } else {
    total_cyc = off_road = seg_w = seg_n = painted = shared = 0
  }

  tibble(
    country=country_name, city_name=city_name,
    total_cycle_km=total_cyc,
    total_road_km=total_road_km,
    off_road_km=off_road,
    segregated_wide_km=seg_w,
    segregated_narrow_km=seg_n,
    painted_km=painted,
    shared_footway_km=shared,
    high_los_km=high_los_km,
    high_medium_los_km = high_medium_los_km
  )
}

# Run loop
city_lengths_all <- read_csv("outputs/city_lengths_all.csv", show_col_types = FALSE)
cities_to_update <- city_lengths_all |> select(country, city_name)

results_list <- list()
for(i in 1:nrow(cities_to_update)) {
  res <- tryCatch({ get_city_metrics(cities_to_update$city_name[i], cities_to_update$country[i]) }, error = function(e) NULL)
  if(!is.null(res)) {
    results_list[[i]] <- res
  }
  if(i %% 10 == 0) {
    message("Progress: ", i, "/", nrow(cities_to_update))
    bind_rows(results_list) |> write_csv("outputs/city_lengths_all_v3.csv")
  }
}
bind_rows(results_list) |> write_csv("outputs/city_lengths_all_v3.csv")
