# Cookbook for final project
# This file shows you how to make several common types of graphs/charts/maps
# If you have a vision and you don't know how to execute it, LMK

# Packages you might use (install if you don't have):
library(tidyverse)
library(ggmap)
library(maps)
library(mapdata)
library(lubridate)
library(mapproj)

# Everything here uses examples from US county data (minus AK, HI)
# But you can use other datasets also! 
# As you look at THIS code, think: what would I need to replace in the code?

cnty <- read_csv("https://raw.githubusercontent.com/ameliahg/PSCI232/main/countyhealth_andpol.csv") %>%
  mutate(med_hh_income=round(med_hh_income))

### You will need ###

# 1. Data that varies across geography, e.g. by county or country
# (Already loaded above)

# 2. Shapefiles:
cntyshapes <- as_tibble(map_data('county'))

# 3. Some way to join the data; in this case, county FIPS codes
# Unfortunately, county FIPS codes aren't in the county shape data
# So we get the FIPS codes from this file (included in the maps package)
fips <- as_tibble(get(data(county.fips)))

# 4. Optionally, some specific points you want to map
# 

### What to do ###

# First, merge shape data with fips data, THEN shape data with county data
cntyshapes <- mutate(cntyshapes,
                     polyname=paste(region,subregion,sep=',')) %>%
  # (The line above creates a new variable called polyname to match the fips data.)
  left_join(.,fips) %>% # joins cntyshapes, fips
  rename(fipscode=fips) %>% # rename to match the county data
  left_join(.,cnty) %>% # joins cntyshapes, cnty
  filter(!state %in% c('AK','HI')) # filter out alaska, hawaii

# Next, map!

my_map <- ggplot(data=cntyshapes) +
  geom_polygon(aes(x=long,y=lat,group=group,fill=med_hh_income),
               color='grey',lwd=0.1,alpha=0.9) +
  scale_fill_viridis_c(# direction = -1, # for if you want to reverse the scale
                       trans = "log", # for if values are too bunched up
                       # if you want to leave out extremes 
                       na.value='pink', # choose something that isn't in your scale so it's obvious
                       option='cividis',
                       breaks=c(30000,60000,90000,120000),
                       labels=c(30000,60000,90000,120000)) +
  # for more on viridis, see https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html
  coord_map("bonne",parameters=35) + # choose map coordinates
  theme_void() + # ditch everything that's not the map axis lines, ticks, etc.
  labs(x='',y='',fill="Median Income",title="Median Household Income, US Counties") + # labels
  geom_path(data=map_data('state'), # notice this is a different dataset that i'm pulling state shape data from
            aes(x=long,y=lat,group=group),
            color='white',lwd=0.2)  +
  theme(legend.title = element_text(size=8)) + # Make text a little smaller
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(legend.justification=c(0.9,0), legend.position=c(0.9,0))
  
ggsave(plot=my_map,filename='hh_income_map.pdf',width=10,height=6)

# If you want to add some specific points to the map, you will need some data that gives the latitude and longitude of those points
# Here I'm using data from Mother Jones, which maintains a list of mass shootings in the US

sh <- read_csv('https://raw.githubusercontent.com/ameliahg/PSCI232/main/motherjones_mass_shootings.csv') %>%
  filter(!state %in% c('Alaska','Hawaii'),
         year >= 2016)

my_map_points <- my_map + 
  geom_point(data=sh,aes(x=longitude,y=latitude,size=fatalities)) +
  labs(size="Number of fatalities",
       title="Income and mass shootings in the US, 2016-present")

ggsave(plot=my_map_points,filename='hh_income_mass_shootings.pdf',width=10,height=6)



