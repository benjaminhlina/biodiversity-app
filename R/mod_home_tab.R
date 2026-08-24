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
    )
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
    shiny::observe({
      shinyjs::toggle(
        id = "home_ui",
        condition = main_input$tabs == "home"
      )
    })

    map_dat <- shiny::reactive({
      shiny::req(home_sidebar_vals())
      data <- get_map_data(con = con, input = home_sidebar_vals())

      if (!is.null(data)) {
        data <- data |>
          dplyr::collect()
      }
    })

    shiny::observe({
      cli::cli_inform(
        "Checking sidebar vals: {.val {is.null(home_sidebar_vals())}}"
      )

      cli::cli_inform(
        "map_dat returned row count: {.val {nrow(map_dat())}}"
      )
    })

    output$map <- leaflet::renderLeaflet({
      df <- map_dat()
      # shiny::req(nrow(df) > 0)

      pal <- leaflet::colorNumeric(
        palette = "viridis",
        domain = df$individual_count
      )

      map <- base_map(df)
      if (!is.null(df) && nrow(df) > 0) {
        map <- map |>
          leaflet::addCircleMarkers(
            lng = ~longitude_decimal,
            lat = ~latitude_decimal,
            popup = ~popup_info,
            radius = ~ scales::rescale(sqrt(individual_count), to = c(4, 20)),
            fillColor = ~ pal(individual_count),
            fillOpacity = 0.8,
            stroke = TRUE,
            weight = 1,
            color = "black"
          ) |>
          leaflet::addLegend(
            position = "bottomright",
            pal = pal,
            values = ~individual_count,
            title = "Individuals Observed",
            opacity = 0.8
          )
      }
      map
    })
  })
}
