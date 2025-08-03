# ============================================================================
# CrashInsightsNZ - Main UI Definition
# ============================================================================
# Main user interface definition for the Shiny dashboard
# Author: Marco Vieto Vega
# Date: 2024

library(shiny)
library(shinydashboard)
library(plotly)

# Load all tab-specific UI modules
source("tabs/home_ui.R")
source("tabs/map_ui.R")
source("tabs/download_ui.R")
source("tabs/compare_ui.R")

#' Main UI for CrashInsightsNZ dashboard
#' Creates a dashboard layout with sidebar navigation and tabbed content
ui <- dashboardPage(
  # Dashboard header with title
  dashboardHeader(title = "Crash Insights NZ"),
  
  # Sidebar with navigation menu
  dashboardSidebar(sidebarMenu(
    menuItem("Home", tabName = "home", icon = icon("dashboard")),
    menuItem(
      "Compare Regions",
      tabName = "compare",
      icon = icon("balance-scale")
    ),
    menuItem("Map", tabName = "map", icon = icon("map")),
    menuItem(
      "Data Download",
      tabName = "download",
      icon = icon("download")
    )
  )),
  
  # Main dashboard body with tabs
  dashboardBody(
    # Custom CSS styling
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    
    # Tab content panels
    tabItems(
      tabItem(tabName = "home", home_ui("home")),
      tabItem(tabName = "compare", compare_ui("compare")),
      tabItem(tabName = "map", map_ui("map")),
      tabItem(tabName = "download", download_ui("download"))
    )
  )
)
