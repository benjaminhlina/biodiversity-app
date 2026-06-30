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

  # list2env(start_up(), envir = globalenv())

  # message("cli connection: ", class(getOption("cli.output_connection")))

  # ---- ui ------
  ui <- shinydashboard::dashboardPage(
    # # ----- add google analytics -----
    # # shiny::includeScript(path = "/js/gtag.js"),
    # # ----- title -----
    # shinydashboard::dashboardHeader(
    #   title = "Great Lakes Aquatic Tissue Analysis Repository (GLATAR)",
    #   titleWidth = 500,
    #   shiny::tags$li(
    #     class = "dropdown",
    #     shiny::tags$a(
    #       href = "https://github.com/benjaminhlina/glatar-app",
    #       target = "_blank",
    #       shiny::icon("github", class = "fa-2x"),
    #       style = "padding-top: 10px; padding-bottom: 10px;"
    #     )
    #   )
    # ),
    # # ---- sidebar -----
    # shinydashboard::dashboardSidebar(
    #   width = 275,
    #   shinydashboard::sidebarMenu(
    #     id = "tabs",
    #     shinydashboard::menuItem(
    #       "Home",
    #       tabName = "home",
    #       icon = shiny::icon("home")
    #     ),
    #     shinydashboard::menuItem(
    #       "How to use GLATAR",
    #       tabName = "how_to_use",
    #       icon = shiny::icon("readme")
    #     ),
    #     shinydashboard::menuItem(
    #       "Summary Tables",
    #       tabName = "summary_info",
    #       icon = shiny::icon("bar-chart")
    #     ),
    #     shinydashboard::menuItem(
    #       "Scatter Plot",
    #       tabName = "scatter_plot",
    #       icon = shiny::icon("chart-line")
    #     ),
    #     shinydashboard::menuItem(
    #       "View Raw Data",
    #       tabName = "view_data",
    #       icon = shiny::icon("table")
    #     ),
    #     shinydashboard::menuItem(
    #       "View Source Material",
    #       tabName = "view_source",
    #       icon = shiny::icon("book")
    #     ),
    #     shinydashboard::menuItem(
    #       "Map",
    #       tabName = "view_map",
    #       icon = shiny::icon("map")
    #     ),
    #     shinydashboard::menuItem(
    #       "Taxonomic Search",
    #       tabName = "taxa_search",
    #       icon = shiny::icon("fish")
    #     ),
    #     shinydashboard::menuItem(
    #       "Upload Data",
    #       tabName = "insert_data",
    #       icon = shiny::icon("plus")
    #     ),
    #     shinydashboard::menuItem(
    #       "Documentation",
    #       tabName = "docs",
    #       icon = shiny::icon("print")
    #     ),
    #     shinydashboard::menuItem(
    #       "Registration",
    #       tabName = "register",
    #       icon = shiny::icon("address-card")
    #     ),
    #     shinydashboard::menuItem(
    #       "About",
    #       tabName = "about",
    #       icon = shiny::icon("circle-info")
    #     ),
    #     shinydashboard::menuItem(
    #       "Logout",
    #       tabName = "logout",
    #       icon = shiny::icon("sign-out-alt")
    #     )
    #   ),
    #   shinyjs::useShinyjs(),
    #   # Modularized panels
    #   shiny::conditionalPanel(
    #     "input.tabs == 'summary_info'",
    #     summary_sidebar_ui("summary_sidebar")
    #   ),
    #   shiny::conditionalPanel(
    #     "input.tabs == 'scatter_plot'",
    #     scatter_sidebar_ui("scatter_sidebar")
    #   ),
    #   shiny::conditionalPanel(
    #     "input.tabs == 'view_data'",
    #     raw_data_sidebar_ui("raw_sidebar")
    #   ),
    #   shiny::conditionalPanel(
    #     "input.tabs == 'view_source'",
    #     source_sidebar_ui("source_sidebar")
    #   )
    # ),
    # # ---- create display panes ----
    # shinydashboard::dashboardBody(
    #   # add  analytics
    #   shiny::tags$head(
    #     # shiny::HTML('<script src="/glatar/gtag.js"></script>'),
    #     # shiny::tags$script(
    #     #   async = NA,
    #     #   src = "https://www.googletagmanager.com/gtag/js?id=G-'G-KP6R7HNSDB"
    #     # ),
    #     # ----- add google analytics -----
    #     # shiny::includeScript(path = "/inst/js/gtag.js"),
    #     shiny::tags$script(src = "/js/gtag.js"),
    #     # ---- shiny.tictoc ----
    #     shiny::tags$script(
    #       src = "https://cdn.jsdelivr.net/gh/Appsilon/shiny.tictoc@v0.2.0/shiny-tic-toc.min.js"
    #     ),
    #     # ------ add in img right click disable -----
    #     # tags$script(HTML(
    #     #   '
    #     #   $(document).on("contextmenu", "img", function(e) {
    #     #   e.preventDefault();
    #     #   return false;
    #     #   });
    #     # '
    #     # )),
    #   ),
    #   # CSS for fixed footer
    #   app_version_head(),
    #   app_version_label(app_version),
    #   # tab itimes
    #   shinydashboard::tabItems(
    #     shinydashboard::tabItem(tabName = "home", home_tab_ui("home")),
    #     shinydashboard::tabItem(
    #       tabName = "how_to_use",
    #       how_to_ui("how_to_use")
    #     ),
    #     shinydashboard::tabItem(
    #       tabName = "summary_info",
    #       view_summary_info_ui("summary_info")
    #     ),
    #     shinydashboard::tabItem(
    #       tabName = "scatter_plot",
    #       view_scatter_plot_ui("scatter_plot")
    #     ),
    #     shinydashboard::tabItem(
    #       tabName = "view_data",
    #       view_data_ui("view_data")
    #     ),
    #     shinydashboard::tabItem(
    #       tabName = "view_source",
    #       view_source_ui("view_source")
    #     ),
    #     shinydashboard::tabItem(tabName = "view_map", view_map_ui("view_map")),
    #     shinydashboard::tabItem(
    #       tabName = "taxa_search",
    #       taxa_search_ui("taxa_search")
    #     ),
    #     shinydashboard::tabItem(
    #       tabName = "insert_data",
    #       upload_data_ui("insert_data")
    #     ),
    #     shinydashboard::tabItem(tabName = "docs", docs_ui("docs")),
    #     shinydashboard::tabItem(tabName = "about", about_ui("about")),
    #     shinydashboard::tabItem(tabName = "register", register_ui("register"))
    #   )
    # )
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
