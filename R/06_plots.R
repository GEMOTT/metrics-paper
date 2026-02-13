# R/06_figures.R: Plots and visualisations

plot_data <- qol_city_metrics |>
  mutate(
    segregated_km = segregated_wide_km + segregated_narrow_km
  )

# Create long format for faceting
plot_data_long <- plot_data |>
  # Select relevant columns
  transmute(
    city_name,
    region,
    bike_share_pct,
    population,
    total_road_km,
    off_road_km,
    segregated_km,
    painted_km,
    shared_footway_km) |>
  pivot_longer(
    cols = c(off_road_km, segregated_km, painted_km, shared_footway_km),
    names_to = "infra_type",
    values_to = "km"
  ) |>
  mutate(
    pct_network = (km / total_road_km) * 100,
    infra_type_label = factor(infra_type, 
                              levels = c("segregated_km", "off_road_km", "painted_km", "shared_footway_km"),
                              labels = c("Segregated tracks", "Off-road paths", "Painted lanes", "Shared footways")
    )
  )

# Calculate R-squared values associated with each infrastructure type with dplyr nest/map
cor_data <- plot_data_long |>
  group_by(infra_type_label) |>
  summarise(
    n_cities   = n(),
    correlation = cor(pct_network, bike_share_pct, use = "complete.obs"),
    r_squared  = cor(pct_network, bike_share_pct, use = "complete.obs")^2
  ) |>
  ungroup()

cor_data_labels <- cor_data |>
  mutate(
    label_text = paste0(
      infra_type_label, "\n",
      "R² = ", round(r_squared, 2), 
      " (n = ", n_cities, ")"
    )
  ) |>
  select(infra_type_label, label_text)

# Join R2 labels back to plot data
plot_data_long <- plot_data_long |>
  left_join(cor_data_labels, by = "infra_type_label")

set.seed(123)

scatter_plot <- ggplot(
  plot_data_long,
  aes(
    x      = pct_network,
    y      = bike_share_pct,
    size   = population,
    colour = region
  )
) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE,
              colour = "grey40", linewidth = 0.5, linetype = "dashed") +
  facet_wrap(~label_text, scales = "free_x") +
  ggrepel::geom_text_repel(
    aes(label = city_name),
    size         = 2.5,
    show.legend  = FALSE,
    max.overlaps = 10
  ) +
  scale_size_continuous(
    name   = "Population",
    labels = scales::label_number(scale_cut = scales::cut_short_scale()),
    range  = c(1, 4),
    guide  = guide_legend(override.aes = list(alpha = 1, colour = "grey60"))
  ) +
  labs(
    x = "Infrastructure (% of total road network)",
    y = "Cycling mode share (%)",
    colour = "Region",
    title  = "Cycling levels vs. Infrastructure Composition"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title       = element_text(face = "bold"),
    panel.grid.minor = element_blank(),
    legend.position  = "bottom",
    strip.text       = element_text(face = "bold")
  )

# scatter_plot

dir.create("figs", showWarnings = FALSE)
ggsave("figs/scatter_plot.png", bg = "white", width = 10, height = 7)
r2_vals <- setNames(cor_data$r_squared, cor_data$infra_type_label)
r_vals <- setNames(round(cor_data$correlation, 2), cor_data$infra_type_label)

# Highlight top cities for High LoS
top_high_los <- plot_data |>
  mutate(high_los_pct = (high_los_km / total_road_km) * 100) |>
  arrange(desc(high_los_pct)) |>
  select(city_name, country, high_los_pct, bike_share_pct) |>
  head(10)