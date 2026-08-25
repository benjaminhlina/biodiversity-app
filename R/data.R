#' A `data.frame` containing the names of countries around the world.
#'
#'
#' @format `data.frame` containing 250 rows and 6 variables
#'  \describe{
#'    \item{iso2}{The 2 letter country code (ISO-3166-1)}
#'    \item{iso3}{The 3 letter country code (ISO-3166-1)}
#'    \item{isoNumerical}{The ISO-3166-1 number}
#'    \item{title}{The title of each country in the world}
#'    \item{gbifRegion}{The region/contient that pertains to gbif records}
#'    \item{enumName}{The enumerated name used by gbif}
#' }
"countries"

#' A `data.frame` containing the names four species from poland
#'
#' @format `data.frame` containing 4 rows and 4 variables
#'  \describe{
#'    \item{country}{The country name)}
#'    \item{scientific_name}{The scientific name}
#'    \item{vernacular_name}{The vernacular name}
#'    \item{display_label}{The combined of scientific and vernacular name}
#' }
"test_poland_spp"

#' A `data.frame` containing occupancy for four species from poland used for testing
#'
#'
#' @format `data.frame` containing 10 rows and 42 variables
#'
"test_poland_occ"

#' A `data.frame` containing the multimedia four species from poland used for testing
#'
#'
#' @format `data.frame` containing 4 rows and 9 variables
#'
"test_poland_mm"
