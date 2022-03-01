# Final project cookbook: how much of the world's population
# lives under democratic vs. non-democratic regimes?

library(tidyverse)
library(ggalluvial)
library(alluvial)
library(viridis)

dat <- read_csv('https://raw.githubusercontent.com/ameliahg/PSCI232/main/country_stats_recent.csv') %>%
  mutate(across(starts_with('pr_')|starts_with('cl_'),as.numeric))

for (yr in c(1980,1985,1990,1995,2000,2005,2010,2015,2020)){ 
  # i don't want to do a bunch of separate additions for each year
  # so i make a for loop
  new_col_name <- paste0("fh_", yr,sep='')
  pr_name <- paste("pr_",yr,sep='')
  cl_name <- paste('cl_',yr,sep='')
  dat <- dat %>%
    mutate(!!sym(new_col_name) := !!sym(pr_name) + !!sym(cl_name))
  # FYI the syntax with !!sym, := is a way to treat strings (e.g. "fh_1990")
  # as column names (e.g. fh_1990) within the tidyverse so that you can use for loops
}

dat2 <- select(dat,country,pop_total,starts_with('fh_')) # get rid of everything except country and FH scores

print(head(dat2))
           
# how many countries were at what level of freedom in each of these years?
# for this you have to "pivot longer," meaning that instead of having 
# each row be a country and there be 9 FH columns (for 1980, 1985, ... 2020), 
# we want to "stack" these so that each row is a country-year and there is
# just one FH variable. for this we use pivot_longer (because the data will
# get longer, i.e. have more rows). when you run the code below, try comparing 
# dat2 and dat3 to see what happens.

dat3 <- pivot_longer(dat2,
                     cols=starts_with('fh_'), # the columns whose values you want to stack
                     names_prefix = 'fh_', # the prefix on each of these columns
                     names_to = 'year', # a new variable name that identifies what you're "stacking" across
                     values_to = "fh") # a new variable where you put the new values

# we still need to figure out how many countries are at each level 
# in each year, so we use summarize(). again, take a look at dat3 vs. dat4
# to see what the code is doing.

dat4 <- group_by(dat3,year,fh) %>% #group dat2 by year-fh combinations
  summarize(ncountries=n(),
            totpop=sum(pop_total,na.rm=TRUE)) %>% # count how many countries are in each combination
  mutate(fh=factor(fh)) # these are ordinal, not continuous, so make them factors

p <- ggplot(data=dat4) + 
  geom_alluvium(aes(x=year,y=ncountries,alluvium=fh,
                   color=fh,fill=fh),curve_type='sigmoid',na.rm=TRUE) +
  scale_color_viridis(discrete=TRUE,direction=-1) +
  scale_fill_viridis(discrete=TRUE,direction=-1) +
  labs(x='Year',
       y='Number of Countries',
       fill='Freedom House score\n (14 is least free)',
       color='Freedom House score\n (14 is least free)',
       title='Number of Countries by Freedom House score, 1980-2020')

ggsave(plot=p,'FH-scores-over-time-ncountries.pdf',width=10,height=8)

# OK but really we want the total *population* living under each type of regime:

p2 <- ggplot(data=dat4) + 
  geom_alluvium(aes(x=year,y=totpop/1000000,alluvium=fh,
                    color=fh,fill=fh),curve_type='sigmoid',na.rm=TRUE) +
  scale_color_viridis(discrete=TRUE,direction=-1) +
  scale_fill_viridis(discrete=TRUE,direction=-1) +
  labs(x='Year',
       y='Total population (millions)',
       fill='Freedom House score\n (14 is least free)',
       color='Freedom House score\n (14 is least free)',
       title='Population living under each Freedom House score, 1980-2020')

ggsave(plot=p2,'FH-scores-over-time-totpop.pdf',width=10,height=8)






