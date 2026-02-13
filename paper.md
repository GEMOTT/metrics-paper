# Physical cycling infrastructure and cycling use


## Introduction

- Cycling is widely promoted in European cities to improve public
  health, reduce emissions, and enhance urban liveability.

- Infrastructure provision is commonly assumed to be a key determinant
  of cycling uptake.

- However, not all types of cycling infrastructure offer the same level
  of protection, comfort, or perceived safety.

- Much of the existing evidence relies on single-city case studies or
  intervention-based evaluations.

- Comparative cross-city analyses that distinguish between
  infrastructure types remain limited.

- Infrastructure is often measured in aggregate terms, without
  differentiating between facility composition and quality.

- A harmonised, multi-city assessment can help clarify which physical
  infrastructure metrics are most strongly associated with cycling
  levels.

- This is particularly relevant for policy, as cities must decide not
  only how much infrastructure to build, but what kind.

- **Aim**: To examine how physical cycling infrastructure metrics are
  associated with city-level cycling use across European cities.

## Data and methods

### Data sources

We combine three data sources: (i) survey-based cycling use, (ii) city
boundaries, and (iii) cycling infrastructure from OSM.

#### Cycling use

Cycling use is measured using the [the EU Quality of Life
Survey](https://ec.europa.eu/regional_policy/information-sources/maps/quality-of-life_en)
(83 cities; ≈70,000 respondents), which includes the question: “On a
typical day, which mode(s) of transport do you use most often?”. Cycling
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
geometry (e.g., distance to the nearest road) to distinguish between:

- **Segregated tracks:** Physically separated from motor traffic
  (further split into wide $\ge$ 2m and narrow \< 2m).
- **Off-road paths:** Paths away from the road network (e.g., through
  parks).
- **Painted lanes:** Marked lanes on the carriageway without physical
  separation.
- **Shared footways:** Paths shared with pedestrians.

<!-- -   **Mixed traffic:** Cycling on the carriageway with motor traffic (not counted as dedicated infrastructure). -->

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

| Metric            | Cities (n) | Correlation (r) | R-squared |
|:------------------|-----------:|----------------:|----------:|
| Segregated tracks |         83 |           0.655 |     0.430 |
| Off-road paths    |         83 |           0.426 |     0.181 |
| Shared footways   |         83 |           0.278 |     0.077 |
| Painted lanes     |         83 |           0.118 |     0.014 |

</div>

</div>

Segregated tracks show a strong correlation of $R^2 =$ 0.43.

<!-- Surprisingly, the **Low Stress (High/Med LoS)** network shows a weak negative correlation ($r = NA$). This suggests that a high proportion of low-traffic residential streets does not automatically lead to high cycling levels. In many cases, cities with very high percentages of "low stress" streets are lower-density urban areas where these streets lack the connectivity or dedicated infrastructure on major corridors needed to make cycling a viable transport option across the city. -->

## Discussion

The analysis reveals a clear hierarchy in the relationship between
infrastructure types and cycling levels. **Segregated tracks**
demonstrate the strongest positive correlation with cycling mode share
($R^2 \approx 0.43$), supporting the hypothesis that physical separation
from motor traffic is the single most important infrastructure feature
enabling higher cycling levels.

<!-- The findings for the **Low Stress** network are particularly telling. The lack of a positive correlation suggests that merely "reducing bad infrastructure" (i.e., having many quiet streets) is insufficient for driving modal shift. Successful cycling cities are characterized not just by quiet backstreets, but by high-quality, protected interventions on the main road networks where travel demand is highest. -->

In contrast, **painted lanes** show negligible correlation
($R^2 \approx 0.01$), reinforcing the growing consensus that markings
without protection are insufficient to encourage significant increases
in cycling.

Other facility types, such as **off-road paths** and **shared
footways**, display more modest associations with cycling levels. While
these facilities may contribute to local connectivity or recreational
cycling, they do not exhibit the same strong relationship with city-wide
cycling mode share as segregated tracks.

### Limitations

<!-- -   **Data Completeness:** Data retrieval was successful for 83 out of 83 cities.  -->

- **OSM Quality:** The analysis relies on OpenStreetMap data
  completeness and tagging consistency, which varies by region.
- **Causality:** This cross-sectional analysis establishes correlation,
  not causality. High cycling levels might drive investment in
  infrastructure, or vice versa.

## Conclusion

Our findings suggest that cities aiming to increase cycling mode share
should prioritize the development of **segregated cycling
infrastructure**. While paint and shared paths provide connectivity,
they do not show the same strong relationship with high cycling usage
observed for physically separated tracks.

Future research should extend this infrastructure-based approach by
incorporating network connectivity metrics (e.g., directness, mesh
density, network continuity) to assess not only the quantity but also
the structural coherence of cycling infrastructure.

A complementary extension would integrate traffic-stress measures (e.g.,
Level of Service classifications) to jointly examine infrastructure
provision and cycling conditions.

Finally, multivariate models including urban density, land-use mix,
topography, and climate would help disentangle infrastructure effects
from broader structural determinants of cycling.

<!-- ### Standardized vs. Administrative Boundaries -->

<!-- Preliminary testing with standardized Urban Centre boundaries (derived from the `giscoR` implementation of DEGURBA/flexurba definitions) for  cities shows a correlation ($R^2$) for segregated infrastructure of NA. This suggests that the signal is robust across different boundary definitions, though standardized boundaries often yield lower total road lengths by excluding low-density suburban peripheries. -->

<!-- ## Next steps -->

<!-- -   Investigate missing data for France and Spain. -->

<!-- -   Expand metrics to include network connectivity (e.g., mesh density, directness). -->

<!-- -   Fit multivariate regression models including controls. -->
