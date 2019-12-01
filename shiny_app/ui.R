library(shiny)
library(plotly)
library(leaflet)
library(shinythemes)

main_page <- tabPanel(
  "Main",              # label for the tab in the navbar
  h2("Project Authors"),
  p("Wei Fan, Ruhan Hou", br(), br()),
  
  h2("Project Description"),
  p("We decided to make a map together. After talking to Professor Hoffmann, we narrowed down the topic to gender distribution in 
    technology companies. This topic is both our interest and could reflect the course central concept. We searched online but 
    few companies have posted gender distribution of their staff. After long-time search, we found a dataset of major companies 
    in Silicon Valley. We ended up using data of 19 companies, because we were unable to find some companies’ latitude and longitude 
    information. Then, we used R Shiny to create an interactive app of the feminism map. The result tends out not far from what 
    we have expected. Only one of the nineteen companies, 23andMe, hire more females than males, and the difference is minimal: 
    there are only two more female workers than male workers, whereas in other companies as least hundreds more male are hired. 
    The map also shows that the difference in number of males and females is bigger in large-scale companies."),
  p("This map shows that much fewer females than males work in Silicon Valley, which is an evidence that females take a tiny share
    of tech field. This finding corresponds with what we have learned in this class. We could infer from this map that the image 
    of only men being capable of working in tech industry still exists. Although the data were from 2016, we do not expect there 
    would be a huge difference in today’s workforce. This map is a tool that connects the class’s concept and the real world. 
    We understand the deficiency of women workers in the tech field but the reasons behind this phenomena require more research.", 
    br(), br()),
  
  h2("Dataset"),
  p("1. The data of number of employee and the gender ditribution utilizes a EEO1 report from 2016. 
    The EEO1 report is collected from Kaggle.", br(),
    "2. Part of the location information of compaies are collected from GitHub.", br(),
    "3. The rest of the location information of companies are collected from GPS Coordinats website.", br(), br())
)

diversity_map <- tabPanel(
  "Map", 
  h1("Map", align = "center"),
  textOutput('map_description'),
  p(),
  leafletOutput("diveristy_map", width = "100%", height = 800),
  p(),
  h1("Bar Plot of number of Female and Male Employee in Companies ", align = "center"),
  plotlyOutput("bar_plot")
)

ui <- fluidPage(
  theme = shinythemes::shinytheme("readable"),
  HTML('<center><img src="logo.jpg" width="300" height="200" alt="Feminism Map"></center>'),
  navbarPage(
    "Pages:", 
    main_page,                 # include the description
    diversity_map              # include women percentage in tech company
  )
)