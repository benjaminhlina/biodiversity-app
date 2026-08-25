#' Display functions
#'
#' These functions are all display different things for the user.
#' They function by wrapping the given display object (e.g.,
#' slider) with a `render*()` function from `shiny`.
#'
#' @param data a reactive data object for a given variable.
#' `observe()` or `observeEvent()` calls within a module.
#' @param output an output within a shiny module.
#' @param output_id the id name of the output, e.g., `"summary_histogram"`.
#' @param session module session.
#'
#' @name display_functions
#' @export

display_slider <- function(data, output, output_id, session) {
  output[[output_id]] <- shiny::renderUI({
    shiny::req(data())
    df <- data()
    shiny::req(!is.null(df), nrow(df) > 0)
    shiny::req(!all(is.na(df$date_time)))

    dt_min <- min(df$date_time, na.rm = TRUE)
    dt_max <- max(df$date_time, na.rm = TRUE)

    shiny::sliderInput(
      inputId = session$ns("date_range"),
      label = "Filter by the date and time observered",
      min = dt_min,
      max = dt_max,
      value = c(dt_min, dt_max),
      timeFormat = "%Y-%m-%d %H:%M",
      width = "100%"
    )
  })
}

#' @name display_functions
#' @export

display_map <- function(data, output, output_id) {
  output[[output_id]] <- leaflet::renderLeaflet({
    shiny::req(data())
    df <- data()

    pal <- leaflet::colorNumeric(
      palette = "viridis",
      domain = df$individual_count
    )

    map <- base_map(df)
    if (!is.null(df) && nrow(df) > 0) {
      map <- map |>
        leaflet::addCircleMarkers(
          lng = ~longitude_decimal,
          lat = ~latitude_decimal,
          popup = ~popup_info,
          radius = ~ scales::rescale(sqrt(individual_count), to = c(4, 20)),
          fillColor = ~ pal(individual_count),
          fillOpacity = 0.8,
          stroke = TRUE,
          weight = 1,
          color = "black"
        ) |>
        leaflet::addLegend(
          position = "bottomright",
          pal = pal,
          values = ~individual_count,
          title = "Individuals Observed",
          opacity = 0.8
        )
    }
    return(map)
  })
}
