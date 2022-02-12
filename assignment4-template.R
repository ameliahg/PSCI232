# preamble: should have filename, brief description, your name, date

# load packages using library()
# just like in assignment 3

# read data
# (copy the relevant line from assignment 3)

# for *each of three pairs* of variables,
# (1) print the correlation coefficient
# (2) create and save a scatter plot
# (3) in a comment, speculate about what might be causing
#     the correlation you see (or don't see).

# Below is an example; don't use the same variables.

# (1) print correlation coefficient
# print(cor(cnty$life_expect,cnty$med_hh_income,use='complete.obs'))

# (2) create and save a scatter plot
# notice that in this example i've added a size aesthetic
# the point sizes will correspond to the county's population
# consider adding a color aesthetic as well
# h1 <- ggplot(data=cnty,aes(x=life_expect,
#                            y=teen_births_percap,
#                            size=population)) +
#   geom_point(alpha=0.6)
# ggsave('h1.pdf',plot=h1,width=6,height=6)

# (3) This is a negative correlation -- higher median income
# associated with lower teen births. It could be because teen births
# prevent people from finishing school, which lowers earnings.
# Or, it could be that poor counties have fewer opportunities
# and so there's less incentive to wait to have kids.
