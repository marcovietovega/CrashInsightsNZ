library(shiny)
library(shinydashboard)

compare_ui <- function(id) {
  ns <- NS(id)
  
  fluidPage(
    fluidRow(
      box(
        title = "Region Comparison",
        solidHeader = TRUE,
        width = 12,
        fluidRow(
          column(6,
                 uiOutput(ns("region1"))),
          column(6,
                 uiOutput(ns("region2")))
        )
      )
    ),
    fluidRow(
      valueBoxOutput(ns("region1_total_crashes"), width = 6),
      valueBoxOutput(ns("region2_total_crashes"), width = 6)
    ),
    fluidRow(
      box(
        title = "Crashes Over the Years",
        solidHeader = TRUE,
        width = 6,
        plotlyOutput(ns("line_trend_years_1"))
      ),
      box(
        title = "Crashes Over the Years",
        solidHeader = TRUE,
        width = 6,
        plotlyOutput(ns("line_trend_years_2"))
      )
  ),
  fluidRow(
    valueBoxOutput(ns("region1_total_fatal"), width = 6),
    valueBoxOutput(ns("region2_total_fatal"), width = 6)
  ),
  fluidRow(
    box(
      title = "Crash Severity Distribution",
      solidHeader = TRUE,
      width = 6,
      plotlyOutput(ns("donut_severity_1"))
    ),
    box(
      title = "Crash Severity Distribution",
      solidHeader = TRUE,
      width = 6,
      plotlyOutput(ns("donut_severity_2"))
    )
  ),
  fluidRow(
    valueBoxOutput(ns("region1_avg_speed"), width = 6),
    valueBoxOutput(ns("region2_avg_speed"), width = 6)
  ),
  fluidRow(
    box(
      title = "Crashes by Weather Conditions",
      solidHeader = TRUE,
      width = 6,
      plotlyOutput(ns("bar_weather_1"))
    ),
    box(
      title = "Crashes by Weather Conditions",
      solidHeader = TRUE,
      width = 6,
      plotlyOutput(ns("bar_weather_2"))
    )
  ),
  fluidRow(
    valueBoxOutput(ns("region1_holiday_region"), width = 6),
    valueBoxOutput(ns("region2_holiday_region"), width = 6)
  ),
  fluidRow(
    box(
      title = "Crashes by Vehicle Type",
      solidHeader = TRUE,
      width = 6,
      plotlyOutput(ns("bar_vehicle_region1"))
    ),
    box(
      title = "Crashes by Vehicle Type",
      solidHeader = TRUE,
      width = 6,
      plotlyOutput(ns("bar_vehicle_region2"))
    )
  )
)
}
