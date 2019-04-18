
library(shiny)
library(tidyverse)
library(janitor)
library(lubridate)
library(readxl)

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
  Longitude = col_double())) %>% 
  clean_names() 

wilmington <-
  wilmington %>% 
  select(first_unit_there, last_unit_to_leave_the_scene, latitude, longitude) %>% 
  filter(first_unit_there != "NULL", last_unit_to_leave_the_scene != "NULL", latitude != "NA", longitude != "NA") %>% 
  #strsplit(format(first_unit_there, "%d %m %Y %H:%M"), ' ') 
  mutate(first_unit_there = mdy_hm(first_unit_there)) %>% 
  mutate(last_unit_to_leave_the_scene = mdy_hm(last_unit_to_leave_the_scene)) 

#Comparison of duration of time at scene for 

