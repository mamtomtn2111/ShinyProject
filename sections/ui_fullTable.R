body_fullTable <- dashboardBody(
  tags$head(
    tags$style(type = "text/css", ".legend { list-style: none; margin-left: -30px;}"),
    tags$style(type = "text/css", ".legend li { float: left; margin-right: 10px; position: relative; }"),
    tags$style(type = "text/css", ".legend span { border: 1px solid #ccc; float: left; width: 30px; height: 15px;
    margin-right: 5px; margin-top: 1px; position: relative;"),
    tags$style(type = "text/css", ".legend .pos1 { background-color: #FFFFFF; }"),
    tags$style(type = "text/css", ".legend .pos2 { background-color: #FFE5E5; }"),
    tags$style(type = "text/css", ".legend .pos3 { background-color: #FFB2B2; }"),
    tags$style(type = "text/css", ".legend .pos4 { background-color: #FF7F7F; }"),
    tags$style(type = "text/css", ".legend .pos5 { background-color: #FF4C4C; }"),
    tags$style(type = "text/css", ".legend .pos6 { background-color: #983232; }"),
    tags$style(type = "text/css", ".legend .neg1 { background-color: #FFFFFF; }"),
    tags$style(type = "text/css", ".legend .neg2 { background-color: #CCE4CC; }"),
    tags$style(type = "text/css", ".legend .neg3 { background-color: #99CA99; }"),
    tags$style(type = "text/css", ".legend .neg4 { background-color: #66B066; }"),
    tags$style(type = "text/css", "@media (min-width: 768px) { .full-table { margin-top: -30px; } }")
  ),
  fluidPage(
    fluidRow(
      h3(paste0("\u0042\u1ea3\u006e\u0067\u0020\u0064\u1eef\u0020\u006c\u0069\u1ec7\u0075\u0020\u0111\u1ea7\u0079\u0020\u0111\u1ee7 (", strftime(current_date, format = "%d.%m.%Y"), ")"),
        class = "box-title", style = "margin-top: 10px; font-size: 18px;"),
      div(
        dataTableOutput("fullTable"),
        class = "full-table"
      ),
      width = 12
    )
  )
)

page_fullTable <- dashboardPage(
  title   = "Full Table",
  header  = dashboardHeader(disable = TRUE),
  sidebar = dashboardSidebar(disable = TRUE),
  body    = body_fullTable
)
