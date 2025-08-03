# ============================================================================
# CrashInsightsNZ - Main Server Logic
# ============================================================================
# Main server function that coordinates all modules for the Shiny dashboard
# Author: Marco Vieto Vega
# Date: 2024

library(shiny)
library(shinydashboard)
library(plotly)

# Load all tab-specific server modules
source("tabs/home_server.R")
source("tabs/map_server.R")
source("tabs/download_server.R")
source("tabs/compare_server.R")

#' Main server function for CrashInsightsNZ dashboard
#' @param input Shiny input object
#' @param output Shiny output object  
#' @param session Shiny session object
server <- function(input, output, session) {
  # Initialize all tab modules
  callModule(home_server, "home")
  callModule(map_server, "map")
  callModule(download_server, "download")
  callModule(compare_server, "compare")
}
