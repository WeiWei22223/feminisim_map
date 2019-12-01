library(shiny)
library(leaflet)

main_page <- tabPanel(
  "Main",              # label for the tab in the navbar
  h2("Project Authors"),
  p("Wei Fan, Ruhan Hou", br(), br()),
  
  h2("Project Description"),
  p("The project includes diveristy map of 21 tech comany in .", br(), br()),
  
  h2("Dataset"),
  p("The dataset utilizes EEO1 report.", br(), br())
)

diversity_map <- tabPanel(
  "Map", 
  titlePanel("Diverity Map"),
  p("The Map below contains 21 companies in Silicon Valley."),
  leafletOutput("diveristy_map", width = 1300, height = 1000)
)

ui <- fluidPage(
  titlePanel("Feminism Map"),
  navbarPage(
    "Pages:", 
    main_page,                 # include the description
    diversity_map              # include women percentage in tech company
  )
)