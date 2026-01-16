library(haven)
library(tidyverse)
library(giscoR)
library(sf)
library(osmactive)

# 1. Load QoL data
qol <- read_sav("data/QoL in European Cities_2023_microdata/2023_QoL in European Cities_microdata.sav")
qol_factor <- qol |> mutate(across(where(is.labelled), ~ as_factor(.)))
all_cities_qol <- qol_factor |>
  group_by(country = Country_sample, city_name = D3_Cityrecode, population = Population) |>
  summarise(bike_prop = sum(w1[Q5_1 == "Bicycle" | Q5_2 == "Bicycle"], na.rm = TRUE) / sum(w1, na.rm = TRUE)) |>
  ungroup()

# 2. Get Standardized Boundaries (Urban Centres) from GISCO
gisco_cities <- gisco_get_urban_audit(year = "2021", level = "CITIES")

# 3. Manual Overrides for matching
match_map <- c(
  "Wien" = "Greater Wien",
  "Bruxelles / Brussel" = "Bruxelles/Brussel",
  "Lefkosia" = "Lefkosia", # Check
  "Helsinki / Helsingfors" = "Helsinki/Helsingfors",
  "Oulu / Uleåborg" = "Oulu/Uleåborg",
  "Napoli" = "Napoli (greater city)",
  "Riga" = "Rīga",
  "Bucureşti" = "București",
  "Piatra Neamţ" = "Piatra-Neamț",
  "Ljubljana" = "Ljubljana",
  "Valletta" = "Valletta"
)

all_cities_qol <- all_cities_qol |>
  mutate(match_name = ifelse(city_name %in% names(match_map), match_map[as.character(city_name)], as.character(city_name)))

# Join with GISCO
standardized_cities <- all_cities_qol |>
  inner_join(gisco_cities, by = c("match_name" = "URAU_NAME"))

cat("Standardized matches found:", nrow(standardized_cities), "\n")

# 4. Process existing cache for these boundaries
cache_dir <- "data/cache/osm_cache"

# Helper to get metrics within a boundary
get_metrics_in_poly <- function(city_name, country_name, poly) {
  safe_city <- gsub("[^A-Za-z0-9]", "_", city_name)
  safe_country <- gsub("[^A-Za-z0-9]", "_", country_name)
  osm_path <- file.path(cache_dir, paste0("osm_", safe_country, "_", safe_city, ".rds"))
  
  if (!file.exists(osm_path)) return(NULL)
  
  osm_city <- readRDS(osm_path)
  # Clip to standardized boundary
  sf::sf_use_s2(FALSE)
  osm_clipped <- sf::st_intersection(osm_city, poly)
  sf::sf_use_s2(TRUE)
  
  if (nrow(osm_clipped) == 0) return(NULL)
  
  cyc_city <- tryCatch(osmactive::get_cycling_network(osm_clipped), error = function(e) return(NULL))
  if (is.null(cyc_city) || nrow(cyc_city) == 0) return(NULL)
  
  # Identify car roads for distance calculation
  car_roads <- osm_clipped |>
    filter(highway %in% c("motorway", "motorway_link", "trunk", "trunk_link", 
                          "primary", "primary_link", "secondary", "secondary_link", 
                          "tertiary", "tertiary_link", "unclassified", "residential",
                          "living_street", "service"))
  
  # Distance calculation (standardized osmactive approach)
  if (nrow(car_roads) > 0) {
    cyc_city$distance_to_road <- as.numeric(sf::st_distance(sf::st_point_on_surface(cyc_city), car_roads[sf::st_nearest_feature(sf::st_point_on_surface(cyc_city), car_roads),], by_element = TRUE))
  } else {
    cyc_city$distance_to_road <- 0
  }
  
  total_road_km <- sum(as.numeric(sf::st_length(car_roads))) / 1000
  
  # Classify
  cyc_classified <- osmactive::classify_cycle_infrastructure(cyc_city)
  cyc_classified$length_m <- sf::st_length(cyc_classified)
  
  summary <- cyc_classified |>
    sf::st_drop_geometry() |>
    group_by(cycle_segregation) |>
    summarise(len_km = sum(as.numeric(length_m)) / 1000)
  
  get_len <- function(cat) {
    val <- summary$len_km[summary$cycle_segregation == cat]
    if (length(val) == 0 || is.na(val)) 0 else val
  }
  
  tibble(
    city_name = city_name,
    country = country_name,
    total_road_km = round(total_road_km, 2),
    segregated_km = round(get_len("Segregated Track (wide)") + get_len("Segregated Track (narrow)"), 2),
    painted_km = round(get_len("Painted Cycle Lane"), 2)
  )
}

results <- list()
for (i in 1:nrow(standardized_cities)) {
  row <- standardized_cities[i, ]
  res <- get_metrics_in_poly(row$city_name, row$country, row$geometry)
  if (!is.null(res)) {
    results[[length(results) + 1]] <- res
  }
}

final_res <- bind_rows(results)
write_csv(final_res, "outputs/city_lengths_standardized.csv")
cat("Saved outputs/city_lengths_standardized.csv\n")
