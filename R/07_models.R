# main models
m1 <- lm(
  bike_share_pct ~ cycle_km_per_1000,
  data = final_city_model_data
)

m2 <- lm(
  bike_share_pct ~
    segregated_pct_network +
    painted_pct_network,
  data = final_city_model_data
)

m3 <- lm(
  bike_share_pct ~
    cycle_km_per_1000 +
    segregated_pct_network +
    painted_pct_network +
    region,
  data = final_city_model_data
)

# robustness: add density
m3_density <- lm(
  bike_share_pct ~
    cycle_km_per_1000 +
    segregated_pct_network +
    painted_pct_network +
    region +
    density,
  data = final_city_model_data
)

# diagnostics on main model
car::vif(m3)

cook <- cooks.distance(m3)

influential_cities <- final_city_model_data |>
  mutate(cook = cook) |>
  arrange(desc(cook)) |>
  select(city_name, country, bike_share_pct, cook)

high_influence <- cook > 0.1

# robustness: exclude influential cities
m3_robust <- lm(
  bike_share_pct ~
    cycle_km_per_1000 +
    segregated_pct_network +
    painted_pct_network +
    region,
  data = final_city_model_data[!high_influence, ]
)

# robustness: log outcome
final_city_model_data <- final_city_model_data |>
  mutate(log_bike = log(bike_share_pct + 0.1))

m3_log <- lm(
  log_bike ~
    cycle_km_per_1000 +
    segregated_pct_network +
    painted_pct_network +
    region,
  data = final_city_model_data
)
