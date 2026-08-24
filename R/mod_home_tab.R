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
      "Welcome "
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
      data <- get_map_data(con = con, input = home_sidebar_vals()) |>
        dplyr::collect()
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
      shiny::req(nrow(df) > 0)

      pal <- leaflet::colorNumeric(
        palette = "viridis",
        domain = df$individual_count
      )

      leaflet::leaflet(df) |>
        leaflet::addTiles() |>
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
    })
  })
}
