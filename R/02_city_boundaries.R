# R/02_city_boundaries.R: City boundary helper functions 

# Get city boundaries
get_city_polygon <- function(city, country) {
  query <- paste(city, country, sep = ", ")
  message("  Boundary for: ", query)
  
  poly <- tryCatch(
    osmdata::getbb(query, format_out = "sf_polygon"),
    error = function(e) NULL
  )
  
  # Try cleaning name (e.g. Helsinki / Helsingfors -> Helsinki)
  if (is.null(poly) && grepl("/", city)) {
    clean_city <- trimws(str_split(city, "/")[[1]][1])
    query_clean <- paste(clean_city, country, sep = ", ")
    message("    Retrying with cleaned name: ", query_clean)
    poly <- tryCatch(
      osmdata::getbb(query_clean, format_out = "sf_polygon"),
      error = function(e) NULL
    )
  }
  
  if (inherits(poly, "sf")) {
    message("    Got polygon boundary for ", query)
    
    # FIRST: If multiple polygons returned, select the most appropriate one
    # This must happen before any geometry operations to avoid mixed type errors
    if (nrow(poly) > 1) {
      message("    Multiple polygons returned (", nrow(poly), "), selecting best one...")
      
      # Temporarily disable S2 for area calculations on mixed geometries
      s2_state <- sf::sf_use_s2()
      sf::sf_use_s2(FALSE)
      
      # Calculate areas safely for each polygon
      areas <- sapply(1:nrow(poly), function(i) {
        tryCatch(as.numeric(sf::st_area(poly[i,])) / 1e6, error = function(e) NA)
      })
      poly$area_km2 <- areas
      
      sf::sf_use_s2(s2_state)
      
      # Prefer administrative boundaries with place_rank indicating city level
      if ("place_rank" %in% names(poly)) {
        city_level <- poly |> filter(place_rank >= 15 & !is.na(area_km2))
        if (nrow(city_level) > 0) {
          poly <- city_level[which.max(city_level$area_km2), ]
          message("    Selected city-level polygon (place_rank >= 15): ", round(poly$area_km2, 2), " km sq")
        } else {
          # Fall back to polygon with area between 10-500 km² (typical city size)
          city_sized <- poly |> filter(area_km2 >= 10 & area_km2 <= 500 & !is.na(area_km2))
          if (nrow(city_sized) > 0) {
            poly <- city_sized[which.max(city_sized$area_km2), ]
            message("    Selected city-sized polygon: ", round(poly$area_km2, 2), " km sq")
          } else {
            # Just take the first row (usually the primary result)
            poly <- poly[1, ]
            message("    Using first polygon result")
          }
        }
      } else {
        # No place_rank, use area heuristics or just first row
        city_sized <- poly |> filter(area_km2 >= 10 & area_km2 <= 500 & !is.na(area_km2))
        if (nrow(city_sized) > 0) {
          poly <- city_sized[which.max(city_sized$area_km2), ]
          message("    Selected city-sized polygon: ", round(poly$area_km2, 2), " km sq")
        } else {
          poly <- poly[1, ]
          message("    Using first polygon result")
        }
      }
      poly$area_km2 <- NULL  # Remove temporary column
    }
    
    # THEN: Ensure valid geometry (now working with single polygon)
    poly <- tryCatch({
      sf::st_make_valid(poly)
    }, error = function(e) {
      message("    Warning: st_make_valid failed, using original")
      poly
    })
  } else {
    message("    No polygon boundary for ", query, "; trying bounding box")
    bb <- osmdata::getbb(query)
    if (is.null(bb) && grepl("/", city)) {
      clean_city <- trimws(str_split(city, "/")[[1]][1])
      query_clean <- paste(clean_city, country, sep = ", ")
      bb <- osmdata::getbb(query_clean)
    }
    
    if (is.null(bb)) {
      warning("    No boundary found for ", query)
      return(NULL)
    }
    
    poly <- sf::st_as_sf(
      sf::st_sfc(
        sf::st_polygon(list(rbind(
          c(bb["x", "min"], bb["y", "min"]),
          c(bb["x", "min"], bb["y", "max"]),
          c(bb["x", "max"], bb["y", "max"]),
          c(bb["x", "max"], bb["y", "min"]),
          c(bb["x", "min"], bb["y", "min"])
        ))),
        crs = 4326
      )
    )
  }
  
  # Calculate area
  area_sq_km <- sum(as.numeric(sf::st_area(poly))) / 1e6
  
  message("    Area: ", round(area_sq_km, 2), " km sq")
  
  # Check if area is suspiciously small (e.g. < 5 km sq for a major city)
  # Helsinki was 0.13 km sq.
  if (area_sq_km < 2 && grepl("/", city)) {
    message("    Area very small for split name. Trying cleaned name...")
    clean_city <- trimws(str_split(city, "/")[[1]][1])
    query_clean <- paste(clean_city, country, sep = ", ")
    poly_clean <- tryCatch(
      osmdata::getbb(query_clean, format_out = "sf_polygon"),
      error = function(e) NULL
    )
    if (inherits(poly_clean, "sf")) {
      area_clean <- sum(as.numeric(sf::st_area(poly_clean))) / 1e6
      if (area_clean > area_sq_km) {
        message("    Using cleaned name polygon (Area: ", round(area_clean, 2), " km sq)")
        poly <- poly_clean
        area_sq_km <- area_clean
      }
    }
  }
  
  if (area_sq_km > 1000) {
    message("    Area > 1000 km sq. Clipping to 25km radius from centroid.")
    
    # Find centroid of the union (in case of multiple polygons)
    centroid <- sf::st_centroid(sf::st_union(poly))
    
    # Create 25km buffer
    buffer <- sf::st_buffer(centroid, dist = 25000)
    
    # Intersect
    poly <- sf::st_intersection(poly, buffer)
  }
  
  return(poly)
}
