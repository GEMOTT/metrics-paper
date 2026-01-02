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

- Create exploratory scatter plots to see associations.

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

``` r
# Test the classification logic on a small country/city (Monaco)
message("Running classification test for Monaco...")
# We use try() to allow the document to render even if the test fails (e.g. internet issues)
test_result <- try({
  get_city_metrics("Monaco", "Monaco")
}, silent = TRUE)

if (inherits(test_result, "try-error")) {
  message("Test failed: ", conditionMessage(attr(test_result, "condition")))
} else {
  print(test_result)
}
```

## Results

<div id="fig-infra-usage-types-1">

| Infrastructure Type | R-squared | Number of Cities | label_text        |
|:--------------------|----------:|-----------------:|:------------------|
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Segregated tracks   |     0.368 |               64 | Segregated tracks |
| (R² = 0.368)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Off-road paths      |     0.173 |               62 | Off-road paths    |
| (R² = 0.173)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Painted lanes       |     0.004 |               64 | Painted lanes     |
| (R² = 0.004)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |
| Shared footways     |     0.044 |               64 | Shared footways   |
| (R² = 0.044)        |           |                  |                   |

Correlation between cycling infrastructure types and cycling mode share.

Figure 1: Relationship between cycling mode share and different types of
cycling infrastructure (as a percentage of the total road network),
colored by European region.

</div>

<div id="fig-infra-usage-types-2">

![](01-cycling-infra-vs-usage_files/figure-commonmark/fig-infra-usage-types-1.png)

Figure 2: Relationship between cycling mode share and different types of
cycling infrastructure (as a percentage of the total road network),
colored by European region.

</div>

The analysis reveals varying degrees of association between
infrastructure types and cycling levels when normalized by the total
road network. Segregated tracks show a correlation of $R^2 =$ 0.368.
Off-road paths ($R^2 =$ 0.173) and painted lanes ($R^2 =$ 0.004) show
weaker associations.

## Discussion

The analysis reveals a clear hierarchy in the relationship between
infrastructure types and cycling levels. **Segregated tracks** (both
wide and narrow) demonstrate the strongest positive correlation with
cycling mode share ($R^2 \approx 0.42$). This supports the hypothesis
that physical separation from motor traffic is a key factor in enabling
higher cycling levels.

In contrast, **painted lanes** show negligible correlation
($R^2 \approx 0.01$), suggesting that merely marking space on the
carriageway without physical protection may not be sufficient to drive
significant modal shift. **Off-road paths** and **shared footways**
occupy a middle ground, contributing to the network but with weaker
associations than dedicated segregated tracks.

### Limitations

- **Data Completeness:** Data retrieval was successful for 69 out of 69
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
