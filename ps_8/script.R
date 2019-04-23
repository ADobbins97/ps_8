
library(shiny)
library(tidyverse)
library(janitor)
library(sf)
library(tidycensus)
library(leaflet)
library(mapview)
library(tigris)
library(lubridate)

census_api_key("a04411e6531c865e7b27d166476949e65577d6cd", install = TRUE)


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
  filter(first_unit_there != "NULL", last_unit_to_leave_the_scene != "NULL", latitude != "NA", longitude != "NA")

wilmington_points <-
  wilmington %>% 
  select(primeunit, latitude, longitude) %>%
  filter(!is.na(latitude), !is.na(longitude)) %>%
  filter(primeunit %in% c("323", "291", "328", "347", "325")) %>%
  group_by(primeunit, latitude, longitude) %>%
  summarise(gunshots = n())

points_location <-
  st_as_sf(wilmington_points,
           coords = c("longitude", "latitude"),
           crs = 4269)
shapes <- 
  urban_areas(class = "sf") 

shapes <-
  shapes %>%
  clean_names() %>%
  filter(name10 == "Wilmington, NC")

st_crs(shapes)

blank_sf <- 
  st_as_sf(wilmington,
         coords = c("longitude", "latitude"),
         crs = 4269) 

wilmington_map <- 
  ggplot(data = shapes) +
  geom_sf() + geom_sf(data = points_location, mapping = aes(color = primeunit))


wilmington_map

