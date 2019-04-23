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

officer <- 
  wilmington %>% 
  filter(longitude != "NA", latitude != "NA") %>% 
  filter(primeunit %in% c("323", "291", "328", "347", "325")) %>% 
  group_by(primeunit)

ui <- fluidPage(
  titlePanel("NY Apartment Hunt"),
  br(),
  sidebarLayout(
    sidebarPanel(
      h1("Choose a Unit to Display"),
      selectInput("Unit to Show", choices = c("323", "291", "328", "347", "325",
                                              selected = c("323", "291", "328", "347", "325",
                                                           options = list(`actions-box` = TRUE),
                                                           multiple = TRUE))
    ),
    mainPanel(plotOutput("Wilmigton"), 
              br(), br(),
              tableOutput("results"))
  )
)

server <-
  fucntion(input, output) {
    filtered <- reactive({
      officer %>% 
        filter(primeunit %in% c("323", "291", "328", "347", "325")
                                )
    })
    
    output$Wilmington <-renderPlot({
      ggplot(filtered(), aes(primeunit))+
        geom_sf()
    })
    
    output$results <- renderTable({
      filtered()
    })
  }

shinyApp(ui = ui, server = server)

