library(shiny)
library(leaflet)
library(widgetframe)

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

my_server <- function(input, output, session) {
  
  # Output a map with labels of company name and number of employee of different gender
  output$diveristy_map <- renderLeaflet({
    leaflet(cleaned_data) %>%
      addTiles() %>%
      # addProviderTiles(providers$OpenStreetMap) %>% 
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
  })
  
}