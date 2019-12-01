library(shiny)
library(plotly)
library(leaflet)
library(leaflet.minicharts)

# Get tech company location dataset and EEO1 dataset 2016
location <- read.csv("../dataset/Tech_company_location.csv", stringsAsFactors = FALSE, header = TRUE)
diversity_data <- read.csv("../dataset/Reveal_EEO1_for_2016.csv", stringsAsFactors = FALSE, header = TRUE)

# Since there are a lot of na in column count with job_category of "Previous_totals", 
# we deicide remove all rows of job_category of "Previous_totals" (30 rows removed)
trimed_data <- diversity_data[diversity_data$job_category != "Previous_totals", ]

# Data organize and cleaning:
cleaned_data <- location
cleaned_data$male_count <- 0
cleaned_data$female_count <- 0
cleaned_data$overall_total <- 0

# Loop though each company get the female and male worker counts in each company
for (row_number in 1:nrow(cleaned_data)) {
  company_name <- cleaned_data[row_number, 1]
  filtered_by_company <- trimed_data[trimed_data$company == company_name, ]
  male_data <- filtered_by_company[filtered_by_company$gender == "male", ]
  female_data <- filtered_by_company[filtered_by_company$gender == "female", ]
  overall_total <- filtered_by_company[filtered_by_company$race == "Overall_totals", ]
  cleaned_data[row_number, 4] <- sum(as.numeric(male_data$count))
  cleaned_data[row_number, 5] <- sum(as.numeric(female_data$count))
  cleaned_data[row_number, 6] <- sum(as.numeric(overall_total$count))
}

# Since Intel and Cisco's location is too far away from other company,
# remove Intel from dataset
cleaned_data <- cleaned_data[cleaned_data$Company != "Intel", ]
cleaned_data <- cleaned_data[cleaned_data$Company != "Cisco", ]

# write the cleaned dataset
# write.csv(cleaned_data, file = "cleaned_data.csv",row.names=FALSE)

### Prepare for Minigraphs on map
# colors: orange, blue
colors <- c("#F8C471", "#85C1E9")

# change value to numeric
cleaned_data$female_count <- as.numeric(cleaned_data$female_count)
cleaned_data$male_count <- as.numeric(cleaned_data$male_count)
cleaned_data$overall_total <- as.numeric(cleaned_data$overall_total)

# Remove category data for mini pie charts
partial_data <- cleaned_data[, -c(1)]

### Prepare for bar plots
# Order data by longitude
sorted_data <- cleaned_data[order(cleaned_data$Longitude), ]
sorted_data$Company <- factor(sorted_data$Company, levels = sorted_data[["Company"]])

my_server <- function(input, output, session) {
  
  # Output text of map description
  output$map_description <- renderText({
    paste("The map blow utilizes data from ", nrow(cleaned_data), " Silicon Valley, and the location of these companies 
          are marked in the Bay Area. Move mouth on top of each marker to see the company name, number of female employee, 
          number of male employee, and number of total emplyee. ")
  })
  
  # Output a map with labels of company name and number of employee of different gender
  output$diveristy_map <- renderLeaflet({
    map <- leaflet(cleaned_data) %>%
           addTiles() %>%
           fitBounds(~(min(cleaned_data$Longitude) - 1), ~(min(cleaned_data$Latitude) - 1), 
                     ~(max(cleaned_data$Longitude) + 1), ~(max(cleaned_data$Latitude) + 1)) %>%
           addMarkers(data = cleaned_data[, c(2,3)],
                     label = paste('<p>', "Company: ", '<strong>', cleaned_data$Company, '</strong></p><p>',
                                   "Female Employee Number: ", cleaned_data$female_count, '</p><p>',
                                   "Male Employee Number: ", cleaned_data$male_count, '</p><p>',
                                   "Total Employee Number: ", cleaned_data$overall_total, '</p>') %>%
                       lapply(htmltools::HTML),
                     labelOptions = labelOptions(noHide = F, textsize = "15px", direction = "left")) %>%
           setView(lng = -122.3, lat = 37.6, zoom = 10)
    
    # Add mini bar plot to map
    map %>% addMinicharts(
      partial_data$Longitude, cleaned_data$Latitude,
      type = "pie",
      chartdata = partial_data[, c("female_count", "male_count")],
      colorPalette = colors,
      width = 100 * sqrt(partial_data$overall_total) / sqrt(max(partial_data$overall_total)), transitionTime = 0
    )
  })
  
  # Output a bar chart with number of employees in different gender
  output$bar_plot <- renderPlotly({
    bar_graph <- plot_ly(sorted_data, x = sorted_data$Company, y = sorted_data$female_count, type = 'bar', 
                         name = 'Number of Female Employee', marker = list(color = 'rgb(248, 196, 113)')) %>% 
      add_trace(y = sorted_data$male_count, name = 'Number of Male Employee', marker = list(color = 'rgb(133, 193, 233 )')) %>% 
      layout(title = 'Gender Distribution',
             xaxis = list(title = "Company name"),
             yaxis = list(title = "Number of Employee"),
             margin = list(b = 100),
             legend = list(x = 0, y = 1),
             barmode = 'group') 
  })
  
}