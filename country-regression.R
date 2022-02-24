# country-regression.R
# Runs regressions about countries
# Amelia HG
# Draft of 24 Feb 2022

### packages
library(tidyverse)
library(stargazer)

### data
# same data you'll use in Assignment 5
cntry <- read_csv('https://raw.githubusercontent.com/ameliahg/PSCI232/main/country-data-recent.csv')

### analysis
# goal is to explain variation in military spending as a proportion of GDP
# pattern: modelname <- lm (dv~iv1+iv2+iv3+...,data=dataname)
# pattern for stargazer output: stargazer(m1, m2, m3..., type='html', out='filename.html')
