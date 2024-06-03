# ui.R
library(shiny)
library(shinydashboard)
library(plotly)

source("tabs/home_ui.R")
source("tabs/ml_ui.R")
source("tabs/download_ui.R")
source("tabs/compare_ui.R")

ui <- dashboardPage(
  dashboardHeader(title = "Crash Insights NZ"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("dashboard")),
      menuItem("Compare Regions", tabName = "compare", icon = icon("balance-scale")),
      menuItem("Machine Learning", tabName = "ml", icon = icon("cogs")),
      menuItem("Data Download", tabName = "download", icon = icon("download"))
    )
  ),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    tabItems(
      tabItem(tabName = "home", home_ui("home")),
      tabItem(tabName = "compare", compare_ui("compare")),
      tabItem(tabName = "ml", ml_ui("ml")),
      tabItem(tabName = "download", download_ui("download"))
    )
  )
)
