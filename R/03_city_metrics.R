# R/03_city_metrics.R: City infrastructure metrics (single city)

get_city_metrics <- function(city_name, country_name) {
  message("=== City: ", city_name, ", ", country_name, " ===")
  
  # Ensure cache dir exists (helper check)
  cache_dir <- "data/cache/osm_cache"
  if (!dir.exists(cache_dir)) dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)
  
  # Define cache paths with sanitized names
  safe_city <- gsub("[^A-Za-z0-9]", "_", city_name)
  safe_country <- gsub("[^A-Za-z0-9]", "_", country_name)
  
  osm_path <- file.path(cache_dir, paste0("osm_", safe_country, "_", safe_city, ".rds"))
  cycle_path <- file.path(cache_dir, paste0("cycle_", safe_country, "_", safe_city, ".rds"))
  
  poly <- get_city_polygon(city_name, country_name)
  if (is.null(poly)) {
    return(tibble(
      country           = country_name,
      city_name         = city_name,
      total_cycle_km    = NA_real_,
      total_road_km     = NA_real_,
      off_road_km       = NA_real_,
      segregated_wide_km = NA_real_,
      segregated_narrow_km = NA_real_,
      painted_km        = NA_real_,
      shared_footway_km = NA_real_,
      high_los_km       = NA_real_
    ))
  }
  
  # 1. Get/Load OSM Data
  if (file.exists(osm_path)) {
    message("  Reading cached OSM from ", osm_path)
    osm_city <- readRDS(osm_path)
  } else {
    # Download/extract OSM for just this city area
    # Use polygon directly so osmextract auto-selects correct regional PBF
    
    # Temporarily disable S2 to avoid "loop" errors with osmactive/geos
    sf::sf_use_s2(FALSE)
    osm_city <- tryCatch({
      # Use place = poly so osmextract finds the right sub-region PBF file
      # (e.g., île-de-france for Paris instead of all of France)
      net <- osmactive::get_travel_network(place = poly)
      if (!is.null(net)) {
        # Now clip to exact polygon
        sf::st_intersection(net, poly)
      } else {
        NULL
      }
    }, error = function(e) {
      warning("Failed to get OSM for ", city_name, ": ", e$message)
      return(NULL)
    })
    sf::sf_use_s2(TRUE)
    
    if (!is.null(osm_city)) {
      message("  Saving OSM to ", osm_path)
      saveRDS(osm_city, osm_path)
    }
  }
  
  if (is.null(osm_city)) {
    return(tibble(
      country           = country_name,
      city_name         = city_name,
      total_cycle_km    = NA_real_,
      total_road_km     = NA_real_,
      off_road_km       = NA_real_,
      segregated_wide_km = NA_real_,
      segregated_narrow_km = NA_real_,
      painted_km        = NA_real_,
      shared_footway_km = NA_real_,
      high_los_km       = NA_real_
    ))
  }
  
  # 2. Get/Load Cycling Network
  if (file.exists(cycle_path)) {
    message("  Reading cached Cycle net from ", cycle_path)
    cyc_city <- readRDS(cycle_path)
  } else {
    # Get cycling network
    cyc_city <- osmactive::get_cycling_network(osm_city)
    
    # Identify car roads for distance calculation (from the same city extract)
    # Including living_street and service for consistency with LoS calculation
    car_roads_city <- osm_city |>
      filter(highway %in% c("motorway", "motorway_link", "trunk", "trunk_link", 
                            "primary", "primary_link", "secondary", "secondary_link", 
                            "tertiary", "tertiary_link", "unclassified", "residential",
                            "living_street", "service"))
    
    # Calculate distance to nearest road
    if (nrow(cyc_city) > 0) {
      if (nrow(car_roads_city) > 0) {
        pts <- sf::st_point_on_surface(cyc_city)
        nearest_idx <- sf::st_nearest_feature(pts, car_roads_city)
        dists <- sf::st_distance(pts, car_roads_city[nearest_idx,], by_element = TRUE)
        cyc_city$distance_to_road <- as.numeric(dists)
      } else {
        cyc_city$distance_to_road <- 0 
      }
    }
    
    message("  Saving Cycle net to ", cycle_path)
    saveRDS(cyc_city, cycle_path)
  }
  
  # Calculate total road length if not already done
  # We can do this from car_roads_city if available, or load OSM if needed
  # Since we are inside the function, we might have skipped loading OSM if cycle path existed
  # But we need OSM for roads.
  # Check if we have car_roads_city variable.
  if (!exists("car_roads_city")) {
    # If we loaded cycle path from cache, we didn't load OSM.
    # We need to load OSM to get roads.
    # But wait, if we load OSM every time, we lose the benefit of cycle cache for speed?
    # Yes. But we need to calculate this new metric once.
    if (file.exists(osm_path)) {
      osm_city <- readRDS(osm_path)
      car_roads_city <- osm_city |>
        filter(highway %in% c("motorway", "motorway_link", "trunk", "trunk_link", 
                              "primary", "primary_link", "secondary", "secondary_link", 
                              "tertiary", "tertiary_link", "unclassified", "residential",
                              "living_street", "service"))
    } else {
      # Should have been created/loaded above?
      # The logic above: if cycle_path exists, it DOES NOT load OSM.
      # So we must load OSM here if it's missing.
      # (See logic: if (file.exists(cycle_path)) ... else ... )
      # To fix: ensure OSM is loaded if we need road stats.
      # For now, I will just load it.
      # This is safe because I save osm_path before cycle_path.
      osm_city <- readRDS(osm_path)
      car_roads_city <- osm_city |>
        filter(highway %in% c("motorway", "motorway_link", "trunk", "trunk_link", 
                              "primary", "primary_link", "secondary", "secondary_link", 
                              "tertiary", "tertiary_link", "unclassified", "residential"))
    }
  }
  
  # Calculate total road length
  car_roads_city$length_m <- sf::st_length(car_roads_city)
  total_road_km <- round(sum(as.numeric(car_roads_city$length_m), na.rm = TRUE) / 1000, 2)
  
  # --- New LoS calculation section ---
  message("  Calculating LoS...")
  # Standardize for osmactive functions
  osm_city_prep = osm_city |>
    dplyr::filter(highway %in% c("motorway", "motorway_link", "trunk", "trunk_link", 
                                 "primary", "primary_link", "secondary", "secondary_link", 
                                 "tertiary", "tertiary_link", "unclassified", "residential", "living_street", "service"))
  
  if (nrow(osm_city_prep) > 0) {
    # Get cycle info for the whole network
    osm_city_prep = osm_city_prep |>
      dplyr::mutate(
        cycle_segregation = osmactive::classify_cycle_infrastructure(
          osmactive::distance_to_road(cyc_city, osm_city_prep),
          include_mixed_traffic = TRUE
        )$cycle_segregation[sf::st_nearest_feature(osm_city_prep, cyc_city)]
      ) |>
      dplyr::mutate(infrastructure = cycle_segregation)
    
    # Estimate traffic and LoS
    # Note: osmactive::level_of_service calls estimate_traffic() internally if AADT is missing
    osm_los = tryCatch({
      osmactive::level_of_service(osm_city_prep)
    }, error = function(e) {
      message("    LoS error: ", e$message)
      NULL
    })
    
    if (!is.null(osm_los)) {
      osm_los$length_m = sf::st_length(osm_los)
      high_los_km = round(sum(as.numeric(osm_los$length_m[osm_los$`Level of Service` == "High"]), na.rm = TRUE) / 1000, 2)
    } else {
      high_los_km = 0
    }
  } else {
    high_los_km = 0
  }
  # --- End LoS section ---
  
  if (nrow(cyc_city) == 0) {
    return(tibble(
      country           = country_name,
      city_name         = city_name,
      total_cycle_km    = 0,
      total_road_km     = total_road_km,
      off_road_km       = 0,
      segregated_wide_km = 0,
      segregated_narrow_km = 0,
      painted_km        = 0,
      shared_footway_km = 0,
      high_los_km       = high_los_km
    ))
  }
  
  # Classify
  cyc_classified <- tryCatch({
    osmactive::classify_cycle_infrastructure(cyc_city)
  }, error = function(e) {
    warning("Classification failed for ", city_name, ": ", e$message)
    cyc_city$cycle_segregation <- NA_character_
    cyc_city
  })
  
  # Calculate lengths
  cyc_classified$length_m <- sf::st_length(cyc_classified)
  
  # Summarise
  summary <- cyc_classified |>
    sf::st_drop_geometry() |>
    group_by(cycle_segregation) |>
    summarise(len_km = sum(as.numeric(length_m), na.rm = TRUE) / 1000) |>
    ungroup()
  
  get_len <- function(cat) {
    val <- summary$len_km[summary$cycle_segregation == cat]
    if (length(val) == 0 || is.na(val)) 0 else val
  }
  
  tibble(
    country           = country_name,
    city_name         = city_name,
    total_cycle_km    = round(sum(as.numeric(cyc_classified$length_m), na.rm = TRUE) / 1000, 2),
    total_road_km     = total_road_km,
    off_road_km       = round(get_len("Off Road Path"), 2),
    segregated_wide_km = round(get_len("Segregated Track (wide)"), 2),
    segregated_narrow_km = round(get_len("Segregated Track (narrow)"), 2),
    painted_km        = round(get_len("Painted Cycle Lane"), 2),
    shared_footway_km = round(get_len("Shared Footway"), 2),
    high_los_km       = high_los_km
  )
}