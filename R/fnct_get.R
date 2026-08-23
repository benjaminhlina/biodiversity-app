# ----- get_column_amp ------

#' Get functions
#'
#' These functions are very important as they create SQL to
#' then get data from DuckDB database, whether that is
#' schemas, raw values or other information about the database.
#' Each function creates a SQL string that is excuted on a
#' given table in the database.
#'
#' @param tbl_name a given name for the a table of interest in the database.
#' @param selected_countires a given name for the countries selected.
#' @param value_col a given name for the column of interest e.g., `scientific_name`.
#'
#' @details
#' `get_dropdown_options()` gets the options and values for the dropdowns. It
#' functions based on which countries are selected.
#'
#' @name get_functions
#' @export

get_dropdown_options <- function(
  tbl_name,
  selcted_countries,
  value_col
) {
  result <- tbl_name |>
    dplyr::distinct(.data[[value_col]]) |>
    dplyr::filter(!is.na(.data[[value_col]])) |>
    dplyr::pull(.data[[value_col]]) |>
    sort()

  cli::cli_alert_info(
    "Selected {.val {length(result)}} number of species for {.val {selcted_countries}}"
  )

  return(result)
}
