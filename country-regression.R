# country-regression.R
# Runs regressions about countries
# Amelia HG
# Draft of 24 Feb 2022

### packages
library(tidyverse)
library(stargazer)

### data
cntry <- read_csv('country_stats_recent.csv')

### analysis
# goal is to explain variation in military spending as a proportion of GDP

