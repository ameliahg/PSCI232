# county-maps-2.R
# demonstrates how to build useful bubble charts
# demonstrates how to add shapes to county maps
# you can use this as a template for making other kinds of map, too

#############
### SETUP ###
#############

### Define a function to put multiple plots on one page ###
# Copied from http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/

# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#

multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

### End of multiplot definition ###

### Now load a bunch of packages ###

library(tidyverse)
library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)

# If necessary (if any of the above statements produces a "There is no
# pakage called" error): 
# install.packages(c("tidyverse","ggplot2","ggmap","maps","mapdata",
#                    "devtools"))
# Or some subset of these

###########################
### LOAD & PREPARE DATA ###
###########################

cnty <- read_csv('https://raw.githubusercontent.com/ameliahg/PSCI232/main/countyhealth_andpol.csv')

# map_data is a ggplot2 function that puts county data
# from the maps package in format accessible to ggplot2

fips <- as_tibble(get(data(county.fips)))
cntyshapes <- as_tibble(map_data('county')) %>%
  mutate(polyname=paste(region,subregion,sep=',')) %>%
  left_join(.,fips) %>%
  rename(fipscode=fips)
stshapes <- as_tibble(map_data('state'))

# New columns in cnty

cnty <- mutate(cnty,
               unemp.change.3yr=Unemployment_rate_2016-Unemployment_rate_2013,
               unemp.change.angle=ifelse(unemp.change.3yr>0,pi/2,-pi/2),
               unemp.change.radius=abs(unemp.change.3yr)/20, # length of arrows will be proportional to absolute value of change
               unemp.change.pctile=ecdf(unemp.change.3yr)(unemp.change.3yr), # color will show percentile rather than absolute value
               BA.pctile=ecdf(BA.pct.2015)(BA.pct.2015)) # turning the % with BA into the percentile rank

# Get rid of Alaska and Hawaii to make life easier
cntyshapes <- filter(cntyshapes, 
                     region %in% c('alaska','hawaii')==FALSE)
stshapes <- filter(stshapes, 
                   region %in% c('alaska','hawaii')==FALSE)

##########################
### MAKE SCATTER PLOTS ###
##########################

# Make county data available to plot
cntyplot <- ggplot(data=cnty)

# Plot pct rural against Clinton vote.
p1 <- cntyplot + geom_point(aes(x=rural,y=per_dem)) +
  labs(x = "Percent rural", y = "Percent Clinton vote", title = "Clinton vote by pct rural")
ggsave('clinton-by-rural.pdf')

# Overplotting, ew. Let's make all of them a little transparent by adding alpha.
p2 <- cntyplot + geom_point(aes(x=rural,y=per_dem),alpha=0.3) +
  labs(x = "Percent rural", y = "Percent Clinton vote", 
       title = "Clinton vote by pct rural, alpha = 0.3")
ggsave('clinon-by-rural-alpha.pdf')

# The plot also makes it look like all counties are the same size. 
# Let's change the size to correspond to the population.

p3 <- cntyplot + geom_point(aes(x=rural,y=per_dem,size=population),alpha=0.3) +
  labs(x = "Percent rural", y = "Percent Clinton vote", 
       title = "Clinton vote by pct rural and county population",
       size = "County population")
ggsave('clinton-by-rural-pop.pdf')

# That scale doesn't look right. We can tune it.
# breaks is for telling how to categorize counties,
# range is for limiting the size of the circles to a certain multiplier

p4 <- p3 + scale_size_continuous(range=c(0.25,20),
                                 breaks=c(1,1000,5000,25000,125000,625000,3125000,10000000)) +
  labs(x = "Percent rural", y = "Percent Clinton vote", 
       title = "Clinton vote by pct rural and county population",
       size = "County population")
ggsave('clinton-by-rural-pop-2.pdf')

# Let's use color for dem vote and add a different dimension to the graph. 
# Same space now with more info!
p5 <- cntyplot + geom_point(aes(x=rural,y=per_dem,
                                size=population,color=pct_black,
                                alpha=(0.2+0.465*pct_black))) +
  scale_size_continuous(range=c(1,40),breaks=c(1,1000,5000,25000,125000,625000,3125000,10000000)) +
  scale_color_viridis(option='magma') +
  labs(x = "Percent rural", y = "Percent Clinton vote", 
       title = "Clinton vote by pct rural, county population, and percent Black",
       size = "County population", color="% Black") +
  guides(alpha=FALSE)
