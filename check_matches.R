library(haven)
library(tidyverse)
library(giscoR)

qol <- read_sav("data/QoL in European Cities_2023_microdata/2023_QoL in European Cities_microdata.sav")
qol_cities <- unique(as.character(as_factor(qol$D3_Cityrecode)))

gisco_cities <- gisco_get_urban_audit(year = "2021", level = "CITIES")
gisco_names <- unique(gisco_cities$URAU_NAME)

qol_clean <- gsub(" / .*| /.*", "", qol_cities)
# Also try matching with CNTR_CODE
matches <- qol_cities[qol_clean %in% gisco_names]

cat("Total QoL cities:", length(qol_cities), "\n")
cat("Direct/Clean Matches (CITIES):", length(matches), "\n")

missing <- setdiff(qol_cities, matches)
cat("Still missing:\n")
cat(paste(missing, collapse = ", "), "\n")
