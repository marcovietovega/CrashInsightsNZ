# tabs/home_ui.R
home_ui <- function(id) {
  ns <- NS(id)
  fluidPage(
    fluidRow(
      div(class = "value-box-wrapper", valueBoxOutput(ns("total_crashes"), width = 3)),
      div(class = "value-box-wrapper", valueBoxOutput(ns("top_region_1"), width = 3)),
      div(class = "value-box-wrapper", valueBoxOutput(ns("top_region_2"), width = 3)),
      div(class = "value-box-wrapper", valueBoxOutput(ns("top_region_3"), width = 3))
    ),
    fluidRow(
      div(
          box(
            title = "Filters", status = "warning", solidHeader = TRUE,
            width = 12,
            uiOutput(ns("region_filter")),
            uiOutput(ns("severity_filter")),
            uiOutput(ns("weather_filter"))
          )
      )
    ),
    fluidRow(
      box(
        title = "Crash Severity Distribution", status = "primary", solidHeader = TRUE,
        width = 6, plotlyOutput(ns("plot1"))
      ),
      box(
        title = "Number of Crashes by Severity", status = "primary", solidHeader = TRUE,
        width = 6, plotlyOutput(ns("plot2"))
      )
    ),
    fluidRow(
      box(
        title = "Crashes by Region", status = "primary", solidHeader = TRUE,
        width = 6, plotlyOutput(ns("plot3"))
      ),
      box(
        title = "Crashes by Weather Condition", status = "primary", solidHeader = TRUE,
        width = 6, plotlyOutput(ns("plot4"))
      )
    )
  )
}
