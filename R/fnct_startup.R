#' Start up GLATAR App
#'
#' This function, which has no arguments, starts the database
#' connection, gets `valid_values`` for validation, gets
#' `nice_names` for properly displaying tables, creates
#' credientials, and and file location for resources.
#'
#' @export
start_up <- function() {
  # ---- get _valid_values from db -------

  app_version <- "0.1.0"

  # create named vectors
  # nice_name_lookup <- stats::setNames(
  #   naming_conventions$nice_names,
  #   naming_conventions$raw_names
  # )
  # ----- load everything ------
  # gtag_path <- system.file("js", package = "glatar")

  startup <- list(
    app_version = app_version
    # naming_conventions = naming_conventions,
    # nice_name_lookup = nice_name_lookup
  )
  return(startup)
}
