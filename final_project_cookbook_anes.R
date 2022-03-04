# Information and directions for filtering
# American National Election Study time series data
# This data has every question that is comparable across at least 4 ANES waves
# And every respondent from every year

### Useful ANES variables ###

# VCF0232: feeling thermometer gays and lesbians
# VCF9280: know anyone who is bisexual or gay
# VCF0876: favor or oppose laws to protect [homoxsexuals/gays and lesbians] from discrim
# VCF0876a: strength of opinion on previous
# VCF9279: sexual orientation (no gender identity var)

# VCF0004: year of study
# VCF0101: respondent age
# VCF0102: age group
# VCF0103: age cohort
# VCF0104: gender
# VCF0105a: race/ethnicity summary
# ...everything up to VCF0156 is respondent characteristics.

# VCF0128: religious group
# VCF0130: church attendance
# VCF0702: did respondent vote

library(tidyverse)
library(ggalluvial)

anes <- read_csv('https://raw.githubusercontent.com/ameliahg/PSCI232/main/anes_time_series.csv')

### Make new column names for clarity ###

anes <- anes %>%
  rename(year=VCF0004,
         age=VCF0101,
         agecat=VCF0102,
         generation=VCF0103,
         gender=VCF0104,
         ftgay=VCF0232,
         know_someone_LGB=VCF9280,
         disc_gay=VCF0876,
         disc_gay_opstrength=VCF0876a,
         sexorient=VCF9279,
         relgrp=VCF0128,
         chruch_attend=VCF0130,
         voted=VCF0702) %>% # I encourage folks to add to the rename list. 
  mutate(know_someone_LGB=ifelse(know_someone_LGB<0,NA,know_someone_LGB))

### One idea for a graph ###

# filter for years that actually exist
anes2 <- filter(anes,!is.na(ftgay),generation %in% c(1:6)) %>%
  mutate(generation=factor(generation,
                           labels=c('Born 1991-present',
                                    'Born 1975-1990',
                                    'Born 1959-1974',
                                    'Born 1943-1958',
                                    'Born 1927-1942',
                                    'Born 1911-1926'))) # turn generation into a factor with nice labels

p <- ggplot(data=anes2) +
  geom_boxplot(aes(y=generation,x=ftgay,color=generation,fill=generation),alpha=0.3,varwidth = TRUE) +
  scale_color_viridis(discrete=TRUE,option="B") +
  scale_fill_viridis(discrete=TRUE,option="B") +
  facet_wrap(vars(year),ncol=2)

ggsave(filename='boxplots_byyear.pdf',height=10,width=8)

# make data where the unit of observation is the generation
# and feeling thermometer data varies by both generation and time

resp_by_year <- group_by(anes2,year) %>%  # need to count respondents by year
  summarize(thisyear_resp=n()) # that's what n() does

anes3 <- left_join(anes2,resp_by_year) %>% # join the year summaries to the main data
  group_by(year,generation) %>% # group the data by year and generation
  summarize(thisgen_resp=n(), # count number of respondents in each year*generation group
            thisyear_resp=unique(thisyear_resp), # retain count of respondents in year groups
            prop_thisgen_resp=thisgen_resp/thisyear_resp, # proportion of this year's sample from this cohort
            mean_ft_gay=mean(ftgay,na.rm=TRUE)) %>% # mean FT for this cohort * year 
  ungroup()

p2 <- ggplot(data=anes3) +
  geom_point(aes(x=year,y=mean_ft_gay,size=prop_thisgen_resp,color=generation,
                 fill=generation),alpha=0.6) +
  geom_line(aes(x=year,y=mean_ft_gay,color=generation)) +
  scale_size_area(max_size=13)+
  scale_color_viridis(discrete=TRUE,option="B") +
  scale_fill_viridis(discrete=TRUE,option="B") +
  guides(size="none") +
  labs(x="",y="",fill="Generation",color="Generation",
       title="Mean feeling thermometer toward 'gays and lesbians' by generation cohort, 1984-2020",
       caption="Bubble sizes represent proportion of sample drawn from cohort")

ggsave(filename='lines_byyear.pdf',height=8,width=10)
  
  