### covidmap.R ###
# makes a map for every week of COVID data, all using the same scale

### packages ###

library(scales)
library(tidyverse)
library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)
library(lubridate)
library(mapproj)

### functions ###

fips <- function(st,cnt){
  while(nchar(as.character(st))<2) st <- paste('0',st,sep='')
  while(nchar(as.character(cnt))<3) cnt <- paste('0',cnt,sep='')
  return(paste(st,cnt,sep=''))
}

fips2 <- function(fipscode){
  if(is.na(fipscode)) return(NA)
  else{
    while(nchar(as.character(fipscode))<5) fipscode <- paste('0',fipscode,sep='')
    return(fipscode)
  }
}

make_thisweek_fig <- function(wk){ # takes one argument, the week as a number
  tmp <- filter(cnty,week==wk) %>% # filter the data to just this week, creating a new temporary (tmp, pronounced "temp") dataset
    group_by(fips) %>%  # group by county
    summarize(pop2019=unique(pop2019),  # summarize: get county population
              new_cases_thisweek=sum(new_cases_today,na.rm=TRUE), # summarize: all new cases (sum by day)
              total_cases=cases[date==max(date)], # total cases
              week=wk) %>%
    ungroup() %>%  # ungroup the summarized table
    filter(!is.na(fips),!is.na(new_cases_thisweek)) %>% # get rid of weeks with NA new cases or FIPS
    mutate(recent_per_100k=try((100000*new_cases_thisweek)/pop2019)) # new variable: per capita cases
  
  truncate_at <- round(as.numeric(quantile(tmp$recent_per_100k,0.95,na.rm=TRUE))) # value to truncate extreme values
  midpoint_recent <- round(as.numeric(quantile(tmp$recent_per_100k,0.50,na.rm=TRUE))) # approximate median
  low_recent <- round(as.numeric(quantile(tmp$recent_per_100k,0.05,na.rm=TRUE))) # value to truncate extreme values
  
  tmp$recent_per100k_truncated <- tmp$recent_per_100k # make new variable with values of old variable
  tmp$recent_per100k_truncated[tmp$recent_per_100k > truncate_at] <- truncate_at # replace extreme values
  
  cntyshapes <- left_join(cntyshapes,tmp) %>%  # 
    group_by(fips)
  
  cntymap <- ggplot(data=cntyshapes)
  
  covidmap <- cntymap + 
    geom_polygon(aes(x=long,y=lat,group=group,fill=recent_per100k_truncated), 
                 color='grey',lwd=0.1) +
    scale_fill_gradient2(limits=c(0,truncate_at),
                         midpoint=midpoint_recent,
                         low="white",
                         mid="wheat1",
                         high="red3",na.value='grey') +
    coord_map("bonne",parameters=35) +
    theme_void()+
    labs(x='',y='',fill="New cases per 100k",
         title=paste("New COVID cases per 100k, by county, week",wk)) +
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(legend.position=c(0.9,0.5)) +
    geom_path(data=stshapes, aes(x=long,y=lat,group=group),color='black',lwd=0.25)
  
  ggsave(paste('covidmap_wk',wk,'.pdf',sep=''),height=7,width=12)
}

### date stuff ###

days <- as.numeric(ymd(today())-ymd('2020-01-21'))
weeks <- round(days/7)

### map data ###

# fips codes #
f <- tibble(get(data(county.fips)))

# shapefiles #
cntyshapes <- as_tibble(map_data('county')) %>%
  mutate(polyname=paste(region,subregion,sep=',')) %>%
  filter(region %in% c('alaska','hawaii')==FALSE) %>%
  left_join(.,f)

stshapes <- as_tibble(map_data('state')) %>%
  mutate(polyname=paste(region,subregion,sep=',')) %>%
  filter(region %in% c('alaska','hawaii')==FALSE) %>%
  left_join(.,f)

cntyshapes$fips <- unlist(lapply(cntyshapes$fips,fips2))
stshapes$fips <- unlist(lapply(stshapes$fips,fips2))

# covid data #
cnty <- read_csv('https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv') %>%
  filter(!is.na(fips)) %>%
  mutate(week=cut_interval(ymd(date),weeks,labels=c(1:weeks)),
         thisweek=ifelse(as.numeric(ymd(today())-ymd(date))<=7,1,0)) %>%
  arrange(fips,date) %>%
  group_by(fips) %>%
  mutate(new_cases_today=try(cases-lag(cases))) %>%
  ungroup()

cnty$new_cases_today[cnty$new_cases_today<0] <- 0 # hack to deal with case totals changing 

# population data #

pop <- read_csv('https://raw.githubusercontent.com/ameliahg/PSCI232/main/co-est2019-alldata.csv') %>%
  select(STATE,COUNTY,POPESTIMATE2019) %>%
  rename(st=STATE,cnt=COUNTY,pop2019=POPESTIMATE2019) %>%
  mutate(fips=NA)

for (i in 1:nrow(pop)) {
  pop$fips[i] <- fips(pop$st[i],pop$cnt[i])
}

cnty <- left_join(cnty,pop)

for(i in 1:weeks) {
  print(paste("Making graph for week",i))
  make_thisweek_fig(i)
}