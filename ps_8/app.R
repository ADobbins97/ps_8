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
library(lubridate)
library(readxl)

wilmington <- read_csv("ps_8/Wilmington_ShotspotterCAD_calls.csv") %>% 
  clean_names() 

wilmington <-
  wilmington %>% 
  select(first_unit_there, last_unit_to_leave_the_scene, latitude, longitude) %>% 
  filter(first_unit_there != "NULL", last_unit_to_leave_the_scene != "NULL", latitude != "NA", longitude != "NA") %>% 
  #strsplit(format(first_unit_there, "%d %m %Y %H:%M"), ' ') 
  mutate(first_unit_there = mdy_hm(first_unit_there)) %>% 
  mutate(last_unit_to_leave_the_scene = mdy_hm(last_unit_to_leave_the_scene)) 

#Comparison of duration of time at scene for 

