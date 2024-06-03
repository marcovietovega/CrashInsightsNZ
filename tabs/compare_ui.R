# tabs/compare_ui.R
compare_ui <- function(id) {
  ns <- NS(id)
  fluidPage(
    fluidRow(
      box(
        title = "Compare Regions", status = "warning", solidHeader = TRUE,
        width = 12,
        selectInput(ns("region1"), "Select First Region:", choices = NULL),
        selectInput(ns("region2"), "Select Second Region:", choices = NULL)
      )
    ),
    fluidRow(
      box(
        title = "Crash Severity Comparison", status = "primary", solidHeader = TRUE,
        width = 6, plotlyOutput(ns("plot1"))
      ),
      box(
        title = "Crashes by Weather Condition Comparison", status = "primary", solidHeader = TRUE,
        width = 6, plotlyOutput(ns("plot2"))
      )
    ),
    fluidRow(
      box(
        title = "Number of Crashes by Time of Day", status = "primary", solidHeader = TRUE,
        width = 6, plotlyOutput(ns("plot3"))
      ),
      box(
        title = "Number of Crashes by Road Type", status = "primary", solidHeader = TRUE,
        width = 6, plotlyOutput(ns("plot4"))
      )
    )
  )
}
