# county-trump-vote.R

library(tidyverse)
library(stargazer)

cnty <- read_csv('https://raw.githubusercontent.com/ameliahg/PSCI232/main/countyhealth_andpol.csv') %>%
  mutate(trump_supermaj_2016=ifelse(per_gop>0.75,1,0),
         unemp_change=Unemployment_rate_2016-Unemployment_rate_2013,
         med_hh_income=med_hh_income/10000)

m0 <- glm(trump_supermaj_2016~log(population)+rural+pct_nonhisp_white+pct_black+pct_aapi+pct_hisp+
            BA.pct.2015+pct_over_65+Unemployment_rate_2016+unemp_change+netmigration_pct+segregation_nonwhite_white+
            poor_phys_health+med_hh_income,data=cnty,family='binomial')

m1 <- glm(trump_supermaj_2016~log(population)+rural+pct_nonhisp_white+pct_black+pct_aapi+pct_hisp+
            BA.pct.2015+pct_over_65+Unemployment_rate_2016+unemp_change+netmigration_pct+segregation_nonwhite_white+
            poor_phys_health+med_hh_income+exconfed,data=cnty,family='binomial')

m2 <- glm(trump_supermaj_2016~log(population)+rural+pct_nonhisp_white+pct_black+pct_aapi+pct_hisp+
            BA.pct.2015+pct_over_65+Unemployment_rate_2016+unemp_change+netmigration_pct+segregation_nonwhite_white+
            poor_phys_health+med_hh_income+state,data=cnty,family='binomial')

lm0 <- lm(per_gop~log(population)+rural+pct_nonhisp_white+pct_black+pct_aapi+pct_hisp+
            BA.pct.2015+pct_over_65+Unemployment_rate_2016+unemp_change+netmigration_pct+segregation_nonwhite_white+
            poor_phys_health+med_hh_income,data=cnty)

lm1 <- lm(per_gop~log(population)+rural+pct_nonhisp_white+pct_black+pct_aapi+pct_hisp+
            BA.pct.2015+pct_over_65+Unemployment_rate_2016+unemp_change+netmigration_pct+segregation_nonwhite_white+
            poor_phys_health+med_hh_income+exconfed,data=cnty)

lm2 <- lm(per_gop~log(population)+rural+pct_nonhisp_white+pct_black+pct_aapi+pct_hisp+
            BA.pct.2015+pct_over_65+Unemployment_rate_2016+unemp_change+netmigration_pct+segregation_nonwhite_white+
            poor_phys_health+med_hh_income+state,data=cnty)

stargazer(m0,m1,m2,lm0,lm1,lm2,omit='state',type='text',out='mods.txt',
          notes='Models m2 and lm2 include state fixed effects.',omit.stat=c("ser",'f'))