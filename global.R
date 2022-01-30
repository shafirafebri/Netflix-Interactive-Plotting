library(shinydashboard)
library(shiny)
library(tidyverse)
library(glue)
library(plotly)
library(lubridate)
library(gghighlight)
library(DT)
library(shinyWidgets)

# Load Data
netflix <- read.csv("netflix_titles.csv")

calc_mode <- function(x){
  
  # List the distinct / unique values
  distinct_values <- unique(x)
  
  # Count the occurrence of each distinct value
  distinct_tabulate <- tabulate(match(x, distinct_values))
  
  # Return the value with the highest occurrence
  distinct_values[which.max(distinct_tabulate)]
}

#load data
netflix <- read.csv("netflix_titles.csv")

# cleaning data
netflix_clean <- netflix %>% 
  mutate(show_id = as.factor(show_id),
         type = as.factor(type),
         rating = as.factor(rating),
         date_added= mdy(date_added),
         duration = as.factor(duration),
         release_year = as.factor(release_year),
         year_added = year(date_added),
         month_added = month(date_added, label = TRUE, abbr = FALSE))

#handling missing value
netflix_clean[netflix_clean == ""] <- NA

netflix_clean <- netflix_clean %>%
  mutate(country = if_else(is.na(country), 
                           calc_mode(country), 
                           country)) %>% 
  drop_na(rating, duration, date_added) %>%
  mutate(director = replace_na(director, "No Data"),
         cast = replace_na(cast, "No Data"))

netflix_clean <- netflix_clean %>%
  mutate(first_country = gsub(",.*", "", netflix_clean$country))

netflix_type <- netflix_clean %>%
  select(title,type) %>% 
  group_by(type) %>% 
  summarise(n_type = n()) 

mycolors <- c("#E50914", "#141414")

