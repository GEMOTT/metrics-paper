# R/05_regions_and_join.R: Region mapping and analysis dataset 

# Country -> region lookup (UN geoscheme-inspired)
region_mapping <- c(
  "Denmark" = "Northern", "Estonia" = "Northern", "Finland" = "Northern",
  "Iceland" = "Northern", "Ireland" = "Northern", "Latvia" = "Northern",
  "Lithuania" = "Northern", "Sweden" = "Northern", "United Kingdom" = "Northern",
  "Norway" = "Northern",
  
  "Austria" = "Western", "Belgium" = "Western", "France" = "Western",
  "Germany" = "Western", "Luxembourg" = "Western", "Netherlands" = "Western",
  "Switzerland" = "Western",
  
  "Albania" = "Southern", "Croatia" = "Southern", "Cyprus" = "Southern",
  "Greece" = "Southern", "Italy" = "Southern", "Malta" = "Southern",
  "Montenegro" = "Southern", "Portugal" = "Southern", "Serbia" = "Southern",
  "Slovenia" = "Southern", "Spain" = "Southern", "Macedonia" = "Southern",
  "Turkey" = "Southern",
  
  "Bulgaria" = "Eastern", "Czech Republic" = "Eastern", "Hungary" = "Eastern",
  "Poland" = "Eastern", "Romania" = "Eastern", "Slovakia" = "Eastern"
)

# check unmapped countries
missing <- setdiff(sort(unique(qol_q5$country)), names(region_mapping))
if (length(missing)) missing

qol_city_metrics <- qol_q5 |>
  left_join(city_lengths_all, by = c("country", "city_name")) |>
  mutate(
    bike_share_pct    = bike_prop * 100,
    infra_km_per_1000 = total_cycle_km / (population / 1000),
    region            = unname(region_mapping[country]),
    region            = if_else(is.na(region), "Other", region)
  )

qol_city_metrics |>
  select(country, region, city_name, population, bike_share_pct, infra_km_per_1000)