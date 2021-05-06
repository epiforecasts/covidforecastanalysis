#' Sync Estimates From Azure Storage
# nolint start
#' (taken from https://github.com/epiforecasts/covid-rt-estimates/blob/master/R/get_estimates.R)
# nolint end
#' @description This utility allows for programmatic downloading/syncing of
#' results  from our reproduction number pipeline which are stored in Azure
#' blob storage.  It requires an installation of `azcopy` to function for
#' which we provide an install script for use with Linux. By default it will
#' download/sync all summary estimates. Optionally, it can also return plots
#' and samples (with short term archiving of previous estimates). Using the
#' file structure of `covid-rt-estimates` it can also be used to target
#' specific estimates by setting the `target_dir` argument.
#'
# nolint start
#' `azcopy`: https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10
#'
#' Install file: bin/install_azcopy.sh
# nolint end
#'
#' @param local_dir A character string containing the local folder to sync
#' estimates into.
#' @param include A character vector indicating the results type to sync.
#' Options are
#' "csv", "rds", "png", and "log". The default is "csv" which represents a
#' summary.
#' @param target_dir A character string indicating the internal folder to
#' target in the  Azure blob storage. Defaults to "results". This may be used
#' to selectively sync results.
#' @param blob A character string indicating the Azure blob address.
#' @return NULL
#' @export
#' @importFrom AzureStor call_azcopy
#' @examples
#' get_estimates("covid-rt-estimates")
get_estimates <- function(local_dir,
                          include = "csv",
                          target_dir = "results",
                          blob = "https://epinowcovidrstorage.blob.core.windows.net") { # nolint

  # Check Args
  include <- match.arg(
    include,
    choices = c("csv", "rds", "png", "log"),
    several.ok = TRUE
  )

  # Add in target directory
  blob <- file.path(blob, target_dir)

  # Check and create local addresses
  if (!dir.exists(local_dir)) {
    dir.create(local_dir, recursive = TRUE)
  }

  # define inclusion list
  ic <- "exactName"
  add_inc <- function(ic, inc) {
    if (inc %in% include) {
      ic <- paste0("*.", inc, ";", ic)
    }
    return(ic)
  }
  ic <- add_inc(ic, "csv")
  ic <- add_inc(ic, "rds")
  ic <- add_inc(ic, "png")

  # get estimates
  AzureStor::call_azcopy("sync", blob, local_dir, "--include-pattern", ic)
  return(invisible(NULL))
}

#' Produce table of forecasts and actual data for all UK regions
#' @description Fetch all the data from Azure Blob storage of Epiforecasts
#' and store in a directory in data.
#' @export
create_uk_hostorical_data <- function() {
  uk_actual_dir <- "data/united-kingom-forecast-data"
  get_estimates(
    local_dir = uk_actual_dir,
    target_dir = "results/subnational/united-kingdom-local",
    include = c("csv", "rds"),
  )
}