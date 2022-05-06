# final_project_cookbook_worldmap.R
# shows how to translate country names from one dataset to another
# and merge country data into map data
# and make a map

library(tidyverse)
library(countrycode)
library(maps)

# read country data
# make a new variable called region (to match the map data)
# the mutate() step in line 17 puts country names in a merge-able format

cnt <- read_csv("https://raw.githubusercontent.com/ameliahg/PSCI232/main/country_stats_recent.csv") %>%
  mutate(region=countrycode(country,'country.name.en.regex','country.name.en'))

# read map data
# same mutate() step puts country names in merge-able format
# don't have to rename this variable

m <- map_data('world') %>%
  mutate(region=countrycode(region,'country.name.en.regex','country.name.en'))
  
# merge the data (country data into map data)

m <- left_join(m,cnt)

# you'll get a warning message because some elements in the 
# world map aren't in the country codes (bc they're not countries!)
# but remember: warnings are not errors.

# let's make sure that worked:

p <- ggplot() +
  geom_polygon(data=m,
               aes(x=long,y=lat,group=group,
                   fill=loggdp)) +
  scale_fill_viridis_c(option='magma') +
  coord_map("gilbert",xlim=c(-170,170),ylim=c(-55,55),clip='on')

ggsave('loggdp-map.pdf')

