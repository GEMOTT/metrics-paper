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

- **Aim**: This study examines how the amount and composition of cycling
  infrastructure are associated with cycling levels across 83 European
  cities.

## Data and methods

### Data sources

We combine three data sources: (i) survey-based cycling use, (ii) city
boundaries, and (iii) cycling infrastructure derived from OpenStreetMap
(OSM).

### Cycling use

Cycling use is measured using the EU Quality of Life Survey (83 cities;
approximately 70,000 respondents), which includes the question: *“On a
typical day, which mode(s) of transport do you use most often?”*
Respondents can select up to two modes. Cycling is one of the available
options, allowing us to derive a city-level proxy for cycling
prevalence.

For each city, we compute the percentage of respondents reporting
cycling as one of their main modes of transport. This aggregated measure
is used as the dependent variable in the analysis.

### City boundaries

To ensure comparability across cities, we explored the use of
standardised urban boundaries. Administrative boundaries retrieved from
OpenStreetMap can vary in geographic extent, potentially affecting
infrastructure measures.

Alternative approaches such as the Degree of Urbanisation (DEGURBA),
implemented in R packages such as `flexurba` and `giscoR`, allow cities
to be defined based on population density thresholds (e.g. Urban Centres
or Functional Urban Areas). In this preliminary analysis, we rely on
administrative boundaries, but apply a clipping heuristic for very large
cities (\>1000 km²), using a 25 km buffer around the city centroid to
limit spatial extent.

### Cycling infrastructure

Cycling infrastructure data were extracted from OpenStreetMap using the
`osmactive` R package. The full transport network was retrieved and
filtered to obtain cycling-related infrastructure.

Infrastructure was classified into distinct categories using the
`classify_cycle_infrastructure()` function, which combines OSM tags
(e.g. `highway`, `cycleway`, `segregated`) with geometric information
(e.g. distance to the nearest road). This allows distinguishing between:

- **Segregated tracks**: physically separated from motor traffic
  (further divided into wide $\geq$ 2 m and narrow \< 2 m)
- **Off-road paths**: routes away from the road network (e.g. parks,
  greenways)
- **Painted lanes**: marked lanes on the carriageway without physical
  separation
- **Shared footways**: infrastructure shared with pedestrians

### Variable construction

Cycling use is aggregated at the city level to match the spatial scale
of infrastructure variables.

The main independent variables capture both the **amount** and
**composition** of cycling infrastructure:

- **Total provision** is measured as kilometres of cycling
  infrastructure per 1,000 inhabitants (`cycle_km_per_1000`).
- **Infrastructure composition** is measured as the share of the total
  road network corresponding to each infrastructure type
  (e.g. `segregated_pct_network`, `painted_pct_network`).

Total road length is derived from the OSM road network and used to
normalise infrastructure measures across cities.

All variables are constructed to ensure comparability across cities of
different sizes.

In addition, models include **regional fixed effects** (Northern,
Southern, Western, and Other Europe) to account for broad geographic and
contextual differences across cities.

Population density was explored as an additional control variable, but
results were not sensitive to its inclusion.

### Statistical analysis

We first conduct a descriptive analysis, including summary statistics
and scatter plots, to explore bivariate relationships between cycling
levels and different infrastructure measures.

We then estimate a series of linear regression models to examine the
association between cycling infrastructure and cycling levels.

Three model specifications are considered:

1.  **Total provision model**, including only overall infrastructure
    provision
2.  **Infrastructure type model**, including shares of different
    infrastructure types
3.  **Combined model**, including both total provision and key
    infrastructure types, alongside regional controls

To assess robustness, we estimate additional specifications excluding
influential observations (based on Cook’s distance), including
population density, and using a log-transformed dependent variable.

All models are estimated using ordinary least squares (OLS), and
standard diagnostic checks (e.g. multicollinearity and influential
observations) are performed.

## Results

### Descriptive statistics

