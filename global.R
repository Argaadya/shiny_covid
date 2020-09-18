library(shiny)
library(shinydashboard)
library(dashboardthemes)

# data wrangling
library(dplyr)
library(tidyr)
library(lubridate)

# visualization
library(ggplot2)
library(plotly)
library(scales)
library(glue)
library(leaflet)

# Import Data from John Hopkins University

case_confirmed <- read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv", 
                           check.names = F)

case_recover <- read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv",
                         check.names = F)

case_death <- read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv",
                       check.names = F)

# Data Cleansing
## Active Cases

case_confirmed <- case_confirmed %>% 
  pivot_longer(-c(`Province/State`, `Country/Region`, Lat, Long), 
               names_to = "Date", values_to = "Case") %>% 
  mutate(
    Date = mdy(Date)
  )

## Recovery
case_recover <- case_recover %>% 
  pivot_longer(-c(`Province/State`, `Country/Region`, Lat, Long), 
               names_to = "Date", values_to = "Recover") %>% 
  mutate(
    Date = mdy(Date)
  )

## Death
case_death <- case_death %>% 
  pivot_longer(-c(`Province/State`, `Country/Region`, Lat, Long), 
               names_to = "Date", values_to = "Death") %>% 
  mutate(
    Date = mdy(Date)
  )

## Merge/Join data.frame
covid <- case_confirmed %>% 
  left_join(case_recover) %>% 
  left_join(case_death) %>% 
  mutate(
    cfr = Death/Case
  ) %>% 
  rename(State = `Province/State`,
         Country = `Country/Region`
         ) %>% 
  filter(!(Country %in% c("Diamond Princess", "MS Zaandam")))

# Data from the latest date only

covid_update <- covid %>% 
  filter(Date == max(Date)) 

# Theme for Visualization

theme_algo <- theme(
  panel.background = element_rect(fill = "white"),
  panel.grid.major = element_line(colour = "gray80"),
  panel.grid.minor = element_blank(),
  plot.title = element_text(family = "serif", size = 18)
)

