# R/01_qol_data.R: QoL survey processing (cycling-use proxy)

# Read the SPSS dataset into R
qol <- read_sav("data/QoL in European Cities_2023_microdata/2023_QoL in European Cities_microdata.sav")

# Convert labelled columns to factors
qol_factor <- qol |> 
  mutate(across(where(is.labelled), ~ as_factor(.)))

# Aggregate to city level, then compute a weighted cycling-use proxy (EU QoL 2023)
# Q5 asks: “On a typical day, which mode(s) of transport do you use most often?”
# Two response slots are stored as Q5_1 (first) and Q5_2 (second). We count “Bicycle” in either slot.
# We use w1 (calibration weight) because it is the recommended weight for single-city aggregates
# (it post-stratifies by age, gender and education to match each city’s 15+ population).

qol_q5 <- qol_factor |>
  group_by(
    country    = Country_sample,   # country code in sample
    city_name  = D3_Cityrecode,    # DG REGIO/Eurostat city code
    population = Population        # city population size (descriptor)
  ) |>
  summarise(
    bike_sample  = sum(w1[Q5_1 == "Bicycle" | Q5_2 == "Bicycle"], na.rm = TRUE), # weighted cyclists
    total_sample = sum(w1, na.rm = TRUE),                                        # weighted total
    bike_prop    = bike_sample / total_sample,                                   # weighted share
  .groups = "drop"                                                               # drop grouping after summarise (avoids surprises later)
  ) |>
  mutate(
    country   = as.character(country),   # standardise join keys (CSV/readr will give character)
    city_name = as.character(city_name)  # standardise join keys
  ) |>
  arrange(desc(bike_prop))              # rank cities by cycling-use proxy