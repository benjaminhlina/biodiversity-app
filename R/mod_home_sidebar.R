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
          ns("species_search"),
          label = "Search Taxa",
          choices = NULL,
          options = list(
            placeholder = "Type to search by species...",
            maxOptions = 50,
            openOnFocus = FALSE
          )
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

        initial_country <- "Poland"
        # Correct syntax
        shiny::freezeReactiveValue(input, "species_search")

        shiny::updateSelectizeInput(
          session,
          "country_filter",
          choices = c(countries$title),
          selected = initial_country,
          options = list(
            placeholder = "Type to select countries....",
            openOnFocus = FALSE
          )
        )
        # initialized(TRUE)
        # Trigger initial species query using default selected country
        search_species(session, input, con, selected_country = initial_country)
      },
      ignoreInit = FALSE
    )

    # --- Update species when Country changes ---
    shiny::observeEvent(
      input$country_filter,
      {
        if (!initialized()) {
          initialized(TRUE)
          return()
        }
        shiny::freezeReactiveValue(input, "species_search")
        search_species(session, input, con)
      },
      ignoreInit = TRUE
    )

    # ----- export what we need from the server ----
    # we need country and species filters
    return(
      shiny::reactive({
        list(
          country_filter = input$country_filter,
          species_filter = input$species_search
        )
      })
    )
  })
}
