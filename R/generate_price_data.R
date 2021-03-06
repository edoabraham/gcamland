#' get_prices
#'
#' @details Read in prices for all periods and return them
#' @param aScenType Type of scenario to run, either "Reference" or "Hindcast".
#' @return Tibble containing prices by commodity and year
#' @importFrom readr read_csv
#' @importFrom tidyr gather
#' @importFrom dplyr mutate
#' @author KVC October 2017
#' @export
get_prices <- function(aScenType) {
  # Silence package checks
  region <- sector <- year <- price <- scenario <- Units <- NULL

  # Get prices
  if(aScenType == "Hindcast") {
    prices <- get_hindcast_prices()
  } else {
    file <- paste("./scenario-data/AgPrices_", aScenType, ".csv", sep="")
    prices <- suppressMessages(read_csv(system.file("extdata", file, package = "gcamland"), skip = 1))

    # Tidy data
    prices %>%
      select(-scenario, -Units) %>%
      gather(year, price, -region, -sector) %>%
      mutate(year = as.integer(year)) ->
      prices
  }

  # Filter for only years included in model simulation (or those before start year)
  prices %>%
    filter(year <= max(YEARS[[aScenType]])) ->
    prices

  return(prices)
}

#' get_hindcast_prices
#'
#' @details Read in FAO prices by GCAM regions and commodity. Prices were processed by Ryna.
#' @return prices in historical period
#' @import dplyr
#' @importFrom readr read_csv
#' @author KVC October 2018
#' @export
get_hindcast_prices <- function(){
  # Silence package checks
  price <- year <- sector <- GCAM_region_name <- GCAM_commod <- pp_2005usd_tonne <- uniqueJoinField <-  NULL

  # Read prices (these are already aggregated to gcam commodity and region)
  faoPrices <- suppressMessages(read_csv(system.file("extdata", "./hindcast-data/prod_price_rgn.csv", package = "gcamland"), skip=3))

  # Convert to 1975$/kg, filter for the right region, rename columns
  faoPrices %>%
    filter(GCAM_region_name == DEFAULT.REGION) %>%
    rename(sector = GCAM_commod,
           price = pp_2005usd_tonne) %>%
    mutate(price = price / 3.05 / 1000) %>% # 3.05 converts from 2005$ to 1975$; 1000 converts from tonnes to kg
    select(year, sector, price) ->
    faoPrices

  # Prices for PalmFruit are missing prior to 1991, copy 1990 prices backward
  faoPrices %>%
    filter(sector == "PalmFruit",
           year == 1991) %>%
    select(-year) %>%
    mutate(uniqueJoinField = 1) %>%
    full_join(mutate(tibble(year = YEARS$Hindcast), uniqueJoinField = 1), by = "uniqueJoinField") %>%
    select(-uniqueJoinField) %>%
    filter(year < 1991) %>%
    bind_rows(faoPrices) ->
    faoPrices

  return(faoPrices)
}

#' Price tables for each scenario type.
#'
#' Currently supported types are "Reference" and "Hindcast".  This structure is
#' a list of tibbles with all of the prices for the model, for each scenario.
#' @include constants.R
#' @author Kate Calvin, Robert Link
PRICES <- sapply(SCEN.TYPES, get_prices, simplify=FALSE, USE.NAMES=TRUE)
