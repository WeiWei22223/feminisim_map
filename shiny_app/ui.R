library(shiny)
library(leaflet)

main_page <- tabPanel(
  "Main",              # label for the tab in the navbar
  h2("Project Authors"),
  p("Wei Fan", br(), br()),
  h2("Project Description"),
  h2("Dataset")
)

world_map <- tabPanel(
  "World Map", 
  h2("Countries Passed Same Sex Marriage Law by 2019"),
  leafletOutput("world_wide_map", width = 1200, height = 700)
)

US_map <- tabPanel(
  "US Map",
  h2("States in US Passed Same Sex Marraiage Law by 2019")
)


ui <- fluidPage(
  titlePanel("Feminism Map"),
  navbarPage(
    "Pages:", 
    main_page,         # include the description
    world_map,         # include the world Map
    US_map             # include the US Map
  )
)