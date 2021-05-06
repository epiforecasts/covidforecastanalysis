#' Retrieve forcastes produced for a given date at a given region
#' @description For a path to a given region's directory, extract the reported
#' cases and forcasted cases for a target date.
#' @param target_region char array path to a regions directory
#' @param target_date char array date to extract data for.
#' @importFrom dplyr filter left_join mutate
#' @export
get_forecasts_single_date <- function(target_region, target_date) {
    latest_reported_cases <- readRDS(
        paste0(
            target_region,
            "/latest/reported_cases.rds"
        )
    )
    latest_reported_cases$date <- as.Date(latest_reported_cases$date)
    d1.f <- paste0(
        target_region, "/", target_date, "/summarised_estimates.rds"
    )
    d1.data <- readRDS(file=d1.f)
    d1.data$date <- as.Date(d1.data$date)

    # extract only forecasts for reported cases
    d1.data.forecasts <- d1.data %>%
        filter(variable == "reported_cases")  %>%
        filter(type == "forecast")

    # filter actual cases for when the forecasts are
    start <- min(d1.data.forecasts$date)
    stop <- max(d1.data.forecasts$date)

    comb <- latest_reported_cases %>%
        filter(date >= start & date <= stop) %>%
        left_join(d1.data.forecasts, by = "date") %>%
        mutate(
            forecast_date = as.Date(target_date)
        )

    return(comb)
}

#' Retrieve forcastes produced for all dates for a given region
#' @description For a path to a given region's directory, extract the reported
#' cases and forcasted cases for all dates listed as subdirectories.
#' @inheritParams get_forecasts_single_date
#' @importFrom dplyr bind_rows mutate
#' @importFrom purrr map
#' @export
get_forecasts_all_dates <- function(target_region) {
    files <- list.files(target_region)
    dates <- sort(files)[1:length(files)-1]

    dfs <- dates[2:length(dates)] %>%
        map(~{get_forecasts_single_date(target_region, .x)})

    joined <- dfs %>%
        bind_rows() %>%
        mutate(
            region = basename(target_region)
        )
    return(joined)
}

#' Retrieve forcastes produced for all dates and all regions
#' @description For all regions in a nations directory, extract the reported
#' cases and forcasted cases for regions and dates listed as subdirectories.
#' Files are saved to data/processed_data/uk_combined_actual_forecast.rds. Note
#' this assumes you have ran `create_uk_hostorical_data()`  and have the
#' data downloaded for processing.
#' @importFrom dplyr bind_rows
#' @importFrom purrr map
#' @export
get_forecasts_per_region <- function() {
    target.dir <- "data/united-kingom-forecast-data/cases/national"
    target.files <- list.dirs(target.dir, recursive = FALSE)
    joined <- target.files %>%
        map(
            get_forecasts_all_dates
        ) %>%
        bind_rows()
    saveloc <- "data/processed_data/"
    saveRDS(joined, paste0(saveloc, "uk_combined_actual_forecast.rds"))
    return(joined)
}