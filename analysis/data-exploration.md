Comparing reported COVID-19 cases with forecasts
================
Joe Palmer
06/05/2021

Every day the Epiforecasts team produces estimates of COVID-19 cases for
the next 14 days. Snapshots of these forecasts, along with other data,
are stored daily in date marked directories. The objective of this
document is to show a comparison between the forcasted cases and what
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

<div data-pagedtable="false">

<script data-pagedtable-source type="application/json">
{"columns":[{"label":["date"],"name":[1],"type":["date"],"align":["right"]},{"label":["forecast_date"],"name":[2],"type":["date"],"align":["right"]},{"label":["confirm"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["variable"],"name":[4],"type":["chr"],"align":["left"]},{"label":["strat"],"name":[5],"type":["chr"],"align":["left"]},{"label":["type"],"name":[6],"type":["chr"],"align":["left"]},{"label":["median"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["mean"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["sd"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["lower_90"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["lower_50"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["lower_20"],"name":[12],"type":["dbl"],"align":["right"]},{"label":["upper_20"],"name":[13],"type":["dbl"],"align":["right"]},{"label":["upper_50"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["upper_90"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["region"],"name":[16],"type":["chr"],"align":["left"]}],"data":[{"1":"2021-03-15","2":"2021-03-01","3":"70","4":"reported_cases","5":"NA","6":"forecast","7":"46","8":"52.99175","9":"34.42194","10":"16.00","11":"31","12":"39","13":"53","14":"67","15":"112.05","16":"Derbyshire"},{"1":"2021-03-15","2":"2021-03-02","3":"70","4":"reported_cases","5":"NA","6":"forecast","7":"54","8":"62.95550","9":"63.37889","10":"21.00","11":"38","12":"48","13":"61","14":"75","15":"128.00","16":"Derbyshire"},{"1":"2021-03-15","2":"2021-03-03","3":"70","4":"reported_cases","5":"NA","6":"forecast","7":"54","8":"62.30625","9":"36.73020","10":"23.95","11":"39","12":"48","13":"61","14":"76","15":"128.00","16":"Derbyshire"},{"1":"2021-03-15","2":"2021-03-04","3":"70","4":"reported_cases","5":"NA","6":"forecast","7":"55","8":"62.88700","9":"35.36570","10":"25.00","11":"40","12":"49","13":"63","14":"76","15":"124.00","16":"Derbyshire"},{"1":"2021-03-15","2":"2021-03-05","3":"70","4":"reported_cases","5":"NA","6":"forecast","7":"115","8":"158.60075","9":"281.91285","10":"54.00","11":"83","12":"101","13":"131","14":"166","15":"351.05","16":"Derbyshire"},{"1":"2021-03-15","2":"2021-03-06","3":"70","4":"reported_cases","5":"NA","6":"forecast","7":"104","8":"120.64275","9":"73.78495","10":"51.00","11":"78","12":"93","13":"116","14":"142","15":"239.00","16":"Derbyshire"},{"1":"2021-03-15","2":"2021-03-07","3":"70","4":"reported_cases","5":"NA","6":"forecast","7":"107","8":"119.15850","9":"60.54803","10":"55.95","11":"81","12":"96","13":"118","14":"140","15":"223.00","16":"Derbyshire"},{"1":"2021-03-15","2":"2021-03-08","3":"70","4":"reported_cases","5":"NA","6":"forecast","7":"94","8":"101.13775","9":"39.54376","10":"53.00","11":"74","12":"87","13":"103","14":"119","15":"173.00","16":"Derbyshire"},{"1":"2021-03-15","2":"2021-03-09","3":"70","4":"reported_cases","5":"NA","6":"forecast","7":"78","8":"82.16725","9":"28.59037","10":"45.00","11":"62","12":"71","13":"84","14":"98","15":"133.00","16":"Derbyshire"},{"1":"2021-03-15","2":"2021-03-10","3":"70","4":"reported_cases","5":"NA","6":"forecast","7":"71","8":"73.77450","9":"23.86582","10":"41.00","11":"57","12":"66","13":"76","14":"86","15":"117.00","16":"Derbyshire"},{"1":"2021-03-15","2":"2021-03-11","3":"70","4":"reported_cases","5":"NA","6":"forecast","7":"78","8":"80.57250","9":"24.02885","10":"46.00","11":"64","12":"72","13":"84","14":"94","15":"125.00","16":"Derbyshire"},{"1":"2021-03-15","2":"2021-03-12","3":"70","4":"reported_cases","5":"NA","6":"forecast","7":"72","8":"74.22575","9":"21.58425","10":"44.00","11":"59","12":"67","13":"77","14":"87","15":"113.00","16":"Derbyshire"},{"1":"2021-03-15","2":"2021-03-13","3":"70","4":"reported_cases","5":"NA","6":"forecast","7":"79","8":"80.61500","9":"21.60959","10":"49.00","11":"65","12":"74","13":"84","14":"94","15":"119.00","16":"Derbyshire"},{"1":"2021-03-15","2":"2021-03-14","3":"70","4":"reported_cases","5":"NA","6":"forecast","7":"73","8":"75.16550","9":"19.47957","10":"46.00","11":"61","12":"69","13":"78","14":"87","15":"110.00","16":"Derbyshire"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>

</div>

With this data we can explore the forecastes compare to the actual case
numbers for a given region.

## forcastes vs actuals for Derbyshire

``` r
joined <- full %>%
  filter(region == "Derbyshire") %>%
  mutate(d2d = date - forecast_date) %>%
  group_by(d2d) %>%
  mutate(
      MSE = sum((confirm-median)^2) / length(confirm),
      RMSE = sqrt(MSE),
      MAD = sum(abs(confirm-median)) / length(confirm),
      MAPE = sum((abs(confirm-median)/confirm)*100) / length(confirm)
  )
```

``` r
forcases_vs_confirmed <- joined %>%
    filter(d2d %in% c(1, 7, 14)) %>%
    ggplot(aes(x=forecast_date)) +
    geom_line(aes(y=confirm, color = "confirmed")) +
    geom_line(aes(y=median, color = "median forecast")) +
    scale_color_manual(values = c(
      'confirmed' = 'black',
      'median forecast' = 'red')
    ) +
    labs(
      x = "forecast date",
      y = "cases",
      color = 'Type'
    ) +
    theme(legend.position="top") +
    facet_grid(rows=vars(d2d))

mean_foracst_confirmed_diff <- joined %>%
    gather(key = "statistic", value = "value", MSE:MAPE) %>%
    group_by(d2d, statistic) %>%
    summarise_at(vars(value), mean) %>%
    ggplot(aes(x=d2d, y=value)) +
    geom_bar(stat="identity", fill = "grey", width = 0.8) +
    labs(
      x = "Days between forecast and actual cases reported",
      y = "value"
    ) +
    facet_grid(rows = vars(statistic), scales="free_y")

plot_grid(
  forcases_vs_confirmed,
  mean_foracst_confirmed_diff,
  labels = "AUTO",
  ncol = 1
)
```

    ## Don't know how to automatically pick scale for object of type difftime. Defaulting to continuous.

![Figure 1. **A**. Confirmed COVID-19 cases with median forecasted numer
of cases produced 1, 7 and 14 days prior to the given date. **B**. Mean
Absolute Distance, Mean Absolute Percentage Error, Mean Squared Error
and Root Mean Squared Error by the number of days before target
date.](data-exploration_files/figure-gfm/unnamed-chunk-3-1.png)

``` r
joined %>%
  filter(d2d == 5) %>%
  ggplot(aes(x=date)) +
  geom_bar(aes(y=confirm), stat="identity", fill = "grey", width = 0.8) +
  geom_line(aes(y=median), colour = "red", alpha = 0.6) +
  labs(x = "Date", y = "Cases") +
  geom_ribbon(aes(ymin=lower_50, ymax=upper_50), fill = "red", alpha = 0.2)
```

![Figure 2. Reported COVID-19 cases with forecast
estimates](data-exploration_files/figure-gfm/unnamed-chunk-4-1.png)
