# ----- create connection to database -----

#' Start Database Connection
#'
#' This function uses environment supplied variables, `{DBI}`,
#' and `{duckdb}` to connect to a DuckDB database.
#'
#' @param db_name The name of the database we are wanting to connect to
#' Default is `NULL` and will use `gbif.duckdb`
#' @return Returns a connection object.
#'
#' @name db_connections
#' @export

start_db_con <- function(db_name = NULL) {
  if (is.null(db_name)) {
    db_name <- "gbif.duckdb"
  }

  con <- DBI::dbConnect(
    duckdb::duckdb(),
    dbdir = here::here(
      'inst',
      'db',
      db_name
    )
  )

  cli::cli_alert_success(
    "db successfully connected to {.val {db_name}}"
  )
  cli::cli_alert_success(
    "db successfully connected (is_valid: {.val {DBI::dbIsValid(con)}})"
  )
  return(con)
}
