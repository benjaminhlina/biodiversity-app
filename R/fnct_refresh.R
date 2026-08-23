#' Refresh sidebar filter choices based on current selections
#'
#' @param input the module's `input` object
#' @param session the module's `session` object
#' @param con a DBI/duckdb connection
#' @param updating a `reactiveVal()` used as a lock to prevent circular updates
#'
#' @details
#' `refresh_species_by_country()` creates updated filters based on changes in the
#' country selected.
#'
#'
#' @name refresh_functions
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
  val_cols <- c(
    "scientific_name",
    "vernacular_name"
  )

  opts_list <- purrr::map(
    val_cols,
    ~ get_dropdown_options(
      tbl_name = tbl_occ,
      selcted_countries = country_sel,
      value_col = .x
    )
  )

  # ----- loop over selections update -----

  filter_names <- c(
    "home_species_filter_gs",
    "home_species_filter_vn"
  )
  # ---- Update choices with ------
  purrr::pwalk(
    list(filter_names, opts_list),
    function(filter_id, choices) {
      refresh_selection(
        session,
        filter_id,
        choices
      )
    }
  )

  invisible(NULL)
}

# ----- refresh_selection -----

#' @param session the module's `session` object
#' @param name the namespace name of the filter
#' @param options a `vector` containsing the choices
#'
#' @details
#' `refresh_selection()` creates an updated selctize input for
#' a given filter such as species and commmon name.
#'
#' @name refresh_functions
#' @export

refresh_selection <- function(session, name, options) {
  updated_input <- shiny::updateSelectizeInput(
    session,
    name,
    choices = c("All", options),
    selected = "All",
    server = TRUE,
    options = list(
      maxOptions = 100,
      placeholder = "Type to search species...",
      openOnFocus = FALSE
    )
  )
  return(updated_input)
}
