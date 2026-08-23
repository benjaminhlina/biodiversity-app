# ---- search table ------
#' Search functions
#'
#' Search functions allow for a dynamic search bar to be displayed to search
#' taxa
#' @param session shiny session
#' @param input shiny input
#' @param con a databaese connection
#'
#' @return returns a filtered data object that can then be displayed.
#'
#' @name search_functions
#' @export

search_species <- function(session, input, con) {
  # grab species table
  db_species <- dplyr::tbl(con, "species_table")

  if (!is.null(input$country_filter) && !"All" %in% input$country_filter) {
    db_species <- db_species |>
      dplyr::filter(country %in% !!input$country_filter)
  }

  species_df <- db_species |>
    dplyr::distinct(scientific_name, display_label) |>
    dplyr::collect()

  species_choices <- stats::setNames(
    species_df$scientific_name,
    species_df$display_label
  )

  cli::cli_alert_info(
    "Updating species choices: {length(species_choices)} found."
  )

  shiny::updateSelectizeInput(
    session,
    "species_search",
    choices = c("All", species_choices),
    select = "",
    options = list(
      maxOptions = 25,
      placeholder = "Type to search by species...",
      openOnFocus = FALSE
    ),
    server = TRUE
  )
}
