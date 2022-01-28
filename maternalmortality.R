# maternalmortality.R
# script to visualize maternal mortality data
# note to self: install.packages needs quotation marks
# library doesn't.

library(readxl)
library(dplyr)

mm <- read_xlsx('maternal-mortality-ratio-sdgs.xlsx') %>%
  filter(Year==2017, MMR_per100k>=500, !is.na(Code)) %>%
  arrange(-MMR_per100k)

p <- ggplot(data=mm, aes(y=Entity, x=MMR_per100k)) + geom_point()






