download_ui <- function(id) {
  ns <- NS(id)
  
  library(DT)
  
  fluidPage(fluidRow(
    box(
      title = "Filters",
      status = "warning",
      solidHeader = TRUE,
      width = 12,
      uiOutput(ns("region_filter")),
      uiOutput(ns("year_filter"))
    )
  ), 
  fluidRow(
    box(
      width = 12,
      downloadButton(ns("download_data"), "Download Data"),
      DT::DTOutput(ns("data_table"))
    )
  )
)
}
