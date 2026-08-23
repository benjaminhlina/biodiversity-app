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

    output$map <- leaflet::renderLeaflet({
      # Check if the table exists before proceeding
      if (!"tbl_location" %in% DBI::dbListTables(con)) {
        return(
          leaflet::leaflet() |>
            leaflet::addTiles() |>
            leaflet::addMarkers(lng = 0, lat = 0, popup = "No Data")
        )
      }
    })
  })
}
