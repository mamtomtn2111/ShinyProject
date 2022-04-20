library("htmltools")

addLabel <- function(data) {
  data$label <- paste0(
    '<b>', ifelse(is.na(data$`Province/State`), data$`Country/Region`, data$`Province/State`), '</b><br>
    <table style="width:120px;">
    <tr><td>\u0053\u1ed1\u0020\u0063\u0061\u0020\u006e\u0068\u0069\u1ec5\u006d:</td><td align="right">', data$confirmed, '</td></tr>
    <tr><td>\u0053\u1ed1\u0020\u0063\u0061\u0020\u0074\u1eed\u0020\u0076\u006f\u006e\u0067:</td><td align="right">', data$deceased, '</td></tr>
    <tr><td>\u0048\u1ed3\u0069\u0020\u0070\u0068\u1ee5\u0063\u0020\u0028\u01b0\u1edb\u0063\u0020\u0074\u00ed\u006e\u0068\u0029:</td><td align="right">', data$recovered, '</td></tr>
    <tr><td>\u0043\u0068\u01b0\u0061\u0020\u006b\u0068\u1ecf\u0069\u0020\u0062\u1ec7\u006e\u0068:</td><td align="right">', data$active, '</td></tr>
    </table>'
  )
  data$label <- lapply(data$label, HTML)

  return(data)
}

map <- leaflet(addLabel(data_latest)) %>%
  setMaxBounds(-180, -90, 180, 90) %>%
  setView(0, 20, zoom = 2) %>%
  addTiles() %>%
  addProviderTiles(providers$CartoDB.Positron, group = "Light") %>%
  addProviderTiles(providers$HERE.satelliteDay, group = "Satellite") %>%
  addLayersControl(
    baseGroups    = c("Light", "Satellite"),
    overlayGroups = c("Confirmed", "Confirmed (per capita)", "Estimated Recoveries", "Deceased", "Active", "Active (per capital)")
  ) %>%
  hideGroup("Confirmed (per capital)") %>%
  hideGroup("Estimated Recoveries") %>%
  hideGroup("Deceased") %>%
  hideGroup("Active") %>%
  hideGroup("Active (per capita)") %>%
  addEasyButton(easyButton(
    icon    = "glyphicon glyphicon-globe", title = "Reset zoom",
    onClick = JS("function(btn, map){ map.setView([20, 0], 2); }"))) %>%
  addEasyButton(easyButton(
    icon    = "glyphicon glyphicon-map-marker", title = "Locate Me",
    onClick = JS("function(btn, map){ map.locate({setView: true, maxZoom: 6}); }")))

observe({
  req(input$timeSlider, input$overview_map_zoom)
  zoomLevel               <- input$overview_map_zoom
  data                    <- data_atDate(input$timeSlider) %>% addLabel()
  data$confirmedPerCapita <- data$confirmed / data$population * 100000
  data$activePerCapita    <- data$active / data$population * 100000

  leafletProxy("overview_map", data = data) %>%
    clearMarkers() %>%
    addCircleMarkers(
      lng          = ~Long,
      lat          = ~Lat,
      radius       = ~log(confirmed^(zoomLevel / 2)),
      stroke       = FALSE,
      fillOpacity  = 0.5,
      label        = ~label,
      labelOptions = labelOptions(textsize = 15),
      group        = "Confirmed"
    ) %>%
    addCircleMarkers(
      lng          = ~Long,
      lat          = ~Lat,
      radius       = ~log(confirmedPerCapita^(zoomLevel)),
      stroke       = FALSE,
      color        = "#00b3ff",
      fillOpacity  = 0.5,
      label        = ~label,
      labelOptions = labelOptions(textsize = 15),
      group        = "Confirmed (per capita)"
    ) %>%
    addCircleMarkers(
      lng          = ~Long,
      lat          = ~Lat,
      radius       = ~log(recovered^(zoomLevel)),
      stroke       = FALSE,
      color        = "#005900",
      fillOpacity  = 0.5,
      label        = ~label,
      labelOptions = labelOptions(textsize = 15),
      group = "Estimated Recoveries"
    ) %>%
    addCircleMarkers(
      lng          = ~Long,
      lat          = ~Lat,
      radius       = ~log(deceased^(zoomLevel)),
      stroke       = FALSE,
      color        = "#E7590B",
      fillOpacity  = 0.5,
      label        = ~label,
      labelOptions = labelOptions(textsize = 15),
      group        = "Deceased"
    ) %>%
    addCircleMarkers(
      lng          = ~Long,
      lat          = ~Lat,
      radius       = ~log(active^(zoomLevel / 2)),
      stroke       = FALSE,
      color        = "#f49e19",
      fillOpacity  = 0.5,
      label        = ~label,
      labelOptions = labelOptions(textsize = 15),
      group        = "Active"
    ) %>%
    addCircleMarkers(
      lng          = ~Long,
      lat          = ~Lat,
      radius       = ~log(activePerCapita^(zoomLevel)),
      stroke       = FALSE,
      color        = "#f4d519",
      fillOpacity  = 0.5,
      label        = ~label,
      labelOptions = labelOptions(textsize = 15),
      group        = "Active (per capita)"
    )
})

output$overview_map <- renderLeaflet(map)


