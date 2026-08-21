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

        # ----- create species choises -----

        # Country Drop-down

        sci_name <- get_dropdown_options(
          con,
          "tbl_occ",
          "scientific_name",
          # filter_col = "country"
        )
        vern_name <- get_dropdown_options(
          con,
          "tbl_occ",
          "vernacular_name",
          # filter_col = "country"
        )
        shiny::updateSelectizeInput(
          session,
          "country_filter",
          choices = c("All", countries$title),
          selected = "Poland"
        )

        # Species Drop-down

        shiny::updateSelectizeInput(
          session,
          "home_species_filter_gs",
          choices = c(
            "All",
            sci_name
          ),
          selected = "All",
          server = TRUE
        )
        # commmon name drop drown
        shiny::updateSelectizeInput(
          session,
          "home_species_filter_vn",
          choices = c("All"),
          selected = "All",
          server = TRUE
        )
        # Update y summary  variable choices

        # set inalize as true to make this trigger once it is hit
        initialized(TRUE)
      },
      ignoreInit = FALSE
    )

    shiny::observeEvent(
      input$country_filter,
      {
        shiny::req(initialized())
        refresh_filters(input, session, con, updating, "country_filter")
      },
      ignoreInit = TRUE
    )

    shiny::observeEvent(
      input$home_species_filter_gs,
      {
        shiny::req(initialized())
        refresh_filters(input, session, con, updating, "home_species_filter_gs")
      },
      ignoreInit = TRUE
    )

    shiny::observeEvent(
      input$home_species_filter_vn,
      {
        shiny::req(initialized())
        refresh_filters(input, session, con, updating, "home_species_filter_vn")
      },
      ignoreInit = TRUE
    )

    # ----- export what we need from the server ----
    # we need grouping and hist variables we also need the function

    return(list(
      country = shiny::reactive(input$country_filter),
      species_filter_gs = shiny::reactive(input$home_species_filter_gs),
      species_filter_vn = shiny::reactive(input$home_species_filter_vn)
    ))
  })
}
