#' Create functions
#'
#' These functions are all use other functions to create
#' `shiny::reactive()` objects usually used in modules.
#' Any function that uses a `reactive()` call is considered
#' to be creating an object that is then displayed in the UI.
#'
#'
#' @param con a databae connection
#' @param input_source usually an object created by a sidebar
#' function. These objects tend to be `reactive()` outcomes from
#' `observe()` or `observeEvent()` calls within a module.
#'
#' @details
#' `create_base_data()` creates base data to be used in interactive map.
#'
#' @name create_functions
#' @export
create_base_data <- function(con, input_source) {
  shiny::reactive({
    shiny::req(input_source())
    data <- get_map_data(con = con, input = input_source())

    if (!is.null(data)) {
      data <- data |>
        dplyr::collect()
    }
    return(data)
  })
}


# ----- create filtered data ------

#' @param data a `reactive()` data frame like object usually
#' created from another `create_function`. Considering
#' raw data is gathered through a PostgresSQL connection
#' these reactive objects tend to be `tbl_lazy`.
#' @param input shiny input.
#' @details
#' `create_filtered_data()` creates filtered data to be used in interactive map.
#'
#' @name create_functions
#' @export
create_filtered_data <- function(data, input) {
  shiny::reactive({
    shiny::req(data())
    df <- data()
    shiny::req(!is.null(df))

    if (!is.null(input$date_range)) {
      df <- df |>
        dplyr::filter(
          date_time >= input$date_range[1],
          date_time <= input$date_range[2]
        )
    }
    return(df)
  })
}
