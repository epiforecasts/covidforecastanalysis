
# nolint start
# require(dplyr)
# require(ggplot2)
# theme_set(
#   theme_classic() + theme(text = element_text(family = "URWHelvetica", size = 12))
# )

# path <- "../data/united-kingom-forecast-data/cases/national/Manchester/"
# target_date <- "2021-01-28"
# target <- "summarised_estimates.rds"
# fullpath <- paste0(path, target_date, "/", target)

# dat <- readRDS(fullpath)

# tst <- dat %>%
#   filter(
#     variable == "R",
#     type == "estimate"
#   ) %>%
#   arrange(date)

# dat %>%
#   filter(type == "forecast", date == as.Date("2021-01-29"))
# nolint end
