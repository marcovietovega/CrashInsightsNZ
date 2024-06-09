download_server <- function(input, output, session) {
  ns <- session$ns
  library(dplyr)
  library(DBI)
  library(RSQLite)
  
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
  
  filtered_data <- reactive({
    req(input$region, input$year_filter)
    
    query <- "SELECT crashyear, crashSeverity, light, region, speedLimit, weatherA as weather, NumberOfLanes, roadSurface, tlaName, crashLocation1, crashLocation2, longitude, latitude FROM crash_data WHERE crashyear BETWEEN ? AND ?"
    params <- list(input$year_filter[1], input$year_filter[2])
    
    if (length(input$region) < length(unique_regions()$region)) {
      regions_query <- paste0(" AND region IN (", paste(rep("?", length(input$region)), collapse = ", "), ")")
      query <- paste0(query, regions_query)
      params <- c(params, input$region)
    }
    
    dbGetQuery(con, query, params = params)
  })
  
  output$download_data <- downloadHandler(
    filename = function() {
      paste("crash_data-", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      data <- filtered_data()
      write.csv(data, file, row.names = FALSE)
    }
  )
  
  output$data_table <- renderDataTable({
    filtered_data()
    }, options = list(searching = FALSE, scrollX = TRUE))
  
  session$onSessionEnded(function() {
    dbDisconnect(con)
  })
}
