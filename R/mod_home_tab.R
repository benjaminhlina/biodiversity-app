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
      get_map_data(con = con, input = home_sidebar_vals())
    })

    # Debugging observer - add inside home_server

    map_data_complete <- shiny::reactive({
      shiny::req(map_dat())

      data <- map_dat() |>
        dplyr::mutate(
          popup_info = paste0(
            "<b>Area:</b> ",
            continent,
            "<br>",
            "<b>Country:</b> ",
            country,
            "<br>",
            "<b>Scientific Name:</b> ",
            display_label,
            "<br>",
            "<b>Life stag:</b> ",
            life_stage,
            "<br>",
            "<b>Sex:</b> ",
            sex,
            "<br>",
            "<b>Collector Name:</b> ",
            creator,
            "<br>",
            "<b>n:</b> ",
            individual_count
          )
        ) |>
        dplyr::collect()
    })

    shiny::observe({
      cli::cli_inform(
        "Checking sidebar vals: {.val {is.null(home_sidebar_vals())}}"
      )

      cli::cli_inform(
        "map_dat returned row count: {.val {nrow(map_data_complete())}}"
      )
    })

    output$map <- leaflet::renderLeaflet({
      df <- map_data_complete()
      shiny::req(nrow(df) > 0)

      leaflet::leaflet(df) |>
        leaflet::addTiles() |>
        leaflet::addCircleMarkers(
          lng = ~longitude_decimal,
          lat = ~latitude_decimal,
          popup = ~popup_info
        )
    })
  })
}
