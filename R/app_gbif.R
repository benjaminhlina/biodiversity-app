#' gbif Shiny App
#'
#' This function which has no arguments starts up the app,
#' creates the user interface (UI) and server and combines them
#' to make the app.
#'
#' @import shiny
#' @import shinydashboard
#' @importFrom shinyjs useShinyjs
#' @export

gbif_app <- function() {
  # ---- startup the app -----

  list2env(start_up(), envir = globalenv())

  # ---- ui ------

  ui <- shinydashboard::dashboardPage(
    skin = "green",
    # ----- title -----
    shinydashboard::dashboardHeader(
      title = "Global Biodiversity Information Facility - Appsilon",
      titleWidth = 500
    ),
    # ---- sidebar -----
    shinydashboard::dashboardSidebar(
      width = 275,
      shinydashboard::sidebarMenu(
        id = "tabs",
        shinydashboard::menuItem(
          text = "",
          tabName = "home"
        )
      ),
      shinyjs::useShinyjs(),
      # Modularized panels
      shiny::conditionalPanel(
        "input.tabs == 'home'",
        home_sidebar_ui("home_sidebar")
      )
    ),
    # ---- body ----
    shinydashboard::dashboardBody(
      shinydashboard::tabItems(
        shinydashboard::tabItem(tabName = "home", home_tab_ui("home"))
      )
    )
  )

  # ------ Main Server -----
  server <- function(input, output, session) {
    options(
      shiny.usecairo = FALSE
    )
    ram_tracker()
    session$allowReconnect("force")

    home_sidebar_vals <- home_sidebar_server(
      con = con,
      id = "home_sidebar",
      main_input = input
    )

    home_info <- home_server(
      id = "home",
      con = con,
      main_input = input,
      home_sidebar_vals = home_sidebar_vals
    )
  }

  # render ui and serve together to create dashboard
  shiny::shinyApp(ui = ui, server = server)
}
