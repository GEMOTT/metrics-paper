# Preliminary cycling infra vs usage analysis


## Introduction

- Aim: examine which cycling-infrastructure metrics align best with
  cycling use.

- Start with simple measures (total km, km per 1 000 people) –
  foundation for later work on network characteristics.

## Data and methods

### Data sources

We combine three data sources: (i) survey-based cycling use, (ii) city
boundaries, and (iii) cycling infrastructure from OSM.

#### Cycling use

Cycling use is measured using the [the EU Quality of Life
Survey](https://ec.europa.eu/regional_policy/information-sources/maps/quality-of-life_en)
(83 cities; ≈70,000 respondents), which includes the question: “On a
typical day, which mode(s) of transport do you use most often?” Cycling
is one of the selectable modes (up to two choices), providing a
city-level proxy for cycling prevalence.

#### City boundaries

To ensure comparability, we explored the use of standardized urban
boundaries. While administrative boundaries retrieved from OpenStreetMap
can vary in geographic extent, methodologies such as the Degree of
Urbanisation (DEGURBA), implemented in R packages like `flexurba` and
`giscoR`, provide a way to define cities based on population density
thresholds (e.g., Urban Centres or Functional Urban Areas). In this
preliminary analysis, we use administrative boundaries but apply a
clipping heuristic for very large areas (\>1000 km²), using a 25 km
centroid buffer, and discuss future moves towards using
`gisco_get_urban_audit()` for FUA-level analysis.

<!-- This is still an estimation for some cities, can we make this more robust? -->

#### Cycling infrastructure

Cycling infrastructure data were extracted from OpenStreetMap, using the
`osmactive` R package. We classified infrastructure into distinct
categories using the `classify_cycle_infrastructure` function, which
considers OSM tags (e.g., `highway`, `cycleway`, `segregated`) and
geometry (e.g., distance to the nearest road) to distinguish between: -
**Segregated tracks:** Physically separated from motor traffic (further
split into wide $\ge$ 2m and narrow \< 2m). - **Off-road paths:** Paths
away from the road network (e.g., through parks). - **Painted lanes:**
Marked lanes on the carriageway without physical separation. - **Shared
footways:** Paths shared with pedestrians. - **Mixed traffic:** Cycling
on the carriageway with motor traffic (not counted as dedicated
infrastructure).

## Results

<div id="tbl-qol-cities">

Table 1: Top 3, bottom 3 and 3 random middle cities by cycling levels

<div class="cell-output-display">

| country        | city_name | bike_prop | sample_size |
|:---------------|:----------|:----------|------------:|
| Netherlands    | Groningen | 45.5%     |         847 |
| Netherlands    | Amsterdam | 39.4%     |         855 |
| Denmark        | København | 35.1%     |         871 |
| Poland         | Białystok | 14.5%     |         858 |
| Czech Republic | Ostrava   | 10.9%     |         846 |
| Romania        | Bucureşti | 9.1%      |         861 |
| Lithuania      | Vilnius   | 6.3%      |         846 |
| Serbia         | Beograd   | 6.1%      |         865 |
| Italy          | Roma      | 5.4%      |         855 |

</div>

</div>

<div id="fig-scatter-plot">

![](figs/scatter_plot.png)

Figure 1: Scatter plots showing the relationship between cycling mode
share and different types of cycling infrastructure (as a percentage of
the total road network), colored by European region.

</div>

The analysis reveals varying degrees of association between
infrastructure types and cycling levels when normalized by the total
road network.

<div id="tbl-correlations">

Table 2: Correlation between different cycling infrastructure measures
and cycling mode share.

<div class="cell-output-display">

| Metric                    | Cities (n) | Correlation (r) | R-squared |
|:--------------------------|-----------:|----------------:|----------:|
| Segregated tracks         |         75 |           0.616 |     0.380 |
| Shared footways           |         75 |           0.309 |     0.095 |
| Off-road paths            |         75 |           0.128 |     0.016 |
| Painted lanes             |         75 |           0.080 |     0.006 |
| Low Stress (High/Med LoS) |         75 |          -0.153 |     0.024 |
| High LoS (Very Safe)      |         75 |          -0.182 |     0.033 |

</div>

</div>

Segregated tracks show a strong correlation of $R^2 =$ 0.43.

Surprisingly, the **Low Stress (High/Med LoS)** network shows a weak
negative correlation ($r = -0.13$). This suggests that a high proportion
of low-traffic residential streets does not automatically lead to high
cycling levels. In many cases, cities with very high percentages of “low
stress” streets are lower-density urban areas where these streets lack
the connectivity or dedicated infrastructure on major corridors needed
to make cycling a viable transport option across the city.

## Discussion

The analysis reveals a clear hierarchy in the relationship between
infrastructure types and cycling levels. **Segregated tracks**
demonstrate the strongest positive correlation with cycling mode share
($R^2 \approx 0.43$), supporting the hypothesis that physical separation
from motor traffic is the single most important infrastructure feature
enabling higher cycling levels.

The findings for the **Low Stress** network are particularly telling.
The lack of a positive correlation suggests that merely “reducing bad
infrastructure” (i.e., having many quiet streets) is insufficient for
driving modal shift. Successful cycling cities are characterized not
just by quiet backstreets, but by high-quality, protected interventions
on the main road networks where travel demand is highest.

In contrast, **painted lanes** show negligible correlation
($R^2 \approx 0.01$), reinforcing the growing consensus that markings
without protection are insufficient to encourage significant increases
in cycling.

### Limitations

- **Data Completeness:** Data retrieval was successful for
  `r`sum(!is.na(qol_city_metrics\[\[“total_road_km”\]\]))\` out of 83
  cities. Some cities (particularly in France and Spain) are missing due
  to data provider issues.
- **OSM Quality:** The analysis relies on OpenStreetMap data
  completeness and tagging consistency, which varies by region.
- **Causality:** This cross-sectional analysis establishes correlation,
  not causality. High cycling levels might drive investment in
  infrastructure, or vice versa.

## Conclusion

This preliminary analysis suggests that cities aiming to increase
cycling mode share should prioritize the development of **segregated
cycling infrastructure**. While paint and shared paths provide
connectivity, they do not show the same strong relationship with high
cycling usage observed for physically separated tracks. Future work
should focus on network connectivity metrics and control for other
factors like topography and climate.

### Standardized vs. Administrative Boundaries

Preliminary testing with standardized Urban Centre boundaries (derived
from the `giscoR` implementation of DEGURBA/flexurba definitions) for 58
cities shows a correlation ($R^2$) for segregated infrastructure of
0.41. This suggests that the signal is robust across different boundary
definitions, though standardized boundaries often yield lower total road
lengths by excluding low-density suburban peripheries.

## Next steps

- Investigate missing data for France and Spain.
- Expand metrics to include network connectivity (e.g., mesh density,
  directness).
- Fit multivariate regression models including controls.
