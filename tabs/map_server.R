map_server <- function(input, output, session) {
  ns <- session$ns
  library(plotly)
  library(DBI)
  library(RSQLite)
  library(jsonlite)
  
  con <- dbConnect(SQLite(), "crash_data.sqlite")
  
  unique_regions <- reactive({
    dbGetQuery(con, "SELECT region FROM regions")
  })
  
  unique_years <- reactive({
    dbGetQuery(con, "SELECT crashYear FROM years")
  })
  
  unique_severity <- reactive({
    dbGetQuery(con, "SELECT crashSeverity FROM crashSeverity")
  })
  
  unique_weather <- reactive({
    dbGetQuery(con, "SELECT weather FROM weather")
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
      value = c(2020, 2022),
      step = 1,
      sep = "",
      ticks = FALSE
    )
  })
  
  output$severity_filter <- renderUI({
    req(unique_severity())
    pickerInput(
      ns("severity"),
      "Select Severity:",
      choices = unique_severity()$crashSeverity,
      selected = unique_severity()$crashSeverity,
      multiple = TRUE,
      options = pickerOptions(actionsBox = TRUE)
    )
  })
  
  output$weather_filter <- renderUI({
    req(unique_weather())
    pickerInput(
      ns("weather"),
      "Select Weather Conditions:",
      choices = unique_weather()$weather,
      selected = unique_weather()$weather,
      multiple = TRUE,
      options = pickerOptions(actionsBox = TRUE)
    )
  })
  
  crash_data <- reactive({
    
    req(input$region,
        input$year_filter,
        input$severity,
        input$weather)
    
    query <- "SELECT longitude, latitude, crashSeverity, crashYear, region FROM crash_data WHERE crashYear BETWEEN ? AND ?"
    params <- list(input$year_filter[1], input$year_filter[2])
    
    if (length(input$region) < length(unique_regions()$region)) {
      regions_query <- paste0(" AND region IN (", paste(rep("?", length(input$region)), collapse = ", "), ")")
      query <- paste0(query, regions_query)
      params <- c(params, input$region)
    }
    
    if (length(input$severity) < length(unique_severity()$crashSeverity)) {
      severity_query <- paste0(" AND crashSeverity IN (", paste(rep("?", length(
        input$severity
      )), collapse = ", "), ")")
      query <- paste0(query, severity_query)
      params <- c(params, input$severity)
    }
    
    if (length(input$weather) < length(unique_weather()$weather)) {
      weather_query <- paste0(" AND weather IN (", paste(rep("?", length(
        input$weather
      )), collapse = ", "), ")")
      query <- paste0(query, weather_query)
      params <- c(params, input$weather)
    }
    
    dbGetQuery(con, query, params = params)
  })
  
  output$map <- renderPlotly({
    req(crash_data())
    
    plot_ly(
      data = crash_data(),
      lat = ~ latitude,
      lon = ~ longitude,
      text = ~ paste(
        "Region:",
        region,
        "<br>Year:",
        crashYear,
        "<br>Severity:",
        crashSeverity
      ),
      type = 'scattermapbox',
      mode = 'markers',
      color = ~ crashSeverity,
      colors = "RdBu",
      marker = list(size = 8, opacity = 1)
    ) %>%
      layout(
        mapbox = list(
          style = 'mapbox://styles/mapbox/streets-v11',
          accesstoken = 'pk.eyJ1IjoibXYwMzc5MCIsImEiOiJjbHg3MjYyaGgwa3hwMmlvbGJlM3Z6dXhsIn0.kYiQaXqnRpt-AQpTNwZo8Q',
          zoom = 6,
          center = list(
            lon = mean(crash_data()$longitude, na.rm = TRUE),
            lat = mean(crash_data()$latitude, na.rm = TRUE)
          )
        ),
        margin = list(
          t = 0,
          b = 0,
          l = 0,
          r = 0
        )
      )
  })
  
  session$onSessionEnded(function() {
    dbDisconnect(con)
  })
}