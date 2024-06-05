# tabs/home_server.R
home_server <- function(input, output, session) {
  ns <- session$ns
  library(dplyr)
  library(DBI)
  library(RSQLite)
  library(plotly)
  library(shinyWidgets)
  
  con <- dbConnect(SQLite(), "crash_data.sqlite")
  
  unique_regions <- reactive({
    dbGetQuery(con, "SELECT region FROM regions")
  })
  
  unique_years <- reactive({
    dbGetQuery(con, "SELECT crashYear FROM years")
  })
  
  output$region_filter <- renderUI({
    req(unique_regions())
    pickerInput(
      ns("region"),
      "Select Region:",
      choices = unique_regions()$region,
      selected = unique_regions()$region,
      multiple = TRUE,
      options = pickerOptions(actionsBox = TRUE)
    )
  })
  
  output$year_filter <- renderUI({
    req(unique_years())
    years <- unique_years()$crashYear
    sliderInput(
      ns("year_filter"),
      "Select Year Range:",
      min = min(years),
      max = max(years),
      value = c(min(years), max(years)),
      step = 1,
      sep = ""
    )
  })
  
  filtered_data_totalcrashes <- reactive({
    req(input$region, input$year_filter)
    
    query <- "SELECT sum(total_crashes) total_crashes FROM total_crashes_by_region WHERE crashYear BETWEEN ? AND ?"
    params <- list(input$year_filter[1], input$year_filter[2])
    
    if (length(input$region) < length(unique_regions()$region)) {
      regions_query <- paste0(" AND region IN (", paste(rep("?", length(input$region)), collapse = ", "), ")")
      query <- paste0(query, regions_query)
      params <- c(params, input$region)
    }
    
    dbGetQuery(con, query, params = params)
  })
  
  filtered_data_totals_by_region <- reactive({
    req(input$region, input$year_filter)
    
    query <- "SELECT region, sum(total_crashes) total_crashes FROM total_crashes_by_region WHERE crashYear BETWEEN ? AND ?"
    params <- list(input$year_filter[1], input$year_filter[2])
    
    if (length(input$region) < length(unique_regions()$region)) {
      regions_query <- paste0(" AND region IN (", paste(rep("?", length(input$region)), collapse = ", "), ")")
      query <- paste0(query, regions_query)
      params <- c(params, input$region)
    }
    query <- paste0(query, " GROUP BY region")
    dbGetQuery(con, query, params = params)
  })
  
  output$total_crashes <- renderValueBox({
    req(filtered_data_totalcrashes())
    valueBox(
      value = filtered_data_totalcrashes()$total_crashes,
      subtitle = "Total Crashes",
      icon = icon("car-crash"),
      color = "purple"
    )
  })
  
  output$top_region_1 <- renderValueBox({
    req(filtered_data_totals_by_region())
    
    data <- filtered_data_totals_by_region() %>%
      arrange(desc(total_crashes)) %>%
      slice_head(n = 1)
    
    valueBox(
      value = data$total_crashes,
      subtitle = paste("Crashes in", data$region),
      icon = icon("map-marker-alt"),
      color = "orange"
    )
  })
  
  output$top_region_2 <- renderValueBox({
    req(filtered_data_totals_by_region())
    
    data <- filtered_data_totals_by_region() %>%
      arrange(desc(total_crashes)) %>%
      slice_head(n = 2) %>%
      slice_tail(n = 1)
    
    valueBox(
      value = data$total_crashes,
      subtitle = paste("Crashes in", data$region),
      icon = icon("map-marker-alt"),
      color = "green"
    )
  })
  
  output$top_region_3 <- renderValueBox({
    req(filtered_data_totals_by_region())
    
    data <- filtered_data_totals_by_region() %>%
      arrange(desc(total_crashes)) %>%
      slice_head(n = 3) %>%
      slice_tail(n = 1)
    
    valueBox(
      value = data$total_crashes,
      subtitle = paste("Crashes in", data$region),
      icon = icon("map-marker-alt"),
      color = "blue"
    )
  })
  
  output$plot1 <- renderPlotly({
    req(filtered_data_totals_by_region())
    plot_ly(
      filtered_data_totals_by_region(),
      x = ~region,
      y = ~total_crashes,
      type = "bar"
    ) %>%
      layout(
        xaxis = list(title = "Regions", tickangle = -45),
        yaxis = list(title = "Number of Crashes"),
        margin = list(b = 1)
      )
  })
  
  session$onSessionEnded(function() {
    dbDisconnect(con)
  })
}
