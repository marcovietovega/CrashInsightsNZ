# ============================================================================
# Download Tab - UI Module
# ============================================================================
# UI module for the data download functionality
# Allows users to filter and download crash data

library(shiny)
library(shinydashboard)
library(DT)
library(shinyWidgets)

#' UI module for data download tab
#' @param id Module ID for namespacing
#' @return Shiny UI elements for the download tab
download_ui <- function(id) {
  ns <- NS(id)
  
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
