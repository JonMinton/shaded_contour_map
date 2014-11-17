
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

# Packages go here

library(shiny)
library(ggplot2)
library(lattice)
library(plyr)

new_dataset <- read.csv(
#  "https://raw.githubusercontent.com/JonMinton/Population_Age_Residuals/master/Data/Tidy/counts.csv"
  "data/counts.csv"
  )
new_dataset <- mutate(new_dataset, death_rate = death_count/population_count)

countries <- unique(as.character(new_dataset$country))
min_year <- min(new_dataset$year)
max_year <- max(new_dataset$year)

dataset <- diamonds

shinyUI(pageWithSidebar(
  
  headerPanel("Shaded Contour Map Explorer"),
  
  sidebarPanel(
    
    sliderInput('age_range', 'Age Range', min=0, max=100,
                value=c(0, 80), step=1, round=0),
    sliderInput('year_range', 'Year Range', min=min_year, max=max_year,
                value=c(min_year, max_year), step=1, round=0),
    
    selectInput("this_country", "Country", countries),

    checkboxInput('greyscale', 'Grey?', value=FALSE),
  
    checkboxInput('log_it', 'Log?', value=FALSE),
    
    selectInput('sex_choice', 'Sex', c("total", "male", "female"), selected="total")
    
  ),
  
  mainPanel(
    plotOutput('plot')
  )
))
