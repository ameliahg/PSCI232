library(tidyverse)
library(ggplot2)

oecd2017 <- c('United States','United Kingdom','Turkey',
          'Switzerland','Sweden','Spain','Slovenia',
          'Slovak Republic','Portugal','Poland','Norway',
          'New Zealand','Netherlands','Mexico','Luxembourg',
          'Latvia','Korea','Japan','Italy',
          'Israel','Ireland','Iceland','Hungary','Greece',
          'Germany','France','Finland','Estonia','Denmark',
          'Czech Republic','Chile','Canada','Belgium','Austria','Australia')

mm <- read_csv('https://raw.githubusercontent.com/ameliahg/PSCI232/main/maternal_mortality_edited.csv')

