output$selectize_casesByCountries <- renderUI({
  selectizeInput(
    "caseEvolution_country",
    label    = "Select Countries",
    choices  = unique(data_evolution$`Country/Region`),
    selected = top5_countries,
    multiple = TRUE
  )
})

output$case_evolution <- renderPlotly({
  data <- data_evolution %>%
    group_by(date, var) %>%
    summarise(
      "value" = sum(value, na.rm = T)
    ) %>%
    as.data.frame()

  p <- plot_ly(
    data,
    x     = ~date,
    y     = ~value,
    name  = sapply(data$var, capFirst),
    color = ~var,
    type  = 'scatter',
    mode  = 'lines') %>%
    layout(
      yaxis = list(title = "\u0053\u1ed1\u0020\u0063\u0061"),
      xaxis = list(title = "\u004e\u0067\u00e0\u0079")
    )


  if (input$checkbox_logCaseEvolution) {
    p <- layout(p, yaxis = list(type = "log"))
  }

  return(p)
})
