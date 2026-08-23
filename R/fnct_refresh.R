#' Refresh sidebar filter choices based on current selections
#'
#' @param input the module's `input` object
#' @param session the module's `session` object
#' @param con a DBI/duckdb connection
#' @param updating a `reactiveVal()` used as a lock to prevent circular updates
#'
#' @export
refresh_species_by_country <- function(input, session, con, updating) {
  if (updating()) {
    return(invisible(NULL))
  }

  updating(TRUE)
  on.exit(updating(FALSE))

  country_sel <- input$country_filter

  # ----- get occupancy table ----
  tbl_occ <- dplyr::tbl(con, "tbl_occ")

  if (!("All" %in% country_sel) && length(country_sel) > 0) {
    tbl_occ <- tbl_occ |>
      dplyr::filter(country %in% country_sel)
  }

  # ---- Extract choices using get_dropdown options -----
  opts_sci <- get_dropdown_options(
    tbl_name = tbl_occ,
    selcted_countries = country_sel,
    value_col = "scientific_name"
  )
  opts_vn <- get_dropdown_options(
    tbl_name = tbl_occ,
    selcted_countries = country_sel,
    value_col = "vernacular_name"
  )

  # ---- Update choices with ------
  shiny::updateSelectizeInput(
    session,
    "home_species_filter_gs",
    choices = c("All", opts_sci),
    selected = "All",
    server = TRUE
  )

  shiny::updateSelectizeInput(
    session,
    "home_species_filter_vn",
    choices = c("All", opts_vn),
    selected = "All",
    server = TRUE
  )

  invisible(NULL)
}
