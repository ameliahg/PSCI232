# make a ribbon graph over time

library(tidyverse)
library(viridisLite)

# get example data:

ex <- read_csv('https://raw.githubusercontent.com/ameliahg/PSCI232/main/example-data/example.csv')

# colnames:
# year = the year
# type = grouping of some sort, maybe words we're counting
# year_pages = total number of pages this year
# type_pages = total number of pages with this word, this year
# pct = pct of pages with this type (a specific word, maybe?)

# make graph of absolute pages by group

p <- ggplot(data=ex) +
  geom_area(aes(x=year,y=type_pages,fill=type)) +
  theme_minimal() +
  scale_fill_viridis_d() +
  labs(x='Year',y='Pages',fill='Group',
       title = "Change in pages per group, 1989-1994")

ggsave('pages-grp-abs.png',height=6,width=6)

# make graph of pct pages by group

yr <- group_by(ex,year) %>%
  summarize(year_pages=sum(type_pages))

ex <- left_join(ex,yr) %>%
  mutate(pct=type_pages/year_pages)

p2 <- ggplot(data=ex) +
  geom_area(aes(x=year,y=pct,fill=type)) +
  theme_minimal() +
  scale_fill_viridis_d() +
  labs(x='Year',y='% of Pages',fill='Group',
       title='Change in % of pages by group, 1989-1994')

ggsave('pages-grp-pct.png',height=6,width=6)

# FYI when you give a .png file extension it makes a transparent image.


  