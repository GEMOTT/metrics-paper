# R/05_build_final_city_dataset.R: build final city-level modelling dataset

region_mapping <- c(
  "Denmark" = "Northern", "Estonia" = "Northern", "Finland" = "Northern",
  "Iceland" = "Northern", "Ireland" = "Northern", "Latvia" = "Northern",
  "Lithuania" = "Northern", "Norway" = "Northern", "Sweden" = "Northern",
  "United Kingdom" = "Northern",
  
  "Austria" = "Western", "Belgium" = "Western", "France" = "Western",
  "Germany" = "Western", "Luxembourg" = "Western", "Netherlands" = "Western",
  "Switzerland" = "Western",
  
  "Albania" = "Southern", "Croatia" = "Southern", "Cyprus" = "Southern",
  "Greece" = "Southern", "Italy" = "Southern", "Malta" = "Southern",
  "Montenegro" = "Southern", "North Macedonia" = "Southern",
  "Portugal" = "Southern", "Serbia" = "Southern", "Slovenia" = "Southern",
  "Spain" = "Southern", "Turkey" = "Southern",
  
  "Bulgaria" = "Eastern", "Czech Republic" = "Eastern", "Hungary" = "Eastern",
  "Poland" = "Eastern", "Romania" = "Eastern", "Slovakia" = "Eastern"
)

missing_countries <- setdiff(sort(unique(qol_q5$country)), names(region_mapping))
missing_countries

final_city_model_data <- qol_q5 |>
  left_join(city_lengths_all, by = c("country", "city_name")) |>
  mutate(
    bike_share_pct = bike_prop * 100,
    cycle_km_per_1000 = total_cycle_km / (population / 1000),
    density = population / area_km2,
    segregated_km = segregated_wide_km + segregated_narrow_km,
    segregated_pct_network = 100 * segregated_km / total_road_km,
    painted_pct_network = 100 * painted_km / total_road_km,
    off_road_pct_network = 100 * off_road_km / total_road_km,
    shared_pct_network = 100 * shared_footway_km / total_road_km,
    high_los_pct_network = 100 * high_los_km / total_road_km,
    region = unname(region_mapping[country]),
    region = if_else(is.na(region), "Other", region)
  ) |>
  select(
    country, region, city_name, population, area_km2, density, total_sample,
    bike_prop, bike_share_pct,
    total_cycle_km, total_road_km,
    off_road_km, segregated_wide_km, segregated_narrow_km, segregated_km,
    painted_km, shared_footway_km, high_los_km,
    cycle_km_per_1000,
    segregated_pct_network, painted_pct_network,
    off_road_pct_network, shared_pct_network, high_los_pct_network
  )

readr::write_csv(final_city_model_data, "outputs/final_city_model_data.csv")

final_city_model_data