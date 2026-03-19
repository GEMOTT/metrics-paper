get_city_polygon <- function(city, country) {
  query <- paste(city, country, sep = ", ")
  message("  Boundary for: ", query)
  
  # 1) Prefer true admin boundary (municipality) via Overpass
  poly <- tryCatch({
    opq(bbox = query) |>
      add_osm_feature("boundary", "administrative") |>
      add_osm_feature("admin_level", "8") |>
      osmdata_sf() |>
      (\(x) x$osm_multipolygons)()
  }, error = function(e) NULL)
  
  # If empty, relax admin_level constraint
  if (!is.null(poly) && nrow(poly) == 0) poly <- NULL
  if (is.null(poly)) {
    poly <- tryCatch({
      opq(bbox = query) |>
        add_osm_feature("boundary", "administrative") |>
        osmdata_sf() |>
        (\(x) x$osm_multipolygons)()
    }, error = function(e) NULL)
    if (!is.null(poly) && nrow(poly) == 0) poly <- NULL
  }
  
  # 2) If still nothing, fall back to your existing Nominatim polygon/bbox
  if (is.null(poly)) {
    poly <- tryCatch(osmdata::getbb(query, format_out = "sf_polygon"),
                     error = function(e) NULL)
    if (is.null(poly)) {
      bb <- osmdata::getbb(query)
      if (is.null(bb)) return(NULL)
      poly <- sf::st_as_sf(sf::st_sfc(sf::st_polygon(list(rbind(
        c(bb["x","min"], bb["y","min"]),
        c(bb["x","min"], bb["y","max"]),
        c(bb["x","max"], bb["y","max"]),
        c(bb["x","max"], bb["y","min"]),
        c(bb["x","min"], bb["y","min"])
      ))), crs = 4326))
    }
  }
  
  # 3) Pick one polygon if multiple (keep your area heuristic, but simpler)
  if (inherits(poly, "sf") && nrow(poly) > 1) {
    sf::sf_use_s2(FALSE)
    a <- as.numeric(sf::st_area(poly)) / 1e6
    sf::sf_use_s2(TRUE)
    poly <- poly[which.max(a), ]
  }
  
  poly <- tryCatch(sf::st_make_valid(poly), error = function(e) poly)
  
  # 4) Area check + 25km cap as last resort
  area_sq_km <- sum(as.numeric(sf::st_area(poly))) / 1e6
  message("    Area: ", round(area_sq_km, 2), " km sq")
  
  if (area_sq_km > 1000) {
    message("    Area > 1000 km sq. Clipping to 25km radius from centroid.")
    sf::sf_use_s2(FALSE)
    centroid <- sf::st_centroid(sf::st_union(poly))
    buffer <- sf::st_buffer(centroid, dist = 25000)
    poly <- sf::st_intersection(poly, buffer)
    sf::sf_use_s2(TRUE)
  }
  
  poly
}
