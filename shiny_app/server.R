library(shiny)
library(leaflet)
library(geojsonio)

# data of countries that same sex marriage is legal
original_data <- read.csv("../dataset/countries_ss.csv", header = TRUE, stringsAsFactors = FALSE)

# Sort by law passed date
data <- original_data[order(original_data$legalizeYear), ]

# world map
world_country <- geojsonio::geojson_read("../dataset/custom.geo.json", what = "sp")

# make the dataset with 3 column: country name, law passed or not, 
vector_country_name <- world_country$sovereignt
organized <- data.frame(vector_country_name, 0)
organized$year <- 0
colnames(organized) <- c("country", "passed", "year")
organized$country <- as.character(organized$country)

# Not contained in map: Greenland, Bermuda
# United States of America -> name need correct
for (i in 1:nrow(organized)) {
  for (j in 1:nrow(data)) {
    if (data[j, 1] == organized[i, 1]) {
      organized[i, 2] <- data[j, 2] - 2000
      organized[i, 3] <- data[j, 2]
    }
  } 
}

# Add US
organized[1, 2] <- 1
organized[1, 3] <- 2015

# color
bins <- c(1:17, Inf)
pal <- colorBin("YlOrRd", domain = organized$passed, bins = bins)

# label
labels <- sprintf(
  "<strong>%s</strong><br/> Year Passed: %s",
  organized$country, organized$year
) %>% lapply(htmltools::HTML)

# Define server logic required to draw a histogram
my_server <- function(input, output) {
  
  output$world_wide_map <- renderLeaflet({
    Map <- leaflet(world_country) %>% addTiles() %>% addPolygons(fillColor = ~pal(organized$passed),
                                                                 weight = 2,
                                                                 opacity = 1,
                                                                 color = "white",
                                                                 dashArray = "3",
                                                                 fillOpacity = 0.7,
                                                                 
                                                                 # mouth rover effect
                                                                 highlight = highlightOptions(
                                                                   weight = 5,
                                                                   color = "#666",
                                                                   dashArray = "",
                                                                   fillOpacity = 0.7,
                                                                   bringToFront = TRUE),
                                                                 
                                                                 # labels when mouth rover
                                                                 label = labels,
                                                                 labelOptions = labelOptions(
                                                                   style = list("font-weight" = "normal", 
                                                                                padding = "3px 8px"),
                                                                   textsize = "15px",
                                                                   direction = "auto")) %>% 
      addLegend(pal = pal, values = organized$year, opacity = 0.7, 
                title = "Year after 2000", position = "topright")
  })
}