ggsave('rural-nonwhite-clinton-vote.pdf')

# Print them all on the same output
# Can't use ggsave with multiplot, 
# so you "turn on" a pdf "device"
# put the thing in the file
# and then "turn off" the pdf "device"

pdf('county-scatterplots.pdf',width=18,height=18)
multiplot(p1,p3,p5,p2,p4,cols=2)
dev.off()

#####################
### NOW MAKE MAPS ###
#####################

# First add our county data (cnty) to the county shapes dataset (cntyshapes).

cnty <- filter(cnty,stname %in% c("Alaska","Hawaii")==FALSE) # Get rid of AK, HI rows

# The actual merge:
print(dim(cntyshapes))
cntyshapes <- left_join(cntyshapes,cnty)
print(dim(cntyshapes))
# ^ Sanity check: second print statement should 
# show at least as many rows as the first.

# IMPORTANT for arrow or dot overlays: 
# We need to make mean latitude and longitude data for each county in order to place dots/arrows.

cntygrps <- group_by(cntyshapes,fipscode)
cntygrps <- summarise(cntygrps, meanlat=mean(lat,na.rm=TRUE),
                      meanlon=mean(long,na.rm=TRUE))

# In the lines above, group_by literally tells the dataset to make groups 
# according to the given variable (fipscode);
# summarise makes a new dataset with the columns meanlat, and meanlon, 
# where meanlat and meanlon are calculated for each st.cnty value.

# Then we merge meanlat and meanlon back into the county data.
cnty <- left_join(cnty,cntygrps)

# Give ggplot the data you want to map
cntymap <- ggplot(data=cntyshapes)

### FINALLY THE ACTUAL MAPPING! ###

# Basic map of counties

cnty1 <- cntymap +
  geom_polygon(aes(x=long,y=lat,group=group),color='blue',fill='white',lwd=0.1) +
  coord_map("bonne",parameters=35) +
  labs(title='US counties',x='',y='') +
  theme_void() + # get rid of background
  theme(plot.title = element_text(hjust = 0.5)) #centering title

ggsave(filename="cnty1.pdf",width=10,height=8)

# Map with fill indicating Clinton vote (switch county boundaries to grey)

cnty2 <- cntymap + 
  geom_polygon(aes(x=long,y=lat,group=group,fill=per_dem), 
               color='grey',lwd=0.1) +
  scale_fill_viridis_c() +
  coord_map("bonne",parameters=35) +
  theme_void()+
  labs(x='',y='',fill="% HRC vote",title="Clinton vote by county")+
  theme(plot.title = element_text(hjust = 0.5)) #centering title

ggsave(filename="cnty2.pdf",width=10,height=8)

# But now it's hard to see the states. Add them in using geom_path.

# And while we're at it, add dots showing percentile rank of college educated ppl
# Notice that, to make the dots, we're going back to the cnty data 
# and placing the dots in the rough center of each county
# using a black-white spectrum

cnty3 <- cnty2 +
  geom_path(data=stshapes, aes(x=long,y=lat,group=group),color='black',lwd=0.25) +
  geom_point(data=cnty,aes(x=meanlon,y=meanlat,color=BA.pctile),alpha=0.5,size=0.5)+
  scale_color_gradient2(low='black',mid='grey',high='white',midpoint=0.5) +
  labs(color='BA holders, %ile',title='Democratic vote and BA holder percentile, by county')+
  theme(plot.title = element_text(hjust = 0.5)) #centering title

ggsave(filename="cnty3.pdf",width=10,height=8)

# Now add arrows showing change in unemployment for each county.

cnty4 <- cnty2 +
  geom_path(data=stshapes, aes(x=long,y=lat,group=group),color='black',lwd=0.25) +
  geom_spoke(data=cnty,aes(x=meanlon,y=meanlat,angle=unemp.change.angle,
                           radius=unemp.change.radius,color=unemp.change.pctile),
             arrow=arrow(length=unit(0.015,'inches'),type='closed'),
             lwd=0.1) +
  scale_color_viridis_c() +
  labs(color='Unemployment change, %ile',title='Democratic vote and Unemployment change, by county') +
  theme(plot.title = element_text(hjust = 0.5)) #centering title

ggsave(filename="cnty4.pdf",width=10,height=8)

#######
# END #
#######












