#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(janitor)
library(sf)
library(tidycensus)
library(leaflet)
library(mapview)
library(tigris)
library(lubridate)


wilmington <- read_csv("http://justicetechlab.org/wp-content/uploads/2018/05/Wilmington_ShotspotterCAD_calls.csv", 
                       col_types = cols(
                         calltime = col_character(),
                         street = col_character(),
                         crossroad1 = col_character(),
                         crossroad2 = col_character(),
                         geox = col_double(),
                         geoy = col_double(),
                         nature = col_character(),
                         `FIRST UNIT DISPATCHED` = col_character(),
                         `first Dispatch Time` = col_character(),
                         `first unit on the way` = col_character(),
                         `first unit there` = col_character(),
                         `last unit to leave the scene` = col_character(),
                         primeunit = col_character(),
                         reptaken = col_double(),
                         closecode = col_character(),
                         notes = col_character(),
                         timeclose = col_character(),
                         Latitude = col_double(),
                         Longitude = col_double())) 

wilmington <- clean_names(wilmington) %>%
  filter(primeunit %in% c("323", "291", "328", "347", "325")) %>%
  filter(latitude != "NA", longitude != "NA")

shapes <- 
  urban_areas(class = "sf") 

shapes <-
  shapes %>%
  clean_names() %>%
  filter(name10 == "Wilmington, NC")

blank_sf <- 
  st_as_sf(wilmington,
           coords = c("longitude", "latitude"),
           crs = 4269) 

wilmington_map <- 
  ggplot(data = shapes) +
  geom_sf(data = shapes) + geom_sf(data = wilmington)

wilmington_map

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Old Faithful Geyser Data"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         selectInput(inputId = x,
                     label = ,
                     choices = ,
                     selected = 
           
         )
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("wilmingtonPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
   
   output$wilmingtonPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      x    <- faithful[, 2] 
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      
      # draw the histogram with the specified number of bins
      print(ggplot(wilmington_map))
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

