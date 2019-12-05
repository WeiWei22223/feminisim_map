library(shiny)
library(plotly)
library(leaflet)
library(shinythemes)

main_page <- tabPanel(
  "Main",              # label for the tab in the navbar
  h2("Project Authors"),
  p("Wei Fan, Ruhan Hou", br(), br()),
  
  h2("Project Description"),
  p("After talking to Dr.Hoffmann, we narrowed down our topic to gender distribution in technology companies. Our topic reflects 
    both our personal interests as well as it corresponds with course concept. We did an online search about gender distribution 
    in tech companies, but few companies have posted about the gender distribution of their staff. However, we ended up finding a 
    dataset of major companies within the Silicon Valley area in 2016. The dataset was based on each company's EEO-1 report. Thus, 
    we believe the data we used is reliable. We ended up using data of 19 companies, because we were unable to find some companies’ 
    latitude and longitude information. Then, we used R Shiny to create an interactive app of the feminism map. The result was 
    similar to what we expected to find. Only one of the nineteen companies, 23andMe, hired more women than men, and the difference 
    was minimal: there were only two more women than men, whereas in other companies there were at least hundreds more men hired. 
    In Nvidia, there were only 1838 women among 10696 workers. The map also shows that the difference in number of men and women is 
    bigger in large-scale companies. In large companies like Apple and Google, women made up less than one third of the employee."),
  p("This map further illustrates that much fewer women than men work in Silicon Valley. This finding corresponds with what we have 
    learned in this class thus far. We can infer from this map that it can depict an image of only men being capable of working in 
    the tech industry. Although the data was from 2016, we do not expect there would be a huge difference in today’s workforce. 
    This map is a tool that connects the class’s concepts and the real world. We understand that there is a deficiency of women in 
    the tech field but the reasons behind this phenomenon require more research.", 
    br(), br()),
  
  h2("Dataset"),
  p("1. The data of number of employee and the gender ditribution utilizes a EEO1 report from 2016. 
    The EEO1 report is collected from Kaggle.", br(),
    "Link: https://www.kaggle.com/rtatman/silicon-valley-diversity-data/version/1", br(),
    "2. Part of the location information of compaies are collected from GitHub.", br(),
    "Link: https://github.com/connor11528/tech-companies-bay-area", br(),
    "3. The rest of the location information of companies are collected from GPS Coordinats website.", br(),
    "Link: https://www.gps-coordinates.net/", br(), br())
)

diversity_map <- tabPanel(
  "Map", 
  h1("Map", align = "center"),
  textOutput('map_description'),
  p(),
  leafletOutput("diveristy_map", width = "100%", height = 800),
  p(),
  h1("Bar Plot of number of Women and Men in Companies ", align = "center"),
  plotlyOutput("bar_plot")
)

my_ui <- fluidPage(
  theme = shinythemes::shinytheme("readable"),
  HTML('<center><img src="logo.jpg" width="300" height="200" alt="Feminism Map"></center>'),
  navbarPage(
    "Feminism_Map", 
    main_page,                 # include the description
    diversity_map              # include women percentage in tech company
  )
)