Table X presents descriptive statistics for the main variables used in
the analysis.

|                          |   n |     mean |       sd |    min |       max |
|:-------------------------|----:|---------:|---------:|-------:|----------:|
| Cycling mode share (%)   |  84 |    14.18 |     7.16 |   5.39 |     45.52 |
| Cycle km per 1000 people |  84 |     0.46 |     0.44 |   0.00 |      2.30 |
| Segregated (%)           |  84 |     3.71 |     4.10 |   0.00 |     16.35 |
| Painted (%)              |  84 |     2.64 |     3.60 |   0.00 |     18.07 |
| Off-road (%)             |  84 |     5.15 |     5.40 |   0.00 |     32.27 |
| Shared (%)               |  84 |     2.18 |     2.52 |   0.00 |     14.91 |
| Population density       |  84 | 11162.40 | 35055.24 | 102.78 | 305365.48 |

Descriptive statistics

Cycling levels vary substantially across cities, ranging from around 5%
to over 45%.

Table X illustrates the range of cycling levels across selected cities.

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

<!-- The analysis reveals varying degrees of association between infrastructure types and cycling levels when normalized by the total road network. -->

Segregated infrastructure shows a strong positive association with
cycling levels (r = 0.63), while painted lanes show little to no
relationship.

<!-- Surprisingly, the **Low Stress (High/Med LoS)** network shows a weak negative correlation ($r = NA$). This suggests that a high proportion of low-traffic residential streets does not automatically lead to high cycling levels. In many cases, cities with very high percentages of "low stress" streets are lower-density urban areas where these streets lack the connectivity or dedicated infrastructure on major corridors needed to make cycling a viable transport option across the city. -->

### Statistical analysis

Across all model specifications, both the amount and type of cycling
infrastructure are associated with cycling levels. Higher infrastructure
provision is consistently linked to higher cycling mode share, with an
increase of around 3–5 percentage points per additional kilometre per
1,000 inhabitants. The share of segregated infrastructure shows a strong
and robust positive association across all models, while painted
infrastructure shows no consistent relationship and is negative in some
specifications.

Regional differences are observed, with cities in Western Europe showing
higher cycling levels compared to the reference category. Including
population density does not materially change the results, and findings
remain stable when excluding influential observations and when using a
log-transformed outcome. Overall, the models explain a substantial share
of variation in cycling levels (R² ≈ 0.50–0.55).

