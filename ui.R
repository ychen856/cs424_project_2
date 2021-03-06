library(shiny)
library(leaflet)
library(shinyWidgets)
source("global.R")



#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyWidgets)
source("global.R")

# Define UI for application that draws a histogram
ui <- fluidPage(class="p-0 m-0",
                includeCSS("www/dashboard.css"),
                tags$head(
                  tags$style("@import url(https://use.fontawesome.com/releases/v5.7.2/css/all.css);")  
                ),
                # Application title
                title = "CS424 Project 2",
                tags$nav(class="head shadow p-0 m-0 pl-0",
                         tags$ul(class="title p-0 mr-auto mt-0 mb-0", 
                                 tags$li(
                                   tags$p("CS424 Project 2")
                                 )),
                         tags$ul(class="name p-0", 
                                 tags$li(class="text-lg mt-auto mb-auto", "Yi-Chun Chen"))
                ),
                tags$div( class="p-0",
                          #tags$i(class="fab fa-accessible-icon card"),
                          navbarPage("", 
                                     #Total Amount page start
                                     tabPanel("Location of Energy Plants", class="p-0",
                                              mainPanel( class="panel p-0",
                                                         fluidRow(
                                                           column(12, class="p-0",
                                                                  tags$div(class="card border-title shadow",
                                                                           #card Start
                                                                           tags$div(class="card-body",
                                                                                    
                                                                                    tags$div(class="title",
                                                                                             tags$span(
                                                                                               "Energy Plants in IL 2018")
                                                                                    ),
                                                                                    
                                                                                    fluidRow(style="margin: 2px",
                                                                                             column(2, style="background-color: white",
                                                                                                    tags$div(
                                                                                                      tags$div(class="subtitle",
                                                                                                               tags$i(class="fas fa-search"),
                                                                                                               "Data Filter:"
                                                                                                      ),
                                                                                                      
                                                                                                      
                                                                                                      #Energy source filter start
                                                                                                      tags$div(class="filter",
                                                                                                               checkboxGroupInput("energySourceInput", "Energy source: ", choices = c(energySource_dist))
                                                                                                      ) #energy source filter end
                                                                                                    )
                                                                                             ), 
                                                                                             column(10, 
                                                                                                    tags$div(class="row",
                                                                                                             column(12, 
                                                                                                                    tags$div(class="subtitle",
                                                                                                                             tags$i(class="fas fa-map-marked-alt"),
                                                                                                                             "Map:"
                                                                                                                    ),
                                                                                                                    tags$div(style="height: 680px", 
                                                                                                                             shinycssloaders::withSpinner(
                                                                                                                               leafletOutput("leaf", height = 630),
                                                                                                                             ) 
                                                                                                                    )
                                                                                                             )
                                                                                                    )
                                                                                             )
                                                                                             
                                                                                    )#End of fluid row
                                                                           )#End of card
                                                                  ), #Total Amount of Energy Generation end
                                                           )
                                                      )
                                              )
                                     ), #Total Amount page end
                                     
                                     #Camparison page start
                                     tabPanel("Comparison - Amount", class="p-0",
                                              mainPanel( class="panel p-0",
                                                         column(6, class="p-0",
                                                                tags$div(class="card border-title shadow",
                                                                         #card Start
                                                                         tags$div(class="card-body",
                                                                                  
                                                                                  tags$div(class="title",
                                                                                           tags$span(
                                                                                             "First Region")
                                                                                  ),
                                                                                  
                                                                                  fluidRow(style="margin: 2px",
                                                                                           
                                                                                           #TODO
                                                                                           
                                                                                  )#End of fluid row
                                                                         )#End of card
                                                                )
                                                                
                                                        ),
                                                        column(6, class="p-0",
                                                               tags$div(class="card border-title shadow",
                                                                        #card Start
                                                                        tags$div(class="card-body",
                                                                                 
                                                                                 tags$div(class="title",
                                                                                          tags$span(
                                                                                            "First Region")
                                                                                 ),
                                                                                 
                                                                                 fluidRow(style="margin: 2px",
                                                                                          
                                                                                          #TODO
                                                                                          
                                                                                 )#End of fluid row
                                                                        )#End of card
                                                               )
                                                               
                                                        ),
                                              )
                                              
                                     ), #Camparison page start

                                     
                                     
                                     #idle & new
                                     tabPanel("5 Interesting Things", class="p-0",
                                              mainPanel( class="panel p-0",
                                                         fluidRow(
                                                           tags$div(class="card border-title shadow",
                                                                    #card Start
                                                                    tags$div(class="card-body",
                                                                             
                                                                             tags$div(class="title",
                                                                                      tags$span(
                                                                                        "Energy Plants in IL 2018")
                                                                             ),
                                                                             
                                                                             fluidRow(style="margin: 2px",
                                                                                      column(2, style="background-color: white",
                                                                                             tags$div(
                                                                                               tags$div(class="subtitle",
                                                                                                        tags$i(class="fas fa-search"),
                                                                                                        "Data Filter:"
                                                                                               ),
                                                                                               
                                                                                               
                                                                                               #Energy source filter start
                                                                                               tags$div(class="filter",
                                                                                                        #checkboxGroupInput("energySourceInput", "Energy source: ", choices = c("Select All", energySource_dist))
                                                                                               ) #energy source filter end
                                                                                             )
                                                                                      ), 
                                                                                      column(10, 
                                                                                             tags$div(class="row",
                                                                                                      column(12, 
                                                                                                             tags$div(class="subtitle",
                                                                                                                      tags$i(class="fas fa-chart-line"),
                                                                                                                      "Line Chart:"
                                                                                                             ),
                                                                                                             tags$div(style="height: 390px", 
                                                                                                                      #shinycssloaders::withSpinner(
                                                                                                                        #leafletOutput("leaf", height = 700),
                                                                                                                      #) 
                                                                                                             )
                                                                                                      )
                                                                                             )
                                                                                      )
                                                                                      
                                                                             )#End of fluid row
                                                                    )#End of card
                                                           ), #Total Amount of Energy Generation end
                                                         )
                                                         
                                              )

                                     ), #idle & new page end
                                     
                                     #About page start
                                     tabPanel("About", class="p-0",
                                              mainPanel( class="panel p-0",
                                                         fluidRow(
                                                           
                                                           #Total Amount of Energy generation start
                                                           column(12, class="p-0",
                                                                  tags$div(class="card border-title shadow",
                                                                           #card Start
                                                                           tags$div(class="card-body",
                                                                                    
                                                                                    tags$div(class="title",
                                                                                             tags$span(
                                                                                               "About")
                                                                                    ),
                                                                                    tags$div(class="p-5",
                                                                                             tags$div(
                                                                                               tags$span(class="cust-text-md", "Author: "),
                                                                                               tags$span("Yi-Chun Chen")
                                                                                             ),
                                                                                             tags$div(
                                                                                               tags$span(class="cust-text-md", "Date: "),
                                                                                               tags$span("02.13.2020")
                                                                                             ),
                                                                                             tags$div(
                                                                                               tags$span(class="cust-text-md", "Data Source: "),
                                                                                               tags$a(href = "https://www.evl.uic.edu/aej/424/annual_generation_state.csv", "https://www.evl.uic.edu/aej/424/annual_generation_state.csv"),
                                                                                             ),
                                                                                             tags$div(
                                                                                               tags$span(class="cust-text-md", "Git Repository: "),
                                                                                               tags$a(href = "https://github.com/ychen856/cs424_project_1.git", "https://github.com/ychen856/cs424_project_1.git")
                                                                                             )
                                                                                    ),
                                                                                    
                                                                           )
                                                                  )
                                                           )
                                                         )
                                              )
                                              
                                     ) #About page end
                          )
                )
)




                        
 