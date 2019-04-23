
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

shapes <- 
  urban_areas(class = "sf") 

shapes <-
  shapes %>%
  clean_names() %>%
  filter(name10 == "Wilmington, NC")

st_crs(shapes)

penis <- 
  st_as_sf(wilmington,
         coords = c("longitude", "latitude"),
         crs = 4269) 

wilmington_map <- 
  ggplot(data = shapes) +
  geom_sf(data = shapes) + geom_sf(data = wilmington_scatter)

wilmington_map


wilmington_points <-
  wilmington %>% 
  select(first_unit_there, last_unit_to_leave_the_scene, latitude, longitude) %>% 
  filter(first_unit_there != "NULL", last_unit_to_leave_the_scene != "NULL", latitude != "NA", longitude != "NA") %>% 
  #strsplit(format(first_unit_there, "%d %m %Y %H:%M"), ' ') 
  mutate(first_unit_there = parse_date_time(first_unit_there, "%d %%m %Y %H:%M %S", truncated = 3)) %>%
  #mutate(first_unit_there = dmy_hm(first_unit_there)) %>% 
  #mutate(last_unit_to_leave_the_scene = mdy_hm(last_unit_to_leave_the_scene)) 
  mutate(last_unit_to_leave_the_scene = parse_date_time(last_unit_to_leave_the_scene, "%d %%m %Y %H:%M %S", truncated = 3))

wilmington_scatter <-
  wilmington %>%
  group_by(primeunit) %>%
  summarize(total = n()) %>%
  arrange(desc(total)) %>%
  slice(1:5) %>%
  select(primeunit)
#Comparison of duration of time at scene for 

