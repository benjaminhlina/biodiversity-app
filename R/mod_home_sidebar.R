#' Home Sidebar
#'
#' Provides the sidebar for the home table pane.
#'
#' @param id the shiny namespace id name (i.e., `"home_sidebar"`).
#'
#' @details `home_sidebar_ui()` provides the home sidebar user interface.
#'
#' @name home_sidebar_module
#' @export

home_sidebar_ui <- function(id) {
  ns <- shiny::NS(id)

  shiny::tagList(
    shinyjs::useShinyjs(),
    shiny::div(
      id = ns("home_ui"),
      style = "display:none;",
      shiny::conditionalPanel(
        condition = "input.tabs == 'home'",
        shiny::selectizeInput(
          ns("country_filter"),
          "Select a Country",
          choices = NULL,
          multiple = TRUE
        ),
        shiny::selectizeInput(
          ns("home_species_filter_gs"),
          "Filter by Scientific Name",
          choices = NULL,
          multiple = TRUE
        ),
        shiny::selectizeInput(
          ns("home_species_filter_vn"),
          "Filter by Vernacular Name",
          choices = NULL,
          multiple = TRUE
        )
      )
    )
  )
}
# ----- summmary -----

#' @param id the shiny namespace id name (i.e., `"home_sidebar"`).
#' @param con a `DBI` conection to, in this case DuckDB database.
#' @param main_input the shiny input from the main server
#'
#' @details `home_sidebar_server()` provides the home table sidebar server.
#'
#' @name home_sidebar_module
#' @export
home_sidebar_server <- function(id, con, main_input) {
  shiny::moduleServer(id, function(input, output, session) {
    shiny::observe({
      shinyjs::toggle(
        id = "home_ui",
        condition = main_input$tabs == "home"
      )
    })

    # ---- initalize ------
    initialized <- shiny::reactiveVal(FALSE)
    updating <- shiny::reactiveVal(FALSE)

    # --- get sidebar info -----
    shiny::observeEvent(
      main_input$tabs,
      {
        shiny::req(main_input$tabs == "home")
        shiny::req(!initialized())

        filters <- c(
          "country_filter",
          "home_species_filter_gs",
          "home_species_filter_vn"
        )

        purrr::walk(filters, ~ exclusive_all_observer(input, session, .x))

        shiny::updateSelectizeInput(
          session,
          "country_filter",
          choices = c("All", countries$title),
          selected = "Poland",
          options = list(
            maxOptions = 50,
            placeholder = "Type to select countries....",
            openOnFocus = FALSE
          )
        )
        initialized(TRUE)
      },
      ignoreInit = FALSE
    )

    # --- Update species when Country changes ---
    shiny::observeEvent(
      input$country_filter,
      {
        shiny::req(initialized())
        refresh_species_by_country(input, session, con, updating)
      },
      ignoreInit = TRUE
    )

    # ----- export what we need from the server ----
    # we need country and species filters
    return(list(
      country = shiny::reactive(input$country_filter),
      species_filter_gs = shiny::reactive(input$home_species_filter_gs),
      species_filter_vn = shiny::reactive(input$home_species_filter_vn)
    ))
  })
}
