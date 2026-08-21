{
  library(DBI)
  library(dbplyr)
  library(dplyr)
  library(ggplot2)
  library(here)
  library(rgbif)
  library(sf)
}


library(leaflet)

leaflet() %>%
  addTiles() %>%
  addTiles(
    urlTemplate = 'https://api.gbif.org/v2/map/occurrence/density/{z}/{x}/{y}@1x.png?style=scaled.circles&taxonKey=5219404'
  )


enumeration_country() |>
  filter(title == "Poland")


?occ_search()
poland <- occ_search(
  country = "PL",
  hasCoordinate = TRUE,
  hasGeospatialIssue = FALSE
)


poland$data |>
  glimpse()
countries <- rgbif::enumeration_country()
usethis::use_data(countries, overwrite = TRUE)
