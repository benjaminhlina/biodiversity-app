# ----- get_column_amp ------

#' Get functions
#'
#' These functions are very important as they create SQL to
#' then get data from DuckDB database, whether that is
#' schemas, raw values or other information about the database.
#' Each function creates a SQL string that is excuted on a
#' given table in the database.
#'
#'

#' @param con a database connection.
#' @param input a input object produced by a sidebar.
#'
#' @details
#' `get_map_data()` selects and returns map data to be ploted on the map
#' @name get_functions
#' @export

get_map_data <- function(con, input) {
  all_country_selected <- any(c("") %in% input$country_filter) ||
    is.null(input$country_filter)

  all_spp_selected <- any(c("", "All") %in% input$species_filter) ||
    is.null(input$species_filter)

  if (!all_country_selected) {
    # ---- get occ data ----
    tbl_occ <- get_tbl(
      con,
      "tbl_occ",
      select = c(
        "id",
        "scientific_name",
        "vernacular_name",
        "individual_count",
        # "life_stage",
        # "sex",
        "country",
        # "continent",
        "longitude_decimal",
        "latitude_decimal",
        "date_time",
        # "habitat",
        "popup_info"
      )
    )
    tbl_occ <- tbl_occ |>
      dplyr::filter(country %in% !!input$country_filter)

    # Species filter applied ONLY when country is filtered
    if (!all_spp_selected) {
      tbl_occ <- tbl_occ |>
        dplyr::filter(scientific_name %in% !!input$species_filter)
    }
    return(tbl_occ)
  } else {
    return(NULL)
  }

  cli::cli_alert_info(
    "Queried data for {.val {input$country_filter}} country(s) for the following species {.val {input$species_filter}}"
  )
}


# ----- get_tbl -----

#' @param tbl_name a given name for the a table of interest in the database.
#' @param select a `vector` of columns to select.
#'
#' @details
#' `get_tbl()` selects and returns a query for the given table
#'
#' @name get_functions
#' @export

get_tbl <- function(con, tbl_name, select = NULL) {
  results <- dplyr::tbl(con, tbl_name)

  if (!is.null(select)) {
    results <- results |>
      dplyr::select(dplyr::all_of(select))
  }
  return(results)
}
