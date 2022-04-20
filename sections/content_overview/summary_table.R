output$summaryTables <- renderUI({
  tabBox(
    tabPanel("\u0051\u0075\u1ed1\u0063\u0020\u0067\u0069\u0061\u002f\u0020\u006c\u00e3\u006e\u0068\u0020\u0074\u0068\u1ed5",
      div(
        dataTableOutput("summaryDT_country"),
        style = "margin-top: -10px")
    ),
    tabPanel("\u0054\u1ec9\u006e\u0068\u002f\u0020\u0074\u0068\u00e0\u006e\u0068\u0020\u0070\u0068\u1ed1",
      div(
        dataTableOutput("summaryDT_state"),
        style = "margin-top: -10px"
      )
    ),
    width = 12
  )
})

output$summaryDT_country <- renderDataTable(getSummaryDT(data_atDate(current_date), "Country/Region", selectable = TRUE))
proxy_summaryDT_country  <- dataTableProxy("summaryDT_country")
output$summaryDT_state   <- renderDataTable(getSummaryDT(data_atDate(current_date), "Province/State", selectable = TRUE))
proxy_summaryDT_state    <- dataTableProxy("summaryDT_state")

observeEvent(input$timeSlider, {
  data <- data_atDate(input$timeSlider)
  replaceData(proxy_summaryDT_country, summariseData(data, "Country/Region"), rownames = FALSE)
  replaceData(proxy_summaryDT_state, summariseData(data, "Province/State"), rownames = FALSE)
}, ignoreInit = TRUE, ignoreNULL = TRUE)

observeEvent(input$summaryDT_country_row_last_clicked, {
  selectedRow     <- input$summaryDT_country_row_last_clicked
  selectedCountry <- summariseData(data_atDate(input$timeSlider), "Country/Region")[selectedRow, "Country/Region"]
  location        <- data_evolution %>%
    distinct(`Country/Region`, Lat, Long) %>%
    filter(`Country/Region` == selectedCountry) %>%
    summarise(
      Lat  = mean(Lat),
      Long = mean(Long)
    )
  leafletProxy("overview_map") %>%
    setView(lng = location$Long, lat = location$Lat, zoom = 4)
})

observeEvent(input$summaryDT_state_row_last_clicked, {
  selectedRow     <- input$summaryDT_state_row_last_clicked
  selectedCountry <- summariseData(data_atDate(input$timeSlider), "Province/State")[selectedRow, "Province/State"]
  location <- data_evolution %>%
    distinct(`Province/State`, Lat, Long) %>%
    filter(`Province/State` == selectedCountry) %>%
    summarise(
      Lat  = mean(Lat),
      Long = mean(Long)
    )
  leafletProxy("overview_map") %>%
    setView(lng = location$Long, lat = location$Lat, zoom = 4)
})

summariseData <- function(df, groupBy) {
  df %>%
    group_by(!!sym(groupBy)) %>%
    summarise(
      "Confirmed"            = sum(confirmed, na.rm = T),
      "Estimated Recoveries" = sum(recovered, na.rm = T),
      "Deceased"             = sum(deceased, na.rm = T),
      "Active"               = sum(active, na.rm = T)
    ) %>%
    as.data.frame()
}

getSummaryDT <- function(data, groupBy, selectable = FALSE) {
  Setcolnames <- c("\u0051\u0075\u1ed1\u0063\u0020\u0067\u0069\u0061",
                   "\u0043\u0061\u0020\u006e\u0068\u0069\u1ec5\u006d",
                   "\u0048\u1ed3\u0069\u0020\u0070\u0068\u1ee5\u0063\u0020\u0028\u01b0\u1edb\u0063\u0020\u0074\u00ed\u006e\u0068\u0029",
                   "\u0053\u1ed1\u0020\u0063\u0061\u0020\u0074\u1eed\u0020\u0076\u006f\u006e\u0067",
                   "\u0043\u0068\u01b0\u0061\u0020\u006b\u0068\u1ecf\u0069\u0020\u0062\u1ec7\u006e\u0068")
  datatable(
    na.omit(summariseData(data, groupBy)),
    colnames = Setcolnames,
    rownames  = FALSE,
    options   = list(
      order          = list(1, "desc"),
      scrollX        = TRUE,
      scrollY        = "37vh",
      scrollCollapse = T,
      dom            = 'ft',
      paging         = FALSE
    ),
    selection = ifelse(selectable, "single", "none")
  )
}