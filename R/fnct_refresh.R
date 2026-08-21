#' Refresh sidebar filter choices based on current selections
#'
#' @param input the module's `input` object
#' @param session the module's `session` object
#' @param con a DBI/duckdb connection
#' @param updating a `reactiveVal()` used as a lock to prevent circular updates
#' @param changed character; the id of the input that triggered this refresh
#'   ( `"home_species_filter_gs"`, or `"home_species_filter_vn"`)
#'
#' @export
refresh_filters <- function(input, session, con, updating, changed) {
  if (updating()) {
    return(invisible(NULL))
  }
  updating(TRUE)
  on.exit(updating(FALSE))

  country_sel <- input$country_filter
  gs_sel <- input$home_species_filter_gs
  vn_sel <- input$home_species_filter_vn

  # Build a base query filtered by everything EXCEPT the input being updated
  base <- dplyr::tbl(con, "tbl_occ")

  if (
    changed != "country_filter" &&
      !("All" %in% country_sel) &&
      length(country_sel) > 0
  ) {
    base <- base |>
      dplyr::filter(country %in% country_sel)
  }
  if (
    changed != "home_species_filter_gs" &&
      !("All" %in% gs_sel) &&
      length(gs_sel) > 0
  ) {
    base <- base |>
      dplyr::filter(scientific_name %in% gs_sel)
  }
  if (
    changed != "home_species_filter_vn" &&
      !("All" %in% vn_sel) &&
      length(vn_sel) > 0
  ) {
    base <- base |>
      dplyr::filter(vernacular_name %in% vn_sel)
  }

  if (changed != "home_species_filter_gs") {
    opts <- base |>
      dplyr::distinct(scientific_name) |>
      dplyr::pull(scientific_name) |>
      sort()

    shiny::updateSelectizeInput(
      session,
      "home_species_filter_gs",
      choices = c("All", opts),
      selected = gs_sel,
      server = TRUE
    )
  }
  if (changed != "home_species_filter_vn") {
    opts <- base |>
      dplyr::distinct(vernacular_name) |>
      dplyr::pull(vernacular_name) |>
      sort()

    shiny::updateSelectizeInput(
      session,
      "home_species_filter_vn",
      choices = c("All", opts),
      selected = vn_sel,
      server = TRUE
    )
  }

  invisible(NULL)
}
