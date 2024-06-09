# tabs/map_ui.R
map_ui <- function(id) {
  ns <- NS(id)
  
  fluidPage(
    fluidRow(
      column(
        width = 12,
        div(
          class = "filter-box",
          uiOutput(ns("region_filter")),
          uiOutput(ns("year_filter")),
          uiOutput(ns("severity_filter")),
          uiOutput(ns("weather_filter"))
        )
      )
    ),
    fluidRow(
          plotlyOutput(ns("map"), height = "calc(100vh - 50px)", width = "100%")
    )
  )
}
