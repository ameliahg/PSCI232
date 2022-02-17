# covid cases, hospitalizations, deaths by state
# dec 16, 2021
# data from NYT web page

library(tidyverse)

# You can't read Excel 
nyt <- read_csv('https://raw.githubusercontent.com/ameliahg/PSCI232/main/covidbystate-dec16.csv') %>%
  mutate(across(!matches('state'),as.numeric),
         hosp_percase_lag14=hosp_day_100k/cases_100k_lag14,
         deaths_percase_lag14=deaths_day_100k/cases_100k_lag14) %>%
  filter(deaths_percase_lag14>=0.005,
         hosp_percase_lag14>=0.25)

p <- ggplot(data=nyt) +
  geom_label(aes(x=vaxxed,y=deaths_percase_lag14,
                 label=state,fill=deaths_percase_lag14,color=deaths_percase_lag14)) +
  coord_trans(y="log") +
  scale_fill_viridis_c(option="magma",direction=-1,trans="log10") +
  scale_color_gradient2(low="black",high='white',mid='white',midpoint=-4) + #trying to make this readable
  guides(color=FALSE) +
  geom_smooth(aes(x=vaxxed,y=deaths_percase_lag14),method='glm') +
  labs(x="% vaccinated",y="Deaths today per case 2 weeks ago",fill="Deaths today/\ncases 2wks ago")

ggsave('vax_deathspercase.pdf',width=10,height=8)
ggsave('vax_deathspercase.png',width=10,height=8)

p <- ggplot(data=nyt) +
  geom_label(aes(x=vaxxed,y=hosp_percase_lag14,
                 label=state,fill=hosp_percase_lag14,color=log(hosp_percase_lag14))) +
  coord_trans(y="log") + 
  scale_fill_viridis_c(option="magma",direction=-1,trans="log10") +
  scale_color_gradient2(low="black",high='white',mid='white',midpoint=-2) +
  guides(color=FALSE) +
  geom_smooth(aes(x=vaxxed,y=hosp_percase_lag14),method='glm') +
  labs(x="% vaccinated",y="Hospitalizations today per case 2 weeks ago",
       fill="Hospitalizations today/\ncase 2 wks ago")

ggsave('vax_hosp_percase.pdf',width=10,height=8)
ggsave('vax_hosp_percase.png',width=10,height=8)
