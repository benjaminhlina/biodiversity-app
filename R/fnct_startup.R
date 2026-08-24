#' Start up GBIF App
#'
#' This function, which has no arguments, starts the database
#' connection, dispalys the ap verions.
#'
#' @export
start_up <- function() {
  # ---- start db connecitons  db -------
  con <- start_db_con()
  app_version <- "0.1.0"

  startup <- list(
    con = con,
    app_version = app_version
  )
  return(startup)
}