<table style="width:97%;">
<colgroup>
<col style="width: 27%" />
<col style="width: 14%" />
<col style="width: 13%" />
<col style="width: 26%" />
<col style="width: 15%" />
</colgroup>
<thead>
<tr>
<th></th>
<th>Main model</th>
<th><ul>
<li>density</li>
</ul></th>
<th>No influential cities</th>
<th>Log outcome</th>
</tr>
</thead>
<tbody>
<tr>
<td>(Intercept)</td>
<td>8.306***</td>
<td>8.309***</td>
<td>8.860***</td>
<td>2.208***</td>
</tr>
<tr>
<td></td>
<td>(1.432)</td>
<td>(1.445)</td>
<td>(1.079)</td>
<td>(0.084)</td>
</tr>
<tr>
<td>cycle_km_per_1000</td>
<td>4.134**</td>
<td>4.124*</td>
<td>3.253**</td>
<td>0.257**</td>
</tr>
<tr>
<td></td>
<td>(1.546)</td>
<td>(1.585)</td>
<td>(1.175)</td>
<td>(0.091)</td>
</tr>
<tr>
<td>segregated_pct_network</td>
<td>0.753***</td>
<td>0.753***</td>
<td>0.475***</td>
<td>0.039***</td>
</tr>
<tr>
<td></td>
<td>(0.169)</td>
<td>(0.171)</td>
<td>(0.135)</td>
<td>(0.010)</td>
</tr>
<tr>
<td>painted_pct_network</td>
<td>-0.349+</td>
<td>-0.349+</td>
<td>-0.193</td>
<td>-0.011</td>
</tr>
<tr>
<td></td>
<td>(0.194)</td>
<td>(0.196)</td>
<td>(0.148)</td>
<td>(0.011)</td>
</tr>
<tr>
<td>regionNorthern</td>
<td>2.724</td>
<td>2.728</td>
<td>2.570+</td>
<td>0.168</td>
</tr>
<tr>
<td></td>
<td>(1.815)</td>
<td>(1.831)</td>
<td>(1.375)</td>
<td>(0.107)</td>
</tr>
<tr>
<td>regionOther</td>
<td>0.635</td>
<td>0.635</td>
<td></td>
<td>0.095</td>
</tr>
<tr>
<td></td>
<td>(5.217)</td>
<td>(5.252)</td>
<td></td>
<td>(0.306)</td>
</tr>
<tr>
<td>regionSouthern</td>
<td>0.212</td>
<td>0.221</td>
<td>0.305</td>
<td>-0.004</td>
</tr>
<tr>
<td></td>
<td>(1.669)</td>
<td>(1.700)</td>
<td>(1.255)</td>
<td>(0.098)</td>
</tr>
<tr>
<td>regionWestern</td>
<td>4.967*</td>
<td>4.970*</td>
<td>4.277**</td>
<td>0.295*</td>
</tr>
<tr>
<td></td>
<td>(2.082)</td>
<td>(2.097)</td>
<td>(1.583)</td>
<td>(0.122)</td>
</tr>
<tr>
<td>density</td>
<td></td>
<td>-0.000</td>
<td></td>
<td></td>
</tr>
<tr>
<td></td>
<td></td>
<td>(0.000)</td>
<td></td>
<td></td>
</tr>
<tr>
<td>Num.Obs.</td>
<td>84</td>
<td>84</td>
<td>80</td>
<td>84</td>
</tr>
<tr>
<td>R2</td>
<td>0.546</td>
<td>0.546</td>
<td>0.506</td>
<td>0.543</td>
</tr>
<tr>
<td>R2 Adj.</td>
<td>0.504</td>
<td>0.497</td>
<td>0.465</td>
<td>0.501</td>
</tr>
<tr>
<td>AIC</td>
<td>519.8</td>
<td>521.8</td>
<td>448.9</td>
<td>43.5</td>
</tr>
<tr>
<td>BIC</td>
<td>541.6</td>
<td>546.1</td>
<td>467.9</td>
<td>65.4</td>
</tr>
<tr>
<td>Log.Lik.</td>
<td>-250.877</td>
<td>-250.876</td>
<td>-216.446</td>
<td>-12.754</td>
</tr>
<tr>
<td>F</td>
<td>13.036</td>
<td>11.257</td>
<td>12.438</td>
<td>12.898</td>
</tr>
<tr>
<td>RMSE</td>
<td>4.80</td>
<td>4.80</td>
<td>3.62</td>
<td>0.28</td>
</tr>
</tbody><tfoot>
<tr>
<td colspan="5"><ul>
<li>p &lt; 0.1, * p &lt; 0.05, ** p &lt; 0.01, *** p &lt; 0.001</li>
</ul></td>
</tr>
</tfoot>
&#10;</table>

## Discussion

The results show a clear hierarchy across infrastructure types.
Segregated cycling infrastructure is strongly associated with higher
cycling levels, while painted lanes show no meaningful association,
supporting the hypothesis that physical separation from motor traffic is
the single most important infrastructure feature enabling higher cycling
levels.

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

- **OSM Quality:** The analysis relies on OpenStreetMap data
  completeness and tagging consistency, which varies by region.
- **Causality:** This cross-sectional analysis establishes correlation,
  not causality. High cycling levels might drive investment in
  infrastructure, or vice versa.
- The analysis is conducted at the city level and does not account for
  individual-level differences in cycling behaviour.

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
