
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#
# packages go here

library(shiny)
library(ggplot2)
library(lattice)
library(plyr)


new_dataset <- read.csv(
#    "https://raw.githubusercontent.com/JonMinton/Population_Age_Residuals/master/Data/Tidy/counts.csv"
  "data/counts.csv"
)


shinyServer(function(input, output) {
  
#   dataset <- reactive(function() {
#     diamonds[sample(nrow(diamonds), input$sampleSize),]
#   })
  dataset <- reactive(function() {
    age_min <- input$age_range[1]
    age_max <- input$age_range[2]
    this_sex <- input$sex_choice
    out <- subset(new_dataset, subset=(
      country==input$this_country & 
        age >= age_min & 
        age <= age_max & 
        sex == this_sex
      )
    )
    min_year <- max(input$year_range[1], min(out$year))
    max_year <- min(input$year_range[2], max(out$year))
    out <- subset(out, subset = year >= min_year & year <=max_year)
    out <- mutate(out, death_rate = death_count/population_count)    
    out
  })
  this_shading <- reactive(function() {
    output <- ifelse(input$greyscale,
           rev(gray(0:199/199)),
           rev(heat.colors(200)))
    output
  })
  
  output$plot <- renderPlot(function() {
    
    if(input$greyscale){
      shading_option <- rev(gray(0:199/199))
    } else {
      shading_option <- rev(heat.colors(200))
    }
    
    this_data <- dataset()
    if (input$log_it){
      p <- contourplot(
        log(death_rate) ~ year * age,
        data=this_data,
        region=T, 
        col.regions=shading_option, 
        cuts=50
      )    
    } else {
      p <- contourplot(
        death_rate ~ year * age,
        data=this_data,
        region=T, 
        col.regions=shading_option, 
        cuts=50
      )    
      
    }
    print(p)
  }, height=1000, width=1000)
#   output$download_image <- downloadHandler(
#     filename = function() { 
#       "this_plot.png"
#     },
#     content = function(file) {
#       png(file, width=1000, height=1000)
#       print(p)
#       dev.off()
#     },
#     contentType="image/png"
#   )
})