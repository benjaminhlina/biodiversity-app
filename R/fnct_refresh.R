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
refresh_species_by_country <- function(input, session, con, updating) {
  if (updating()) {
    return(invisible(NULL))
  }

  updating(TRUE)
  on.exit(updating(FALSE))

  country_sel <- input$country_filter

  # 1. Base database query
  base <- dplyr::tbl(con, "tbl_occ")

  if (!("All" %in% country_sel) && length(country_sel) > 0) {
    base <- base |> dplyr::filter(country %in% country_sel)
  }

  # 2. Extract choices explicitly using collect()
  opts_sci <- base |>
    dplyr::select(scientific_name) |>
    dplyr::distinct() |>
    dplyr::filter(!is.na(scientific_name)) |>
    dplyr::collect() |>
    dplyr::pull(scientific_name) |>
    sort()

  opts_vn <- base |>
    dplyr::select(vernacular_name) |>
    dplyr::distinct() |>
    dplyr::filter(!is.na(vernacular_name)) |>
    dplyr::collect() |>
    dplyr::pull(vernacular_name) |>
    sort()

  # 3. Update choices with server = FALSE to prevent download$filter crash
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
