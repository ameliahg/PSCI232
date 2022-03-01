# Cookbook for final project: bubble, line, and bar charts
# This file shows you how to make several common types of graphs/charts/maps
# If you have a vision and you don't know how to execute it, LMK

# Packages you might use (install if you don't have):
library(tidyverse)

# Everything here uses examples from US county data (minus AK, HI)
# But you can use other datasets also! 

cnty <- read_csv("https://raw.githubusercontent.com/ameliahg/PSCI232/main/countyhealth_andpol.csv") %>%
  mutate(POC_majority=ifelse(pct_nonhisp_white<0.5,1,0))


# 2. A bubble plot (aka scatter plot with points sized to represent something)

my_bubble <- ggplot(data=cnty) +
  geom_point(aes(x=pct_rural,y=per_gop,
                 color=pct_nonhisp_white,
                 size=population,
                 shape=factor(exconfed)),
             alpha=0.7) +
  scale_color_viridis_c(option='magma',
                        direction=-1) +
  scale_size_area(max_size = 20) +
  guides(size="none",alpha="none") +
  labs(x="Proportion of population in rural area",
       y="Proportion of 2016 vote to Donald Trump",
       color="Proportion white, non-hispanic",
       shape="Ex-confederate state",
       main="Trump vote by net migration and race")

ggsave(plot=my_bubble,filename='trump_bubble.pdf',
       width=10,height=6)

# 3. Different slopes for different populations

my_line <- ggplot(data=cnty, aes(x=BA.pct.2015,y=per_gop)) +
  geom_point(aes(size=population, color=pct_nonhisp_white),
             alpha=0.5) +
  geom_smooth(aes(lty=factor(POC_majority)),method='lm') +
  scale_color_viridis_c(option='magma') +
  scale_size_area(max_size=10) +
  labs(x="Proportion with BA, 2015",
       y='Proportion of vote to Donald Trump',
       size='County population',
       color='% non-Hispanic white',
       lty='Majority-POC')

ggsave(plot=my_line,file='trump_vote_lines.pdf',height=8,width=12)