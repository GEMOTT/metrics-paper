# R/00_setup.R: Project setup (libraries and paths)

library(haven) # read SPSS file
library(tidyverse) 
library(sf)
library(osmdata)
library(osmactive)
library(ggrepel)
library(scales)
library(knitr)   

cache_dir <- "data/cache/osm_cache"
dir.create(cache_dir, showWarnings = FALSE, recursive = TRUE)
