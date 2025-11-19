

This repo contains reproducible code to support a paper on measuring
cycling network quality.

The aim is to compare different ways of measuring cycle network quality
between major cities and to evaluate these measures against actual
cycling usage data.

## cycling network quality

The starting point is Paris so we will focus on that city first.

We can put everything in this REAMDE.qmd file for now, and arrange the
repo structure later.

``` r
# remotes::install_github("nptscot/osmactive")
library(osmactive)
library(tidyverse)
library(readr)
library(knitr)
```

We can calculate a measures of cycle network quality just from this:

The first three metrics for Paris are:

The next step is to estimate level of service with the following
function:

## cycling usage

## cycling network vs usage

``` r
library(ggrepel)
library(scales)

names(analysis_test)
```

    [1] "country"           "city_name"         "population"       
    [4] "bike_sample"       "total_sample"      "bike_prop"        
    [7] "total_cycle_km"    "bike_share_pct"    "infra_km_per_1000"

``` r
plot_data <- analysis_test |>
  filter(
    !is.na(infra_km_per_1000),
    !is.na(bike_share_pct),
    infra_km_per_1000 <= 10,
    population > 500000,
    country != "Turkey"# some cities boundaries seem wrong -- too much infra! We need to solve this
)


scatter_plot <- ggplot(
  plot_data,
  aes(
    x      = infra_km_per_1000,
    y      = bike_share_pct,
    size   = population,
    colour = country
  )
) +
  geom_point(alpha = 0.75) +
  geom_smooth(method = "lm", se = FALSE,
              colour = "grey40", linewidth = 0.5, linetype = "dashed") +
  ggrepel::geom_text_repel(
    aes(label = city_name),
    size         = 3,
    show.legend  = FALSE,
    max.overlaps = 20
  ) +
  scale_size_continuous(
    name   = "Population",
    labels = scales::label_number(scale_cut = scales::cut_short_scale()),
    range  = c(2, 9),
    guide  = guide_legend(override.aes = list(alpha = 1))
  ) +
  labs(
    x = "Cycling infrastructure (km per 1 000 residents)",
    y = "Cycling as main mode (%)",
    title  = "Cycling levels and cycling infrastructure"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title       = element_text(face = "bold"),
    panel.grid.minor = element_blank()
  ) +
  guides(colour = "none")      # remove country legend

scatter_plot
```

![](README_files/figure-commonmark/unnamed-chunk-6-1.png)

``` r
ggsave("figs/scatter_plot.png", bg = "white")
```
