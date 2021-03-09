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
ui <- fluidPage(class = "p-0 m-0",
    includeCSS("www/dashboard.css"),
    tags$head(
        tags$style("@import url(https://use.fontawesome.com/releases/v5.7.2/css/all.css);")
    ),
    # Application title
    title = "CS424 Project 2",
        tags$nav(class = "head shadow p-0 m-0 pl-0",
            tags$ul(class = "title p-0 mr-auto mt-0 mb-0",
                tags$li(
                    tags$p("CS424 Project 2")
                )
            ),
            tags$ul(class = "name p-0",
                tags$li(class = "text-lg mt-auto mb-auto", "Yi-Chun Chen"))
            ),
            tags$div(class = "p-0",
                navbarPage("",
                    #energy plants location start
                    tabPanel("Energy Plants in IL 2018", class = "p-0",
                        mainPanel(class = "panel p-0",
                            fluidRow(
                                column(12, class = "p-0",
                                    tags$div(class = "card border-title shadow",
                                        #card Start
                                        tags$div(class = "card-body",
                                            tags$div(class = "title",
                                                tags$span("Energy Plants in IL 2018")
                                            ),
                                            fluidRow(style = "margin: 2px",
                                                column(2, style = "background-color: white",
                                                    tags$div(
                                                        tags$div(class = "subtitle",
                                                            tags$i(class = "fas fa-search"),
                                                                "Data Filter:"
                                                        ),

                                                        #Energy source filter start
                                                        tags$div(class = "filter",
                                                            checkboxGroupInput("energySourceInput", "Energy source: ", choices = c(energySource_dist))
                                                        ) #energy source filter end
                                                    )
                                                ),
                                                column(10,
                                                    tags$div(class = "row",
                                                        column(12,
                                                            tags$div(class = "subtitle",
                                                                tags$i(class = "fas fa-map-marked-alt"),
                                                                    "Map:"
                                                            ),
                                                            tags$div(style = "height: 680px",
                                                                shinycssloaders::withSpinner(
                                                                    leafletOutput("leaf", height = 630),
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                            ) #End of fluid row
                                        ) #End of card body
                                    ) #End of card
                                )
                            )
                        )
                    ), #energy plants location end

                    #Camparison page start
                    tabPanel("Energy Plants Maps Comparison", class = "p-0",
                        mainPanel(class = "panel p-0",
                            #first map start
                            column(6, class = "p-0",
                                tags$div(class = "card border-title shadow",
                                    #card Start
                                    tags$div(class = "card-body",
                                        tags$div(
                                            column(2, class = "p-0",
                                                tags$div(class = "title",
                                                    tags$span("First Map")
                                                )
                                            ),
                                            column(2, class = "p-0",
                                                tags$div(class = "",
                                                    checkboxInput("isSync", label = "sync", value = FALSE)
                                                )
                                            ),
                                            column(4,
                                                tags$div(
                                                    tags$div(class = "filter, cust-text",
                                                        selectizeInput(
                                                            'yearInput_first', 'Select a year: ', choices = year_dist, selected = "2000", multiple = FALSE
                                                        )
                                                    )
                                                )
                                            ),
                                            column(4,
                                                tags$div(
                                                    tags$div(class = "filter, cust-text",
                                                        selectizeInput(
                                                            'stateInput_first', 'Select a state: ', choices = state_dist, selected = "Illinois", multiple = FALSE
                                                        )
                                                    )
                                                )
                                            )
                                        ),
                                        fluidRow(style = "margin: 2px",
                                            column(3,
                                                uiOutput("checkbox_first"),
                                                #Energy source filter start
                                                #tags$div(class = "filter",
                                                #    checkboxGroupInput("energySourceInput_first_adm", "Energy source: ", choices = c("Select All", "Select Renewable", "Select nonRenewable")),
                                                #    checkboxGroupInput("energySourceInput_first", "", choices = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other"))
                                                #), #energy source filter end
                                                #leaflet type start
                                                #tags$div(class = "filter",
                                                #    checkboxGroupInput("mapTypeInput_first", "Map type: ", choices = c(map_dist))
                                                #), #leaflet type end
                                                actionButton("reset_com_first", "Reset view")
                                            ),
                                            column(9,
                                                tags$div(style = "height: 680px",
                                                    shinycssloaders::withSpinner(
                                                        leafletOutput("leaf_com_first", height = 630),
                                                    )
                                                )
                                            )

                                        ) #End of fluid row
                                    ) #End of card
                                )
                            ), #first map end
                            #second map start
                            column(6, class = "p-0",
                                tags$div(class = "card border-title shadow",
                                    #card Start
                                    tags$div(class = "card-body",
                                        tags$div(
                                            column(4, class = "p-0",
                                                tags$div(
                                                    class = "title",
                                                    tags$span("Second Map")
                                                )
                                            ),
                                            column(4,
                                                tags$div(
                                                    tags$div(class = "filter, cust-text",
                                                        selectizeInput(
                                                            'yearInput_second', 'Select a year: ', choices = year_dist, selected = "2018", multiple = FALSE
                                                        )
                                                    )
                                                )
                                            ),
                                            column(4,
                                                tags$div(
                                                    tags$div(class = "filter, cust-text",
                                                        selectizeInput(
                                                            'stateInput_second', 'Select a state: ', choices = state_dist, selected = "Illinois", multiple = FALSE
                                                        )
                                                    )
                                                )
                                            )
                                        ),
                                        fluidRow(style = "margin: 2px",
                                            column(3,
                                                uiOutput("checkbox_second"),
                                                actionButton("reset_com_second", "Reset view")
                                            ),
                                            column(9,
                                                tags$div(style = "height: 680px",
                                                    shinycssloaders::withSpinner(
                                                        leafletOutput("leaf_com_second", height = 630),
                                                    )
                                                )
                                            )
                                        ) #End of fluid row
                                    ) #End of card
                                )
                            ),
                        )
                    ), #Camparison page end

                    #whole us
                    tabPanel("Energy Plants in US", class = "p-0",
                        mainPanel(class = "panel p-0",
                            fluidRow(
                                column(12, class = "p-0",
                                    tags$div(class = "card border-title shadow",
                                    #card Start
                                    tags$div(class = "card-body",
                                        tags$div(
                                            column(3, class = "p-0",
                                                tags$div(
                                                    class = "title",
                                                    tags$span("Energy Plants in US")
                                                )
                                            ),
                                            column(2,
                                                tags$div(
                                                    tags$div(class = "filter cust-text",
                                                        selectizeInput(
                                                            'yearInput_us', 'Select a year: ', choices = year_dist, selected = "2018", multiple = FALSE
                                                        )
                                                    )
                                                )
                                            ),
                                            column(3, 
                                                tags$div(
                                                    uiOutput("slider_left"),
                                                )
                                            ),
                                            column(3, 
                                                tags$div(
                                                    uiOutput("slider_right"),
                                                )
                                            ),
                                            column(1, 
                                                tags$div(class = "",
                                                    checkboxInput("isInverse", label = "inverse", value = FALSE)
                                                )
                                            )
                                        ),
                                        fluidRow(style = "margin: 2px",
                                            column(2,
                                                tags$div(
                                                    tags$div(class = "subtitle",
                                                        tags$i(class = "fas fa-search"),
                                                            "Data Filter:"
                                                    ),
                                                    #Energy source filter start
                                                    tags$div(class = "filter",
                                                        checkboxGroupInput("energySourceInput_us", "Energy source: ", choices = c(energySource_dist))
                                                    ), #energy source filter end
                                                    actionButton("reset_us", "Reset view")
                                                )
                                            ),
                                            column(10,
                                                tags$div(class = "subtitle",
                                                    tags$i(class = "fas fa-map-marked-alt"),
                                                        "Map:"
                                                    ),
                                                    tags$div(style = "height: 680px",
                                                        shinycssloaders::withSpinner(
                                                            leafletOutput("leaf_us", height = 630),
                                                        )
                                                    )
                                                )
                                            ) #End of fluid row
                                        ) #End of card
                                    )
                                )
                            )
                        )
                    ), #whole us

#About page start
                                     tabPanel("About", class = "p-0",
                                              mainPanel(class = "panel p-0",
                                                         fluidRow(

#Total Amount of Energy generation start
                                                           column(12, class = "p-0",
                                                                  tags$div(class = "card border-title shadow",
#card Start
                                                                           tags$div(class = "card-body",

                                                                                    tags$div(class = "title",
                                                                                             tags$span(
                                                                                               "About")
                                                                                    ),
                                                                                    tags$div(class = "p-5",
                                                                                             tags$div(
                                                                                               tags$span(class = "cust-text-md", "Author: "),
                                                                                               tags$span("Yi-Chun Chen")
                                                                                             ),
                                                                                             tags$div(
                                                                                               tags$span(class = "cust-text-md", "Date: "),
                                                                                               tags$span("02.13.2020")
                                                                                             ),
                                                                                             tags$div(
                                                                                               tags$span(class = "cust-text-md", "Data Source: "),
                                                                                               tags$a(href = "https://www.evl.uic.edu/aej/424/annual_generation_state.csv", "https://www.evl.uic.edu/aej/424/annual_generation_state.csv"),
                                                                                             ),
                                                                                             tags$div(
                                                                                               tags$span(class = "cust-text-md", "Git Repository: "),
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





