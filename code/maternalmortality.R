# maternalmortality.R
# re-creating an NYT graphic on worldwide maternal mortality

### setup ###

stopifnot(basename(getwd())=='PSCI232') # check to make sure you're running from the 'PSCI232' dir

# ^ if this fails, what will you do?

library(tidyverse)
library(ggplot2)
library(gganimate)

### data ###

oecd2017 <- c('United States','United Kingdom','Turkey',
              'Switzerland','Sweden','Spain','Slovenia',
              'Slovak Republic','Portugal','Poland','Norway',
              'New Zealand','Netherlands','Mexico','Luxembourg',
              'Latvia','Korea','Japan','Italy',
              'Israel','Ireland','Iceland','Hungary','Greece',
              'Germany','France','Finland','Estonia','Denmark',
              'Czech Republic','Chile','Canada','Belgium','Austria',
              'Australia')

# ^ list of OECD countries as of 2017; cheating a little since we have data 
# from 2001 onwards. this is a character vector, fyi. (how would you check
# how many OECD members?)

mm <- read_csv("https://raw.githubusercontent.com/ameliahg/PSCI232/main/country-data/maternal_mortality_edited.csv") %>%
  mutate(oecd=ifelse(country %in% oecd2017,1,0),
         usa=ifelse(country=="United States",1,0)) %>% 
  filter(oecd==1) %>%
  arrange(desc(mmr_per100k)) # what is desc() doing here?

p <- ggplot(data=mm) +
  geom_bar(aes(x=mmr_per100k,y=country,fill=factor(usa))) +
  transition_states(
    year,
    transition_length = 2,
    state_length = 1
  ) +
  enter_fade() + 
  exit_shrink() +
  ease_aes('sine-in-out')

# maternalmortality.R
# re-creating an NYT graphic on worldwide maternal mortality

stopifnot(basename(getwd())=='PSCI232') # check to make sure you're running from the 'PSCI232' dir

# ^ if this fails, what will you do?

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

