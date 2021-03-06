# Assignment 3 template
# Your preamble goes here

# packages
# your library() statements go here

# read in data
# one thing that's annoying about reading from github
# is the long URL -- makes readability tougher.
# oh well

cnty <- read_csv('https://raw.githubusercontent.com/ameliahg/PSCI232/main/countyhealthrankings.csv') %>%
  mutate(white_black_income_ratio=(med_hh_income_white/med_hh_income_black))

# make a histogram!
h1 <- ggplot(data=cnty, aes(x=white_black_income_ratio)) +
  geom_histogram(fill='purple',color='purple') +
  labs(x='Ratio of white HH median income to Black HH median income',y='')
ggsave('h1.pdf',width=6,height=3) 

# notes:
# labs tells what the different axis labels should be
# notice that it is part of the ggplot statement, not its own thing
# ggsave tells R what filename to save the plot under (by default the last plot you made)
# and what you want the dimensions of the graph to be, in inches

print("Mean proportion of white to black median income, US counties:")
print(mean(cnty$white_black_income_ratio,na.rm=TRUE))
# na.rm removes "na" (missing) values
# if you don't set na.rm equal to TRUE,
# you may get a mean (or median) of NA,
# which is not right.
print("Median proportion of white to black income, US counties:")
print(median(cnty$white_black_income_ratio,na.rm=TRUE))
print("Standard deviation white to black income proportion, US counties:")
print(sd(cnty$white_black_income_ratio,na.rm=TRUE))

# find your home county
home <- filter(cnty, # if you're giving the dataset a new name you need to specify the old one in the statement, like this
               state=='ND',
               county=='Grand Forks County') %>%
  select(state, county, white_black_income_ratio)

print("The subset for my home county")
print(home)

# OK NOW YOU
# you can copy-paste my template from above (lines 16-36)
# to make your own histograms and print your own results,
# but you may not use the same variable i did! 
# don't forget to comment on where your home county falls.

# Below here is optional but might be fun ("fun")
# I'm going to add a vertical line to show where Grand Forks County is in the distribution
# See if you can figure out what I'm doing

h2 <- ggplot() +
  geom_histogram(data=cnty,aes(x=white_black_income_ratio),
                 fill='purple',color='purple') +
  geom_vline(data=home,aes(xintercept=white_black_income_ratio),
             color='yellow') +
  labs(x='Proportion of Black to white median household income',
       caption='Grand Forks County, ND, shown in yellow.')
ggsave('grandforks.pdf',width=6,height=3)