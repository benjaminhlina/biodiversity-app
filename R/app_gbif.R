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
          "Home",
          tabName = "home",
          icon = shiny::icon("home")
        )
      ),
      shinyjs::useShinyjs()
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
  }

  # render ui and serve together to create dashboard
  shiny::shinyApp(ui = ui, server = server)
}
