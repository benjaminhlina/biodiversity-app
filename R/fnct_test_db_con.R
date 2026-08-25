#' Make Test DB Connection
#'
#' Make test db connection
#'
#' @param tbl_name a `character` that is the name of the tbl to test
#' @param df a `data.frame` to write
#'
#' @name test_functions
#'
#' @export

make_test_con <- function(tbl_name, df) {
  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  DBI::dbWriteTable(con, tbl_name, df)
  return(con)
}
