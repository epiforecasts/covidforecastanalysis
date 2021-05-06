Comparing reported COVID-19 cases with forecasts
================
Joe Palmer
06/05/2021

Every day the Epiforecasts team produces estimates of COVID-19 cases for
the next 14 days. Snapshots of these forecasts, along with other data,
are stored daily in date marked directories. The objective of this
document is to show a comparison between the forecasted cases and what
the actual case numbers ended up as.

Two data files were used to perform this analysis. 1)
`reported_cases.rds` a file showing the number of reported cases up to
that date. 2) `summarised_estimates.rds` a file showing estimates,
estimates based on partial data and forecasts. To prepare the data I
filtered the summarised estimates to return only forecasts for reported
cases and then joined this to the appropriate dates for reported
estimates. The result of this is a dataframe for each UK sub-region
containing columns showing the number of confirmed cases on a given date
and forecasting metrics (median, mean, sd, etc.) for that date made on a
previous date. For example, for cases reported on the 15/03/2021, this
row would be repeated 14 times but with different forecast estimates and
a different forecast date spanning the previous 14 days.

### Example data

    ##         date forecast_date confirm       variable strat     type median      mean        sd lower_90 lower_50 lower_20 upper_20 upper_50 upper_90     region
    ## 1 2021-03-15    2021-03-01      70 reported_cases  <NA> forecast     46  52.99175  34.42194    16.00       31       39       53       67   112.05 Derbyshire
    ## 2 2021-03-15    2021-03-02      70 reported_cases  <NA> forecast     54  62.95550  63.37889    21.00       38       48       61       75   128.00 Derbyshire
    ## 3 2021-03-15    2021-03-03      70 reported_cases  <NA> forecast     54  62.30625  36.73020    23.95       39       48       61       76   128.00 Derbyshire
    ## 4 2021-03-15    2021-03-04      70 reported_cases  <NA> forecast     55  62.88700  35.36570    25.00       40       49       63       76   124.00 Derbyshire
    ## 5 2021-03-15    2021-03-05      70 reported_cases  <NA> forecast    115 158.60075 281.91285    54.00       83      101      131      166   351.05 Derbyshire
    ## 6 2021-03-15    2021-03-06      70 reported_cases  <NA> forecast    104 120.64275  73.78495    51.00       78       93      116      142   239.00 Derbyshire

With this data we can explore the forecasts compare to the actual case
numbers for a given region.

## forecasts vs actuals for Derbyshire

``` r
joined <- full %>%
  filter(region == "Derbyshire") %>%
  mutate(d2d = date - forecast_date) # %>%
# group_by(d2d) %>%
# mutate(
#     MSE = sum((confirm-median)^2) / length(confirm),
#     RMSE = sqrt(MSE),
#     MAD = sum(abs(confirm-median)) / length(confirm),
#     MAPE = sum((abs(confirm-median)/confirm)*100) / length(confirm)
# )
```

``` r
forecast_vs_confirmed <- joined %>%
  filter(
    d2d %in% c(1, 7, 14),
    date >= "2021-03-01" & date <= "2021-04-01"
  ) %>%
  ggplot(aes(x = date)) +
  geom_line(aes(y = confirm, color = "confirmed")) +
  geom_line(aes(y = median, color = "median forecast")) +
  scale_color_manual(values = c(
    "confirmed" = "black",
    "median forecast" = "red"
  )) +
  labs(
    x = "forecast date",
    y = "cases",
    color = "Type"
  ) +
  theme(legend.position = "top") +
  facet_grid(rows = vars(d2d))

mean_foracst_confirmed_diff <- joined %>%
  filter(
    date >= "2021-03-01" & date <= "2021-04-01"
  ) %>%
  group_by(d2d) %>%
  mutate(
    MSE = sum((confirm - median)^2) / length(confirm),
    RMSE = sqrt(MSE),
    MAD = sum(abs(confirm - median)) / length(confirm),
    MAPE = sum((abs(confirm - median) / confirm) * 100) / length(confirm)
  ) %>%
  ungroup() %>%
  gather(key = "statistic", value = "value", MSE:MAPE) %>%
  group_by(d2d, statistic) %>%
  summarise_at(vars(value), mean) %>%
  ggplot(aes(x = d2d, y = value)) +
  geom_bar(stat = "identity", fill = "grey", width = 0.8) +
  labs(
    x = "Days between forecast and actual cases reported",
    y = "value"
  ) +
  scale_x_continuous(
    breaks = c(1:14),
    labels = c(1:14)
  ) +
  facet_grid(rows = vars(statistic), scales = "free_y")

plot_grid(
  forecast_vs_confirmed,
  mean_foracst_confirmed_diff,
  labels = "AUTO",
  ncol = 1
)
```

![Figure 1. **A**. Confirmed COVID-19 cases with median forecasted
number of cases produced 1, 7 and 14 days prior to the given date.
**B**. Mean Absolute Distance, Mean Absolute Percentage Error, Mean
Squared Error and Root Mean Squared Error by the number of days before
target date.](data-exploration_files/figure-gfm/unnamed-chunk-3-1.png)

Figure 1. COVID-19 cases for Derbyshire between March and April 2021.
**A**. Confirmed COVID-19 cases with median forecasted number of cases
produced 1, 7 and 14 days prior to the given date. **B**. Mean Absolute
Distance, Mean Absolute Percentage Error, Mean Squared Error and Root
Mean Squared Error by the number of days before target date.

``` r
joined %>%
  filter(d2d == 5) %>%
  ggplot(aes(x = date)) +
  geom_bar(aes(y = confirm), stat = "identity", fill = "grey", width = 0.8) +
  geom_line(aes(y = median), colour = "red", alpha = 0.6) +
  labs(x = "Date", y = "Cases") +
  geom_ribbon(aes(ymin = lower_50, ymax = upper_50), fill = "red", alpha = 0.2)
```

![Figure 2. Reported COVID-19 cases with forecast
estimates](data-exploration_files/figure-gfm/unnamed-chunk-4-1.png)

Figure 2. Reported COVID-19 cases with 5 day forecast estimates. Line
indicates estimated cases, shading gives upper and lower 50th
percentile.
