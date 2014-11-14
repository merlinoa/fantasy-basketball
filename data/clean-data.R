library(dplyr)

# Read in and clean data
stats <- read.csv("data/player-stats-13-14.csv", row.names = 1)
salary <- read.csv("data/player-contracts.csv")

# add salary to stats data
names(stats)[1] <- "Player"
names(salary)[2] <- "Player"
stats <- left_join(stats, salary[, c(2, 4)], by = "Player")
names(stats)[29] <- "salary"


# remove dollar sign from salary
stats$salary <- as.character(stats$salary)
stats$salary <- gsub("\\$", "", stats$salary)
stats$salary <- as.numeric(stats$salary)

# remove players without a salary from stats
stats <- stats[!is.na(stats$salary), ]

# set NA values to zero
stats$X3P.1[is.na(stats$X3P.1)] <- 0
stats$X2P.1[is.na(stats$X2P.1)] <- 0
stats$FT.[is.na(stats$FT.)] <- 0

save(stats, file = "data/stats-cleaned-13-14.rda")
