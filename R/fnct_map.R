# ----- make base_map -----

#' Map functions
#'
#' These functions create `{leaflet}` maps to display the data
#'
#' @param df a `reactive()` object containing the data to be
#' represented on the map.
#'
#' @details
#' If df is null or does not have any rows then
#' base map with message iss displayed
#'
#' @name map_functions
#' @export

base_map <- function(df) {
  if (is.null(df) || nrow(df) == 0) {
    msg_html <- "
      <div style='
        background-color: #ffffff;
        border: 2px solid #2196F3;
        border-left: 12px solid #2196F3;
        padding: 15px 20px;
        border-radius: 4px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        display: flex;
        align-items: center;
        max-width: 450px;
        font-family: sans-serif;
      '>
        <div style='
          background-color: #2196F3;
          color: white;
          border-radius: 50%;
          width: 28px;
          height: 28px;
          display: flex;
          align-items: center;
          justify-content: center;
          font-weight: bold;
          font-size: 16px;
          margin-right: 15px;
          flex-shrink: 0;
        '>i</div>
        <span style='color: #333333; font-size: 14pt; line-height: 1.3;'>
          Select one or more countries from the sidebar to view data.
        </span>
      </div>"

    map <- leaflet::leaflet() |>
      leaflet::addTiles() |>
      leaflet::addControl(
        html = msg_html,
        position = "topright", # Note: Control positions use topright/bottomleft/etc.
        className = "custom-map-alert"
      )
  } else {
    map <- leaflet::leaflet(df) |>
      leaflet::addTiles()
  }

  return(
    map
  )
}
