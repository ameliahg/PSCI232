shoot <- read_csv('https://raw.githubusercontent.com/ameliahg/PSCI232/main/motherjones_mass_shootings.csv') %>%
  mutate(yr2=as.numeric(substr(date,nchar(date)-1,nchar(date))),
         year=as.numeric(paste(ifelse(yr2<22,'20','19'),yr2,sep=''))) %>%
  group_by(state) %>%
  summarize(nshootings=n(),
            total_fatalities=sum(fatalities,na.rm=TRUE),
            legal_weapons=sum(weapons_obtained_legally,na.rm=TRUE),
            unknown_weapons=length(which(is.na(weapons_obtained_legally))),
            n_last10yrs=length(which(year>2010)),
            fatalities_last10yrs=sum(fatalities[year>2010],na.rm=TRUE)) %>%
  ungroup() %>%
  mutate(pct_legal_weapons=legal_weapons/nshootings,
         pct_illegal_weapons=(nshootings-legal_weapons-unknown_weapons)/nshootings,
         pct_unknown_weapons=unknown_weapons/nshootings)

write_csv(shoot,'shootings_by_state.csv')