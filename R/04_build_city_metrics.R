# R/04_city_metrics_batch.R: Batch run to build/update city metrics table

# 0. All cities present in the QoL data
cities_all <- qol_q5 |>
  select(country, city_name) |>
  distinct() |>
  mutate(across(everything(), as.character)) |>
  arrange(country, city_name)

# 1. Load previous city lengths if they exist
if (file.exists("outputs/city_lengths_all.csv")) {
  city_lengths_all <- read_csv("outputs/city_lengths_all.csv", show_col_types = FALSE) |>
    mutate(across(where(is.numeric), ~ round(., 2)))
  cols_to_add <- c("total_road_km", "off_road_km", "segregated_wide_km", "segregated_narrow_km", "painted_km", "shared_footway_km", "high_los_km")
  for (col in cols_to_add) {
    if (!col %in% names(city_lengths_all)) {
      city_lengths_all[[col]] <- NA_real_
    }
  }
} else {
  city_lengths_all <- tibble(
    country           = character(),
    city_name         = character(),
    total_cycle_km    = numeric(),
    total_road_km     = numeric(),
    off_road_km       = numeric(),
    segregated_wide_km = numeric(),
    segregated_narrow_km = numeric(),
    painted_km        = numeric(),
    shared_footway_km = numeric(),
    high_los_km       = numeric()
  )
}

# 2. Work out which cities already have lengths in the RDS (with new columns)
# Check for high_los_km to ensure we have the latest metrics
if ("high_los_km" %in% names(city_lengths_all)) {
  cities_done <- city_lengths_all |>
    filter(!is.na(high_los_km)) |>
    select(country, city_name)
} else {
  cities_done <- tibble(country = character(), city_name = character())
}

cities_todo <- cities_all |>
  anti_join(cities_done, by = c("country", "city_name"))

message("Cities to process: ", nrow(cities_todo))

# 3. Loop over remaining cities, saving as we go
if (nrow(cities_todo) > 0) {
  dir.create("outputs", showWarnings = FALSE)
  
  start_time <- Sys.time()
  
  for (i in seq_len(nrow(cities_todo))) {
    cty <- cities_todo$country[i]
    city <- cities_todo$city_name[i]
    
    res <- try({
      get_city_metrics(city, cty)
    }, silent = TRUE)
    
    if (inherits(res, "try-error")) {
      warning("Failed for ", city, ": ", conditionMessage(attr(res, "condition")))
      next
    }
    
    if (is.null(res)) next
    
    # Update combined table and save after each city
    city_lengths_all <- city_lengths_all |>
      filter(!(country == cty & city_name == city)) |>
      bind_rows(res)
    
    write_csv(city_lengths_all, "outputs/city_lengths_all.csv")
    message("Saved updated city_lengths_all.csv")
  }
  
  end_time <- Sys.time()
  timing_msg <- paste0("Processed ", nrow(cities_todo), " cities in ", round(as.numeric(difftime(end_time, start_time, units = "secs")), 2), " seconds.")
  message(timing_msg)
} else {
  message("No new cities to process. All done.")
}
city_lengths_all

# test-classification
# # Test the classification logic on a small country/city (Monaco)
# message("Running classification test for Monaco...")
# # We use try() to allow the document to render even if the test fails (e.g. internet issues)
# test_result <- try({
#   get_city_metrics("Monaco", "Monaco")
# }, silent = TRUE)
# 
# if (inherits(test_result, "try-error")) {
#   message("Test failed: ", conditionMessage(attr(test_result, "condition")))
# } else {
#   print(test_result)
# }