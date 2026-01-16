# Preliminary cycling infra vs usage analysis


## Introduction

- Aim: examine which cycling-infrastructure metrics align best with
  cycling use.

- Start with simple measures (total km, km per 1 000 people) –
  foundation for later work on network characteristics.

## Data and methods

- Cycling infrastructure from OSM, `osmactive` R package. We classified
  infrastructure into distinct categories using the
  `classify_cycle_infrastructure` function, which considers OSM tags
  (e.g., `highway`, `cycleway`, `segregated`) and geometry (e.g.,
  distance to the nearest road) to distinguish between:

  - **Segregated tracks:** Physically separated from motor traffic
    (further split into wide $\ge$ 2m and narrow \< 2m).
  - **Off-road paths:** Paths away from the road network (e.g., through
    parks).
  - **Painted lanes:** Marked lanes on the carriageway without physical
    separation.
  - **Shared footways:** Paths shared with pedestrians.
  - **Mixed traffic:** Cycling on the carriageway with motor traffic
    (not counted as dedicated infrastructure).

- Cycling use from [the EU Quality of Life
  Survey](https://ec.europa.eu/regional_policy/information-sources/maps/quality-of-life_en).
  83 cities, ≈ 70,000 respondents; includes a transport question (“On a
  typical day, which mode(s) of transport do you use most often?” ),
  where cycling is one of the selectable modes (up to two choices
  allowed), providing a simple city-level proxy for cycling use. There
  are previous editions.

- **Standardized City Boundaries:** To ensure comparability, we explored
  using standardized urban boundaries. While administrative boundaries
  (retrieved from OpenStreetMap) are often inconsistent in geographic
  extent, methodologies such as the Degree of Urbanisation (DEGURBA),
  implemented in R packages like `flexurba` and `giscoR`, provide a way
  to define cities based on population density thresholds (e.g., Urban
  Centres or Functional Urban Areas). In this preliminary analysis, we
  use administrative boundaries but apply a clipping heuristic for very
  large areas (\>1000 km²) and discuss future moves towards using
  `gisco_get_urban_audit()` for FUA-level analysis.

<!-- ### Potential cycling-use datasets -->

<!-- - **Eurostat: journeys to work by bicycle**   -->

<!--   Patchy coverage, many cities missing.   -->

<!--   https://ec.europa.eu/eurostat/databrowser/view/urb_ctran__custom_18909106/default/table -->

<!-- - **Bicycle counter data (Kraus and Koch, PNAS)**   -->

<!--   Only for cities with counters.   -->

<!--   https://www.pnas.org/doi/10.1073/pnas.2024399118   -->

<!--   Data: https://zenodo.org/records/4015974 -->

<!-- - **Cycling mode share in 864 European cities (Sobral et al.)**   -->

<!--   Interesting working project, modelled values.   -->

<!--   https://www.cyclingandsociety.org/wp-content/uploads/2025/09/CyclingAndSociety2025-4-Sobral.pdf -->

<!-- - **Quality of Life in European Cities survey (DG REGIO)**   -->

<!--   83 cities, >70,000 respondents; includes question   -->

<!--   “On a typical day, which mode(s) do you use most often? Bicycle”.   -->

<!--   https://ec.europa.eu/regional_policy/information-sources/maps/quality-of-life_en -->

<!-- *the QoL survey seems to provide the most consistent city-level cycling-use indicator across many cities. IS 83 sample enough?* -->

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

Top 3, bottom 3 and 3 random middle cities by cycling levels

</div>

</div>

## Results

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

Segregated tracks show a strong correlation of $R^2 =$ 0.38.

Surprisingly, the **Low Stress (High/Med LoS)** network shows a weak
negative correlation ($r = -0.15$). This suggests that a high proportion
of low-traffic residential streets does not automatically lead to high
cycling levels. In many cases, cities with very high percentages of “low
stress” streets are lower-density urban areas where these streets lack
the connectivity or dedicated infrastructure on major corridors needed
to make cycling a viable transport option across the city.

## Discussion

The analysis reveals a clear hierarchy in the relationship between
infrastructure types and cycling levels. **Segregated tracks**
demonstrate the strongest positive correlation with cycling mode share
($R^2 \approx 0.38$), supporting the hypothesis that physical separation
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

- **Data Completeness:** Data retrieval was successful for 82 out of 83
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

## Next steps

- Investigate missing data for France and Spain.
- Expand metrics to include network connectivity (e.g., mesh density,
  directness).
- Fit multivariate regression models including controls.
