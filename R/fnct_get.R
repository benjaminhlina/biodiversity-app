# ----- get_column_amp ------

#' Get functions
#'
#' These functions are very important as they create SQL to
#' then get data from DuckDB database, whether that is
#' schemas, raw values or other information about the database.
#' Each function creates a SQL string that is excuted on a
#' given table in the database.
#'
#' @param con a valid `DBI` connection to a DuckDB database.
#' @param tbl_name a given name for the a table of interest in the database.
#' @param value_col a given name for the column of interest e.g., `scientific_name`.
#' @param filter_col a given name of for the column used to filter e.g., `country`.
#' @param filter_val a given name for the object that will be filtered against.
#'
#' @details
#' `get_dropdown_options()` gets the options and values for the dropdowns. It
#' functions based on which countries are selected.
#'
#' @name get_functions
#' @export

get_dropdown_options <- function(
  con,
  tbl_name,
  value_col,
  filter_col = NULL,
  filter_val = NULL
) {
  table <- dplyr::tbl(con, tbl_name)

  if (
    !is.null(filter_col) && !is.null(filter_val) && !("All" %in% filter_val)
  ) {
    tbl_fil <- table |>
      dplyr::filter(.data[[filter_col]] %in% filter_val)
  } else {
    tbl_fil <- table
  }

  result <- tbl_fil |>
    dplyr::distinct(.data[[value_col]]) |>
    dplyr::pull(.data[[value_col]]) |>
    sort()

  return(result)
}
