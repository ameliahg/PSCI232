# vax_vs_hosp.R
# covid cases, hospitalizations, deaths by state
# hypothesis: more vaccination = fewer hosps, deaths per case.
# data from NYT web page
# As of December 16, 2021

library(tidyverse)

stopifnot(basename(getwd())=='PSCI232') # check to make sure you're running from the 'PSCI232' dir

# ^ if this fails, what will you do?

nyt <- read_csv("https://raw.githubusercontent.com/ameliahg/PSCI232/main/state-data/covidbystate-dec16.csv") %>%
  # note! if the read doesn't work it may be due to reorg of my GitHub. Challenge yourself to find the new URL.
  mutate(across(!matches('state'),as.numeric),
         hosp_percase_lag14=hosp_day_100k/cases_100k_lag14,
         deaths_percase_lag14=deaths_day_100k/cases_100k_lag14) %>%
  filter(deaths_percase_lag14>=0.005,
         hosp_percase_lag14>=0.25)

p <- ggplot(data=nyt) +
  geom_label(aes(x=vaxxed,y=deaths_percase_lag14,
                 label=state,color=deaths_percase_lag14)) +
  coord_trans(y="log") +
  scale_color_viridis_c(option="magma",direction=-1,trans="log10") +
  geom_smooth(aes(x=vaxxed,y=deaths_percase_lag14),method='glm') +
  labs(x="% vaccinated",y="Deaths today per case 2 weeks ago",
       color="Deaths today/\ncases 2wks ago",
       title="States with more vaccinations have fewer deaths per case during Omicron surge")

ggsave('output/vax_deathspercase.png',width=10,height=8)

p <- ggplot(data=nyt) +
  geom_label(aes(x=vaxxed,y=hosp_percase_lag14,
                 label=state,color=hosp_percase_lag14)) +
  coord_trans(y="log") + 
  scale_color_viridis_c(option="magma",direction=-1,trans="log10") +
  geom_smooth(aes(x=vaxxed,y=hosp_percase_lag14),method='glm') +
  labs(x="% vaccinated",y="Hospitalizations today per case 2 weeks ago",
       color="Hospitalizations today/\ncase 2 wks ago",
       title="States with more vaccinations have fewer hospitalizations per case during Omicron surge")

ggsave('output/vax_hosp_percase.png',width=10,height=8)
