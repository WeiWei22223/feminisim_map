library(shiny)
library(leaflet)
library(geojsonio)

# data of countries that same sex marriage is legal
original_data <- read.csv("../dataset/countries_ss.csv", header = TRUE, stringsAsFactors = FALSE)

# Sort by law passed date
data <- original_data[order(original_data$legalizeYear), ]

# world map
world_country <-geojsonio::geojson_read("../dataset/custom.geo.json", what = "sp")

# Define server logic required to draw a histogram
my_server <- function(input, output) {
  
  # output$distPlot <- renderPlot({
  #   # generate bins based on input$bins from ui.R
  #   x    <- faithful[, 2] 
  #   bins <- seq(min(x), max(x), length.out = input$bins + 1)
  #   
  #   # draw the histogram with the specified number of bins
  #   hist(x, breaks = bins, col = 'darkgray', border = 'white')
  # })
  output$world_wide_map <- renderLeaflet({
    #basemap
    Map <- leaflet(world_country) %>% addTiles() %>% addPolygons()
  })
}