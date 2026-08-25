#' Home Tab
#'
#' Provides the the home tab for the app.
#'
#' @param id the shiny namespace id name (i.e., `"home"`).
#'
#' @details `home_tab_ui()` a shiny UI.
#'
#' @name home_module
#' @export

home_tab_ui <- function(id) {
  ns <- shiny::NS(id)

  shinydashboard::tabItem(
    tabName = "home",
    shiny::h2(
      "Welcome to the Global Biodiversity Information Facility (GBIF) Biodiversity Explorer"
    ),
    shiny::p(
      "Below is an interactive map displaying biodiversity observation data. ",
      "Each point represents a location where species have been recorded with",
      "larger points indicate more observations, and brighter colours indicate ",
      "a higher number of observations. Click on any point to view more ",
      "information, including a link to a photo of the species. Use the ",
      "dropdown filters on the left to narrow results by species and to ",
      "display one or more countries."
    ),
    shinycssloaders::withSpinner(
      leaflet::leafletOutput(ns("map"), height = "700px", width = "100%"),
      type = 4,
      caption = "Please wait for the map to load..."
    ),
    shiny::uiOutput(ns("date_range_ui"))
  )
}

# ----- home_server -----
#' @param id the shiny namespace id name (i.e., `"home"`).
#' @param con database connnection
#' @param main_input input from shiny
#' @param home_sidebar_vals object exported out by sidebar
#'
#' @details `home_server()` a shiny server.
#'
#' @name home_module
#' @export

home_server <- function(id, con, main_input, home_sidebar_vals) {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns
    shiny::observe({
      shinyjs::toggle(
        id = "home_ui",
        condition = main_input$tabs == "home"
      )
    })

    # ----- create base data ------

    base_map_dat <- create_base_data(con, input_source = home_sidebar_vals)

    # ----- create date range for slider ------
    display_slider(
      data = base_map_dat,
      output = output,
      output_id = "date_range_ui",
      session = session
    )

    # ----- filter data based on slider inputs -----
    final_map_dat <- create_filtered_data(data = base_map_dat, input = input)

    # ---- I like having this in the log files -----
    shiny::observe({
      cli::cli_inform(
        "Checking sidebar vals: {.val {is.null(home_sidebar_vals())}}"
      )

      cli::cli_inform(
        "map_dat returned row count: {.val {nrow(final_map_dat())}}"
      )
    })
    # ----- output create map ------

    display_map(data = final_map_dat, output = output, output_id = "map")
  })
}
