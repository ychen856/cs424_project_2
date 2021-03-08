library(shiny)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(fontawesome)
library(stringr)
library(ggplot2)
library(tidyverse)
library(fiftystater)
library(scales)
library(usmap)
library(DT)
library(shinycssloaders)
source("global.R")
source("utility.R")


# Define server logic required to draw a histogram
function(input, output, session) {

  ################ page 1 ###################
  #Data Filter
  #energy source input check box
  observe({
    if("Select All" %in% input$energySourceInput)  {
      updateCheckboxGroupInput(session,"energySourceInput", selected=c("Select All", energySource_dist))
    }
    else{ 
      if("Select Renewable" %in% input$energySourceInput) {
        updateCheckboxGroupInput(session,"energySourceInput", selected=c(input$energySourceInput, "Select Renewable", "Hydro", "Biomass", "Wind", "Solar", "Geothermal"))
      }
      if("Select nonRenewable" %in% input$energySourceInput) {
        updateCheckboxGroupInput(session,"energySourceInput", selected=c(input$energySourceInput, "Select nonRenewable", "Coal", "Oil", "Gas", "Nuclear", "Other"))
      }
    }
    
    slice_gen_2018_IL <- getMapTable(gen_2018, "IL", input$energySourceInput)

    quakeIcons <- iconList(coal = makeIcon("map-pin-solid-coal.svg", iconWidth = 12, iconHeight =24),
                           oil = makeIcon("map-pin-solid-oil.svg", iconWidth = 12, iconHeight =24),
                           gas = makeIcon("map-pin-solid-gas.svg", iconWidth = 12, iconHeight =24),
                           nuclear = makeIcon("map-pin-solid-nuclear.svg", iconWidth = 12, iconHeight =24),
                           hydro = makeIcon("map-pin-solid-hydro.svg", iconWidth = 12, iconHeight =24),
                           biomass = makeIcon("map-pin-solid-biomass.svg", iconWidth = 12, iconHeight =24),
                           wind = makeIcon("map-pin-solid-wind.svg", iconWidth = 12, iconHeight =24),
                           solar = makeIcon("map-pin-solid-solar.svg", iconWidth = 12, iconHeight =24),
                           geothermal = makeIcon("map-pin-solid-geothermal.svg", iconWidth = 12, iconHeight =24),
                           other = makeIcon("map-pin-solid-other.svg", iconWidth = 12, iconHeight =24)
                           )
    
    gen_2018_IL_map <- leaflet() %>% 
      addProviderTiles(
        providers$CartoDB.Positron, group = "Light"
      ) %>%
      addProviderTiles(
        providers$CartoDB.DarkMatter, group = "Dark"
      ) %>%
      setView(
        lng = -89, 
        lat = 40, 
        zoom = 7
      ) %>%
      addMarkers(data = subset(slice_gen_2018_IL, SOURCE == "Coal"),
                 lat = ~U_PLANT_LAT,
                 lng = ~U_PLANT_LONG, 
                 icon = quakeIcons["coal"]
      )%>%
      addMarkers(data = subset(slice_gen_2018_IL, SOURCE == "Oil"),
                 lat = ~U_PLANT_LAT,
                 lng = ~U_PLANT_LONG,
                 icon = quakeIcons["oil"]
      )%>%
      addMarkers(data = subset(slice_gen_2018_IL, SOURCE == "Gas"),
                 lat = ~U_PLANT_LAT,
                 lng = ~U_PLANT_LONG, 
                 icon = quakeIcons["gas"]
      )%>%
      addMarkers(data = subset(slice_gen_2018_IL, SOURCE == "Nuclear"),
                 lat = ~U_PLANT_LAT,
                 lng = ~U_PLANT_LONG, 
                 icon = quakeIcons["nuclear"],
                 #popup = ~PointUse
      )%>%
      addMarkers(data = subset(slice_gen_2018_IL, SOURCE == "Hydro"),
                 lat = ~U_PLANT_LAT,
                 lng = ~U_PLANT_LONG, 
                 icon = quakeIcons["hydro"],
                 #popup = ~PointUse
      )%>%
      addMarkers(data = subset(slice_gen_2018_IL, SOURCE == "Biomass"),
                 lat = ~U_PLANT_LAT,
                 lng = ~U_PLANT_LONG,
                 icon = quakeIcons["biomass"],
                 #popup = ~PointUse
      )%>%
      addMarkers(data = subset(slice_gen_2018_IL, SOURCE == "Wind"),
                 lat = ~U_PLANT_LAT,
                 lng = ~U_PLANT_LONG,
                 icon = quakeIcons["wind"],
                 #popup = ~PointUse
      )%>%
      addMarkers(data = subset(slice_gen_2018_IL, SOURCE == "Solar"),
                 lat = ~U_PLANT_LAT,
                 lng = ~U_PLANT_LONG, 
                 icon = quakeIcons["solar"],
                 #popup = ~PointUse
      )%>%
      addMarkers(data = subset(slice_gen_2018_IL, SOURCE == "Geothermal"),
                 lat = ~U_PLANT_LAT,
                 lng = ~U_PLANT_LONG,
                 icon = quakeIcons["geothermal"],
                 #popup = ~PointUse
      )%>%
      addMarkers(data = subset(slice_gen_2018_IL, SOURCE == "Other"),
                 lat = ~U_PLANT_LAT,
                 lng = ~U_PLANT_LONG,
                 icon = quakeIcons["other"],
                 #popup = ~PointUse
      )%>%
      addLegend("bottomright", colors= c("#e6194B", "#f58231","#ffe119" ,"#bfef45", "#3cb44b", "#42d4f4", "#4363d8", "#911eb4", "#f032e6", "#a9a9a9"), 
              labels=c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other"), title="Energy Source") %>%
      addLayersControl(
                baseGroups = c("Light", "Dark"),
                options = layersControlOptions(collapsed = FALSE)
      )
    
      output$leaf <- renderLeaflet({
        gen_2018_IL_map
      })
  })


  ################## Page 2 ####################
  #first graph year input
  gen_year_first <- NULL
  observeEvent(input$yearInput_first, {  
    gen_year_first <- getTableByYear(input$yearInput_first)
    slice_gen_com_first <- getMapTable(gen_year_first, state.abb[which(state.name == input$stateInput_first)], input$energySourceInput_first)

  })
  
  #first graph state input
  observeEvent(input$stateInput_first, {  
    gen_year_first <- getTableByYear(input$yearInput_first)
    slice_gen_com_first <- getMapTable(gen_year_first, state.abb[which(state.name == input$stateInput_first)], input$energySourceInput_first)
  })
  
  #if sync
  observeEvent(input$isSync, {
    if(input$isSync) {
      output$checkbox_first <- renderUI({
        #Energy source filter start
        tags$div(class = "filter",
               checkboxGroupInput("energySourceInput_first_adm", "Energy source: ", choices = c("Select All", "Select Renewable", "Select nonRenewable")),
               checkboxGroupInput("energySourceInput_first", "", choices = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other"))
        ) #energy source filter end
      })
      output$checkbox_second <- renderUI({
        #Energy source filter start
        tags$div(class = "filter",
                 checkboxGroupInput("energySourceInput_second_adm", "Energy source: ", choices = c("Select All", "Select Renewable", "Select nonRenewable")),
                 checkboxGroupInput("energySourceInput_second", "", choices = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other"))
        ) #energy source filter end
      })
    }
    else {
      output$checkbox_first <- renderUI({
        #Energy source filter start
        tags$div(class = "filter",
                 checkboxGroupInput("energySourceInput_first_unsync", "Energy source: ", choices = c(energySource_dist))
        ) #energy source filter end
      })
      output$checkbox_second <- renderUI({
        #Energy source filter start
        tags$div(class = "filter",
                 checkboxGroupInput("energySourceInput_second_unsync", "Energy source: ", choices = c(energySource_dist))
        ) #energy source filter end
      })
    }
  })
  
  #first graph energy source input sync
  temp<- NULL
  temp_adm <- NULL
  observe({
    temp <- input$energySourceInput_first

    if("Select All" %in% input$energySourceInput_first_adm) {
      updateCheckboxGroupInput(session, "energySourceInput_first_adm", choices = c("Select All", "Select Renewable", "Select nonRenewable"), selected = c("Select All", "Select Renewable", "Select nonRenewable"))
      updateCheckboxGroupInput(session, "energySourceInput_second_adm", choices = c("Select All", "Select Renewable", "Select nonRenewable"), selected = c("Select All", "Select Renewable", "Select nonRenewable"))
      updateCheckboxGroupInput(session, "energySourceInput_first", choices = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other"), selected = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other"))
      updateCheckboxGroupInput(session, "energySourceInput_second", choices = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other"), selected = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other"))
    }
    else if("Select Renewable" %in% input$energySourceInput_first_adm && "Select nonRenewable" %in% input$energySourceInput_first_adm) {
      updateCheckboxGroupInput(session, "energySourceInput_first_adm", choices = c("Select All", "Select Renewable", "Select nonRenewable"), selected = c("Select Renewable", "Select nonRenewable"))
      updateCheckboxGroupInput(session, "energySourceInput_second_adm", choices = c("Select All", "Select Renewable", "Select nonRenewable"), selected = c("Select Renewable", "Select nonRenewable"))
      updateCheckboxGroupInput(session, "energySourceInput_first", choices = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other"), selected = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other"))
      updateCheckboxGroupInput(session, "energySourceInput_second", choices = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other"), selected = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other"))
    }
    else if("Select Renewable" %in% input$energySourceInput_first_adm) {
        updateCheckboxGroupInput(session, "energySourceInput_first_adm", choices = c("Select All", "Select Renewable", "Select nonRenewable"), selected = c("Select Renewable"))
        updateCheckboxGroupInput(session, "energySourceInput_second_adm", choices = c("Select All", "Select Renewable", "Select nonRenewable"), selected = c("Select Renewable"))
        updateCheckboxGroupInput(session, "energySourceInput_first", choices = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other"), selected = c(temp, "Hydro", "Biomass", "Wind", "Solar", "Geothermal"))
        updateCheckboxGroupInput(session, "energySourceInput_second", choices = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other"), selected = c(temp, "Hydro", "Biomass", "Wind", "Solar", "Geothermal"))
    }
    else if("Select nonRenewable" %in% input$energySourceInput_first_adm) {
        updateCheckboxGroupInput(session, "energySourceInput_first_adm", choices = c("Select All", "Select Renewable", "Select nonRenewable"), selected = c("Select nonRenewable"))
        updateCheckboxGroupInput(session, "energySourceInput_second_adm", choices = c("Select All", "Select Renewable", "Select nonRenewable"), selected = c("Select nonRenewable"))
        updateCheckboxGroupInput(session, "energySourceInput_first", choices = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other"), selected = c(temp, "Coal", "Oil", "Gas", "Nuclear", "Other"))
        updateCheckboxGroupInput(session, "energySourceInput_second", choices = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other"), selected = c(temp, "Coal", "Oil", "Gas", "Nuclear", "Other"))
    }
    else {
      updateCheckboxGroupInput(session, "energySourceInput_second_adm", 
                               choices = c("Select All", "Select Renewable", "Select nonRenewable"),
                               selected = input$energySourceInput_first_adm)
    }
      
    temp <- input$energySourceInput_first
  })
  
  observe({
    if(length(input$energySourceInput_first_adm == 3)) {}
    else {
    updateCheckboxGroupInput(session, "energySourceInput_second", 
                             choices = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other"),
                             selected = input$energySourceInput_first)
    } 
    
    gen_year_first <- getTableByYear(input$yearInput_first)
    slice_gen_com_first <- getMapTable(gen_year_first, state.abb[which(state.name == input$stateInput_first)], input$energySourceInput_first)

      gen_com_first_map <- getComparisonMap(slice_gen_com_first, state.abb[which(state.name == input$stateInput_first)])

      output$leaf_com_first <- renderLeaflet({
        gen_com_first_map
      })
  })
  
  #first graph energy source input unsync
  observe({
    if("Select All" %in% input$energySourceInput_first_unsync)  {
      updateCheckboxGroupInput(session,"energySourceInput_first_unsync", selected=c("Select All", energySource_dist))
    }
    else{ 
      if("Select Renewable" %in% input$energySourceInput_first_unsync) {
        updateCheckboxGroupInput(session,"energySourceInput_first_unsync", selected=c(input$energySourceInput_first_unsync, "Select Renewable", "Hydro", "Biomass", "Wind", "Solar", "Geothermal"))
      }
      if("Select nonRenewable" %in% input$energySourceInput_first_unsync) {
        updateCheckboxGroupInput(session,"energySourceInput_first_unsync", selected=c(input$energySourceInput_first_unsync, "Select nonRenewable", "Coal", "Oil", "Gas", "Nuclear", "Other"))
      }
    }
    
    gen_year_first <- getTableByYear(input$yearInput_first)
    slice_gen_com_first <- getMapTable(gen_year_first, state.abb[which(state.name == input$stateInput_first)], input$energySourceInput_first_unsync)
    
    gen_com_first_map <- getComparisonMap(slice_gen_com_first, state.abb[which(state.name == input$stateInput_first)])
    
    #render map output
    output$leaf_com_first <- renderLeaflet({
      gen_com_first_map
    })
  })
  
  
  #second graph year input
  gen_year_second <- NULL
  observeEvent(input$yearInput_second, {  
    gen_year_second <- getTableByYear(input$yearInput_second)
    slice_gen_com_second <- getMapTable(gen_year_second, state.abb[which(state.name == input$stateInput_second)], input$energySourceInput_second)
  })
  
  #second graph state input
  observeEvent(input$stateInput_second, {  
    gen_year_second <- getTableByYear(input$yearInput_second)
    slice_gen_com_second <- getMapTable(gen_year_second, state.abb[which(state.name == input$stateInput_second)], input$energySourceInput_second)
  })
  
  #second graph energy source input sync
  observe({
    updateCheckboxGroupInput(session, "energySourceInput_first_adm", 
                             choices = c("Select All", "Select Renewable", "Select nonRenewable"),
                             selected = input$energySourceInput_second_adm)
  })
  
  observe({
    updateCheckboxGroupInput(session, "energySourceInput_first", 
                             choices = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other"),
                             selected = input$energySourceInput_second)
    
    gen_year_second <- getTableByYear(input$yearInput_second)
    slice_gen_com_second <- getMapTable(gen_year_second, state.abb[which(state.name == input$stateInput_second)], input$energySourceInput_second)
    
    gen_com_second_map <- getComparisonMap(slice_gen_com_second, state.abb[which(state.name == input$stateInput_second)])
    
    #render map output
    output$leaf_com_second <- renderLeaflet({
      gen_com_second_map
    })
  })
  
  #second graph energy source input unsync
  observe({
    if("Select All" %in% input$energySourceInput_second_unsync)  {
      updateCheckboxGroupInput(session,"energySourceInput_second_unsync", selected=c("Select All", energySource_dist))
    }
    else{ 
      if("Select Renewable" %in% input$energySourceInput_second_unsync) {
        updateCheckboxGroupInput(session,"energySourceInput_second_unsync", selected=c(input$energySourceInput_second_unsync, "Select Renewable", "Hydro", "Biomass", "Wind", "Solar", "Geothermal"))
      }
      if("Select nonRenewable" %in% input$energySourceInput_second_unsync) {
        updateCheckboxGroupInput(session,"energySourceInput_second_unsync", selected=c(input$energySourceInput_second_unsync, "Select nonRenewable", "Coal", "Oil", "Gas", "Nuclear", "Other"))
      }
    }
    
    gen_year_second <- getTableByYear(input$yearInput_second)
    slice_gen_com_second <- getMapTable(gen_year_second, state.abb[which(state.name == input$stateInput_second)], input$energySourceInput_second_unsync)
    
    gen_com_second_map <- getComparisonMap(slice_gen_com_second, state.abb[which(state.name == input$stateInput_second)])
    
    #render map output
    output$leaf_com_second <- renderLeaflet({
      gen_com_second_map
    })
  })
  


  
  
  getComparisonMap <- function(slice_gen, stateInput) {
    leaflet() %>% 
      addProviderTiles(
        providers$CartoDB.Positron, group = "Light"
      ) %>%
      addProviderTiles(
        providers$CartoDB.DarkMatter, group = "Dark"
      ) %>%
      setView(
        lng = subset(state_location, state == stateInput)$longtitude, 
        lat = subset(state_location, state == stateInput)$latitude,
        zoom = subset(state_location, state == stateInput)$zoom
      ) %>%
      addCircles(
        data = subset(slice_gen, SOURCE == "Coal"),
        lng = ~PLANT_LONG, 
        lat = ~PLANT_LAT, 
        weight = 1,
        radius = ~sqrt(GEN/100)*100, 
        fillOpacity=0.4, 
        color = "#e6194B", 
        popup=paste("ORIS Code: ", subset(slice_gen, SOURCE == "Coal")$ORIS_CODE, "<br>", "Generation Capacity: ", subset(slice_gen, SOURCE == "Coal")$GEN)
      ) %>%
      addCircles(
        data = subset(slice_gen, SOURCE == "Oil"),
        lng = ~PLANT_LONG, 
        lat = ~PLANT_LAT, 
        weight = 1,
        radius = ~sqrt(GEN/100)*100, 
        fillOpacity=0.4, 
        color = "#f58231", 
        popup=paste("ORIS Code: ", subset(slice_gen, SOURCE == "Oil")$ORIS_CODE, "<br>", "Generation Capacity: ", subset(slice_gen, SOURCE == "Oil")$GEN)
      ) %>%
      addCircles(
        data = subset(slice_gen, SOURCE == "Gas"),
        lng = ~PLANT_LONG, 
        lat = ~PLANT_LAT, 
        weight = 1,
        radius = ~sqrt(GEN/100)*100, 
        fillOpacity=0.4, 
        color = "#ffe119", 
        popup=paste("ORIS Code: ", subset(slice_gen, SOURCE == "Gas")$ORIS_CODE, "<br>", "Generation Capacity: ", subset(slice_gen, SOURCE == "Gas")$GEN)
      ) %>%
      addCircles(
        data = subset(slice_gen, SOURCE == "Nuclear"),
        lng = ~PLANT_LONG, 
        lat = ~PLANT_LAT,
        weight = 1,
        radius = ~sqrt(GEN/100)*100, 
        fillOpacity=0.2, 
        color = "#bfef45", 
        popup=paste("ORIS Code: ", subset(slice_gen, SOURCE == "Nuclear")$ORIS_CODE, "<br>", "Generation Capacity: ", subset(slice_gen, SOURCE == "Nuclear")$GEN)
      ) %>%
      addCircles(
        data = subset(slice_gen, SOURCE == "Hydro"),
        lng = ~PLANT_LONG, 
        lat = ~PLANT_LAT,
        weight = 1,
        radius = ~sqrt(GEN/100)*100, 
        fillOpacity=0.3, 
        color = "#3cb44b", 
        popup=paste("ORIS Code: ", subset(slice_gen, SOURCE == "Hydrio")$ORIS_CODE, "<br>", "Generation Capacity: ", subset(slice_gen, SOURCE == "Hydrio")$GEN)
      ) %>%
      addCircles(
        data = subset(slice_gen, SOURCE == "Biomass"),
        lng = ~PLANT_LONG, 
        lat = ~PLANT_LAT, 
        weight = 1,
        radius = ~sqrt(GEN/100)*100, 
        fillOpacity=0.3, 
        color = "#42d4f4", 
        popup=paste("ORIS Code: ", subset(slice_gen, SOURCE == "Biomass")$ORIS_CODE, "<br>", "Generation Capacity: ", subset(slice_gen, SOURCE == "Biomass")$GEN)
      ) %>%
      addCircles(
        data = subset(slice_gen, SOURCE == "Wind"),
        lng = ~PLANT_LONG, 
        lat = ~PLANT_LAT, 
        weight = 1,
        radius = ~sqrt(GEN/100)*100, 
        fillOpacity=0.3, 
        color = "#4363d8", 
        popup=paste("ORIS Code: ", subset(slice_gen, SOURCE == "Wind")$ORIS_CODE, "<br>", "Generation Capacity: ", subset(slice_gen, SOURCE == "Wind")$GEN)
      ) %>%
      addCircles(
        data = subset(slice_gen, SOURCE == "Solar"),
        lng = ~PLANT_LONG, 
        lat = ~PLANT_LAT, 
        weight = 1,
        radius = ~sqrt(GEN/100)*100, 
        fillOpacity=0.5, 
        color = "#911eb4", 
        popup=paste("ORIS Code: ", subset(slice_gen, SOURCE == "Solar")$ORIS_CODE, "<br>", "Generation Capacity: ", subset(slice_gen, SOURCE == "Solar")$GEN)
      ) %>%
      addCircles(
        data = subset(slice_gen, SOURCE == "Geothermal"),
        lng = ~PLANT_LONG, 
        lat = ~PLANT_LAT, 
        weight = 1,
        radius = ~sqrt(GEN/100)*100, 
        fillOpacity=0.3, 
        color = "#f032e6", 
        popup=paste("ORIS Code: ", subset(slice_gen, SOURCE == "Geothermal")$ORIS_CODE, "<br>", "Generation Capacity: ", subset(slice_gen, SOURCE == "Geothermal")$GEN)
      ) %>%
      addCircles(
        data = subset(slice_gen, SOURCE == "Other"),
        lng = ~PLANT_LONG, 
        lat = ~PLANT_LAT, 
        weight = 1,
        radius = ~sqrt(GEN/100)*100, 
        fillOpacity=0.3, 
        color = "#a9a9a9", 
        popup=paste("ORIS Code: ", subset(slice_gen, SOURCE == "Other")$ORIS_CODE, "<br>", "Generation Capacity: ", subset(slice_gen, SOURCE == "Other")$GEN)) %>%
      
      addLegend("bottomright", colors= c("#e6194B", "#f58231","#ffe119" ,"#bfef45", "#3cb44b", "#42d4f4", "#4363d8", "#911eb4", "#f032e6", "#a9a9a9"), 
                labels=c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other"), title="Energy Source") %>%
      addLayersControl(
        baseGroups = c("Light", "Dark"),
        options = layersControlOptions(collapsed = FALSE)
      )
  }
}
 

