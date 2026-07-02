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
    # # ----- title -----
    shinydashboard::dashboardHeader(
      title = "Global Biodiversity Information Facility - Appsilon",
      titleWidth = 500,
      shiny::tags$li(
        class = "dropdown",
        shiny::tags$a(
          href = "https://github.com/benjaminhlina/gbif-app",
          target = "_blank",
          shiny::icon("github", class = "fa-2x"),
          style = "padding-top: 10px; padding-bottom: 10px;"
        )
      )
    ),
    # # ---- sidebar -----
    shinydashboard::dashboardSidebar(
      width = 275,
      shinydashboard::sidebarMenu(
        id = "tabs",
        shinydashboard::menuItem(
          "Home",
          tabName = "home",
          icon = shiny::icon("home")
        ),

        #   shinydashboard::menuItem(
        #     "Map",
        #     tabName = "view_map",
        #     icon = shiny::icon("map")
        #   ),
      ),
      shinyjs::useShinyjs(),

      # # ---- create display panes ----
      shinydashboard::dashboardBody(
        # add  analytics
        # shiny::tags$head(

        #   # ----- add google analytics -----,
        #   shiny::tags$script(src = "/js/gtag.js"),
        #   # ---- shiny.tictoc ----
        #   shiny::tags$script(
        #     src = "https://cdn.jsdelivr.net/gh/Appsilon/shiny.tictoc@v0.2.0/shiny-tic-toc.min.js"
        #   ),

        # ),
        # CSS for fixed footer
        # app_version_head(),
        # app_version_label(app_version),
        # tab itimes
        shinydashboard::tabItems(
          shinydashboard::tabItem(tabName = "home", home_tab_ui("home"))
          # shinydashboard::tabItem(
          #   tabName = "view_map",
          #   view_map_ui("view_map")
          # )
        )
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
