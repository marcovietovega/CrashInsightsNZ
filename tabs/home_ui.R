home_ui <- function(id) {
  ns <- NS(id)
  fluidPage(
    fluidRow(
      div(valueBoxOutput(ns("total_crashes"), width = 3)),
      div(valueBoxOutput(ns("top_region_1"), width = 3)),
      div(valueBoxOutput(ns("top_region_2"), width = 3)),
      div(valueBoxOutput(ns("top_region_3"), width = 3))
    ),
    fluidRow(
      class = "plot-box-wrapper",
      box(
        title = "Filters",
        solidHeader = TRUE,
        width = 4,
        height = 460,
        uiOutput(ns("region_filter")),
        uiOutput(ns("year_filter")),
        uiOutput(ns("severity_filter")),
        uiOutput(ns("weather_filter")),
        uiOutput(ns("vehicle_filter"))
      ),
      box(
        title = "Crashes Over the Years",
        class = "plot-box-wrapper",
        solidHeader = TRUE,
        width = 8,
        height = 460,
        plotlyOutput(ns("line_trend_years"))
      )
    ),
    fluidRow(
      class = "plot-box-wrapper",
      box(
        title = "Crashes by Region",
        solidHeader = TRUE,
        width = 4,
        plotlyOutput(ns("bar_crash_region"))
      ),
      box(
        title = "Crashes by Weather Conditions",
        solidHeader = TRUE,
        width = 4,
        plotlyOutput(ns("pie_weather"))
      ),
      box(
        title = "Vehicle Type vs. Crash Severity",
        solidHeader = TRUE,
        width = 4,
        plotlyOutput(ns("stacked_vehicle_severity"))
      )
    ),
    fluidRow(
      class = "plot-box-wrapper",
      box(
        title = "Light Conditions vs. Weather Conditions",
        solidHeader = TRUE,
        width = 6,
        plotlyOutput(ns("stacked_light_weather"))
      ),
      box(
        title = "Speed Limit vs. Crash Severity",
        solidHeader = TRUE,
        width = 6,
        plotlyOutput(ns("bubble_speed"))
      )
    )
  )
}
