# tabs/home_ui.R
home_ui <- function(id) {
  ns <- NS(id)
  fluidPage(
    fluidRow(
      div(
        class = "value-box-wrapper",
        valueBoxOutput(ns("total_crashes"), width = 3)
      ),
      div(
        class = "value-box-wrapper",
        valueBoxOutput(ns("top_region_1"), width = 3)
      ),
      div(
        class = "value-box-wrapper",
        valueBoxOutput(ns("top_region_2"), width = 3)
      ),
      div(
        class = "value-box-wrapper",
        valueBoxOutput(ns("top_region_3"), width = 3)
      )
    ),
    fluidRow(
      div(
        box(
          title = "Filters", status = "warning", solidHeader = TRUE,
          width = 6,
          uiOutput(ns("region_filter")),
          uiOutput(ns("year_filter"))
        )
      )
    ),
    fluidRow(
      box(
        title = "Crashes by Region", status = "primary", solidHeader = TRUE,
        width = 12, plotlyOutput(ns("plot1"))
      )
    )
  )
}
