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
                           other = makeIcon("map-pin-solid-other.svg", iconWidth = 12, iconHeight =24),
                           unknown = makeIcon("map-pin-solid-unknown.svg", iconWidth = 12, iconHeight =24)
                           )
    
    gen_2018_IL_map <- leaflet() %>% 
      addProviderTiles(
        providers$CartoDB.Positron, group = "Light"
      ) %>%
      addProviderTiles(
        providers$CartoDB.DarkMatter, group = "Dark"
      ) %>%
      addProviderTiles(
        providers$Esri.WorldTopoMap, group = "Terrain"
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
      addMarkers(data = subset(slice_gen_2018_IL, SOURCE == "Unknown"),
                 lat = ~U_PLANT_LAT,
                 lng = ~U_PLANT_LONG,
                 icon = quakeIcons["unknown"],
                 #popup = ~PointUse
      )%>%
      addLegend("bottomright", colors= c("#e6194B", "#f58231","#808000" ,"#800000", "#3cb44b", "#42d4f4", "#4363d8", "#911eb4", "#f032e6", "#a9a9a9"), 
              labels=c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other"), title="Energy Source") %>%
      addLayersControl(
                baseGroups = c("Light", "Dark", "Terrain"),
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
               checkboxGroupInput("energySourceInput_first", "", choices = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other", "Unknown"))
        ) #energy source filter end
      })
      output$checkbox_second <- renderUI({
        #Energy source filter start
        tags$div(class = "filter",
                 checkboxGroupInput("energySourceInput_second_adm", "Energy source: ", choices = c("Select All", "Select Renewable", "Select nonRenewable")),
                 checkboxGroupInput("energySourceInput_second", "", choices = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other", "Unknown"))
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
      updateCheckboxGroupInput(session, "energySourceInput_first", choices = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other", "Unknown"), selected = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other", "Unknown"))
      updateCheckboxGroupInput(session, "energySourceInput_second", choices = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other", "Unknown"), selected = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other", "Unknown"))
    }
    else if("Select Renewable" %in% input$energySourceInput_first_adm && "Select nonRenewable" %in% input$energySourceInput_first_adm) {
      updateCheckboxGroupInput(session, "energySourceInput_first_adm", choices = c("Select All", "Select Renewable", "Select nonRenewable"), selected = c("Select Renewable", "Select nonRenewable"))
      updateCheckboxGroupInput(session, "energySourceInput_second_adm", choices = c("Select All", "Select Renewable", "Select nonRenewable"), selected = c("Select Renewable", "Select nonRenewable"))
      updateCheckboxGroupInput(session, "energySourceInput_first", choices = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other", "Unknown"), selected = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other"))
      updateCheckboxGroupInput(session, "energySourceInput_second", choices = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other", "Unknown"), selected = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other"))
    }
    else if("Select Renewable" %in% input$energySourceInput_first_adm) {
        updateCheckboxGroupInput(session, "energySourceInput_first_adm", choices = c("Select All", "Select Renewable", "Select nonRenewable"), selected = c("Select Renewable"))
        updateCheckboxGroupInput(session, "energySourceInput_second_adm", choices = c("Select All", "Select Renewable", "Select nonRenewable"), selected = c("Select Renewable"))
        updateCheckboxGroupInput(session, "energySourceInput_first", choices = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other", "Unknown"), selected = c(temp, "Hydro", "Biomass", "Wind", "Solar", "Geothermal"))
        updateCheckboxGroupInput(session, "energySourceInput_second", choices = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other", "Unknown"), selected = c(temp, "Hydro", "Biomass", "Wind", "Solar", "Geothermal"))
    }
    else if("Select nonRenewable" %in% input$energySourceInput_first_adm) {
        updateCheckboxGroupInput(session, "energySourceInput_first_adm", choices = c("Select All", "Select Renewable", "Select nonRenewable"), selected = c("Select nonRenewable"))
        updateCheckboxGroupInput(session, "energySourceInput_second_adm", choices = c("Select All", "Select Renewable", "Select nonRenewable"), selected = c("Select nonRenewable"))
        updateCheckboxGroupInput(session, "energySourceInput_first", choices = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other", "Unknown"), selected = c(temp, "Coal", "Oil", "Gas", "Nuclear", "Other"))
        updateCheckboxGroupInput(session, "energySourceInput_second", choices = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other", "Unknown"), selected = c(temp, "Coal", "Oil", "Gas", "Nuclear", "Other"))
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
                             choices = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other", "Unknown"),
                             selected = input$energySourceInput_first)
    } 
    
    gen_year_first <- getTableByYear(input$yearInput_first)
    slice_gen_com_first <- getMapTable(gen_year_first, state.abb[which(state.name == input$stateInput_first)], input$energySourceInput_first)

      gen_com_first_map <- getLeafletMap(slice_gen_com_first, state.abb[which(state.name == input$stateInput_first)])

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
    
    gen_com_first_map <- getLeafletMap(slice_gen_com_first, state.abb[which(state.name == input$stateInput_first)])
    
    #render map output
    output$leaf_com_first <- renderLeaflet({
      gen_com_first_map
    })
  })
  
  #reset button first
  observeEvent(input$reset_com_first, {
    gen_year_first <- getTableByYear(input$yearInput_first)
    slice_gen_com_first <- getMapTable(gen_year_first, state.abb[which(state.name == input$stateInput_first)], input$energySourceInput_first_unsync)
    
    gen_com_first_map <- getLeafletMap(slice_gen_com_first, state.abb[which(state.name == input$stateInput_first)])
    
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
                             choices = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other", "Unknown"),
                             selected = input$energySourceInput_second)
    
    gen_year_second <- getTableByYear(input$yearInput_second)
    slice_gen_com_second <- getMapTable(gen_year_second, state.abb[which(state.name == input$stateInput_second)], input$energySourceInput_second)
    
    gen_com_second_map <- getLeafletMap(slice_gen_com_second, state.abb[which(state.name == input$stateInput_second)])
    
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
    
    gen_com_second_map <- getLeafletMap(slice_gen_com_second, state.abb[which(state.name == input$stateInput_second)])
    
    #render map output
    output$leaf_com_second <- renderLeaflet({
      gen_com_second_map
    })
  })
  
  #reset button second
  observeEvent(input$reset_com_second, {
    gen_year_second <- getTableByYear(input$yearInput_second)
    slice_gen_com_second <- getMapTable(gen_year_second, state.abb[which(state.name == input$stateInput_second)], input$energySourceInput_second_unsync)
    
    gen_com_second_map <- getLeafletMap(slice_gen_com_second, state.abb[which(state.name == input$stateInput_second)])
    
    output$leaf_com_second <- renderLeaflet({
      gen_com_second_map
    })
  })
  


  ###################### Page 3 ##########################
  #inverse button
  observeEvent(input$isInverse, {
    if(input$isInverse) {
      output$slider_left <- renderUI({
        tags$div(class = "cust-text",
                 sliderInput("slider_l", "Generation Range (kMWh):",
                             min = 0, max = 16000,
                             value = 16000),
        )
      })
      output$slider_right <- renderUI({
        tags$div(class = "cust-text slider-right",
                 sliderInput("slider_r", "Generation Range (kMWh):",
                             min = 16000, max = 32000,
                             value = 16000),
        )
      })
    }
    else {
      output$slider_left <- renderUI({
        tags$div(class = "cust-text slider-right",
                 sliderInput("slider_l", "Generation Range (kMWh):",
                             min = 0, max = 16000,
                             value = 0),
        )
      })
      output$slider_right <- renderUI({
        tags$div(class = "cust-text",
                 sliderInput("slider_r", "Generation Range (kMWh):",
                             min = 16000, max = 32000,
                             value = 32000),
        )
      })
    }
  })
  
  #left slider input
  gen_year_second <- NULL
  observeEvent(input$slider_l, {  
    gen_year_us <- getTableByYear(input$yearInput_us)
    slice_gen_us <- getMapTable(gen_year_us, "US", input$energySourceInput_us)
    
    if(input$isInverse) {
      if(input$slider_r < input$slider_l)
        updateValue_inv_r <- input$slider_l
      else
        updateValue_inv_r <- input$slider_r
      
      output$slider_right <- renderUI({
        tags$div(class = "cust-text slider-right",
                 sliderInput("slider_r", "Generation Range (kMWh):",
                             min = input$slider_l, max = 32000,
                             value = updateValue_inv_r),
        )
      })
      leftHandSide <- subset(slice_gen_us, GEN <= input$slider_l*1000)
      slice_gen_us <- subset(slice_gen_us, GEN >= input$slider_r*1000)
      slice_gen_us <- rbind(slice_gen_us, leftHandSide)
    }
    else {
      if(input$slider_r < input$slider_l)
        updateValue_r <- input$slider_l
      else
        updateValue_r <- input$slider_r
      output$slider_right <- renderUI({
        tags$div(class = "cust-text",
                 sliderInput("slider_r", "Generation Range (kMWh):",
                             min = input$slider_l, max = 32000,
                             value = updateValue_r),
        )
      })
      slice_gen_us <- subset(slice_gen_us, GEN >= input$slider_l*1000)
      slice_gen_us <- subset(slice_gen_us, GEN <= input$slider_r*1000)
    }
    
    
    gen_us <- getLeafletMap(slice_gen_us, "US")
    
    output$leaf_us <- renderLeaflet({
      gen_us
    })
  })
  
  #right slider input
  observeEvent(input$slider_r, {  
    gen_year_us <- getTableByYear(input$yearInput_us)
    slice_gen_us <- getMapTable(gen_year_us, "US", input$energySourceInput_us)
    
    if(input$isInverse) {
      if(input$slider_r < input$slider_l)
        updateValue_inv_l <- input$slider_r
      else
        updateValue_inv_l <- input$slider_l

      output$slider_left <- renderUI({
        tags$div(class = "cust-text",
                 sliderInput("slider_l", "Generation Range (kMWh):",
                             min = 0, max = input$slider_r,
                             value = updateValue_inv_l),
        )
      })
      leftHandSide <- subset(slice_gen_us, GEN <= input$slider_l*1000)
      slice_gen_us <- subset(slice_gen_us, GEN >= input$slider_r*1000)
      slice_gen_us <- rbind(slice_gen_us, leftHandSide)
    }
    else {
      if(input$slider_r < input$slider_l)
        updateValue_l <- input$slider_r
      else
        updateValue_l <- input$slider_l
      
      output$slider_left <- renderUI({
        tags$div(class = "cust-text slider-right",
                 sliderInput("slider_l", "Generation Range (kMWh):",
                             min = 0, max = input$slider_r,
                             value = updateValue_l),
        )
      })
      slice_gen_us <- subset(slice_gen_us, GEN >= input$slider_l*1000)
      slice_gen_us <- subset(slice_gen_us, GEN <= input$slider_r*1000)
    }
    
    
    gen_us <- getLeafletMap(slice_gen_us, "US")
    
    output$leaf_us <- renderLeaflet({
      gen_us
    })
  })
  
  observeEvent(input$yearInput_us, {  
    gen_year_us <- getTableByYear(input$yearInput_us)
    slice_gen_us <- getMapTable(gen_year_us, "US", input$energySourceInput_us)
  })
  
  #energy source input check box
  observe({
    if("Select All" %in% input$energySourceInput_us)  {
      updateCheckboxGroupInput(session,"energySourceInput_us", selected=c("Select All", energySource_dist))
    }
    else{ 
      if("Select Renewable" %in% input$energySourceInput_us) {
        updateCheckboxGroupInput(session,"energySourceInput_us", selected=c(input$energySourceInput_us, "Select Renewable", "Hydro", "Biomass", "Wind", "Solar", "Geothermal"))
      }
      if("Select nonRenewable" %in% input$energySourceInput_us) {
        updateCheckboxGroupInput(session,"energySourceInput_us", selected=c(input$energySourceInput_us, "Select nonRenewable", "Coal", "Oil", "Gas", "Nuclear", "Other"))
      }
    }
    
    gen_year_us <- getTableByYear(input$yearInput_us)
    slice_gen_us <- getMapTable(gen_year_us, "US", input$energySourceInput_us)
    
    if(input$isInverse) {
      leftHandSide <- subset(slice_gen_us, GEN <= input$slider_l*1000)
      slice_gen_us <- subset(slice_gen_us, GEN >= input$slider_r*1000)
      slice_gen_us <- rbind(slice_gen_us, leftHandSide)
    }
    else {
      slice_gen_us <- subset(slice_gen_us, GEN >= input$slider_l*1000)
      slice_gen_us <- subset(slice_gen_us, GEN <= input$slider_r*1000)
    }
    
    
    gen_us <- getLeafletMap(slice_gen_us, "US")
    
    output$leaf_us <- renderLeaflet({
      gen_us
    })
  })
  
  #reset button second
  observeEvent(input$reset_us, {
    gen_year_us <- getTableByYear(input$yearInput_us)
    slice_gen_us <- getMapTable(gen_year_us, "US", input$energySourceInput_us)
    
    if(input$isInverse) {
      leftHandSide <- subset(slice_gen_us, GEN <= input$slider_l*1000)
      slice_gen_us <- subset(slice_gen_us, GEN >= input$slider_r*1000)
      slice_gen_us <- rbind(slice_gen_us, leftHandSide)
    }
    else {
      slice_gen_us <- subset(slice_gen_us, GEN >= input$slider_l*1000)
      slice_gen_us <- subset(slice_gen_us, GEN <= input$slider_r*1000)
    }
    
    gen_us <- getLeafletMap(slice_gen_us, "US")
    
    output$leaf_us <- renderLeaflet({
      gen_us
    })
  })
  
  
  #################### page 4 #########################
  observeEvent(input$yearInput_in, {  
    
  })
  
  observe({
    if("Select All" %in% input$energySourceInput_in)  {
      updateCheckboxGroupInput(session,"energySourceInput_in", selected=c("Select All", energySource_dist))
    }
    else{ 
      if("Select Renewable" %in% input$energySourceInput_in) {
        updateCheckboxGroupInput(session,"energySourceInput_in", selected=c(input$energySourceInput_in, "Select Renewable", "Hydro", "Biomass", "Wind", "Solar", "Geothermal"))
      }
      if("Select nonRenewable" %in% input$energySourceInput_in) {
        updateCheckboxGroupInput(session,"energySourceInput_in", selected=c(input$energySourceInput_in, "Select nonRenewable", "Coal", "Oil", "Gas", "Nuclear", "Other"))
      }
    }
    
    slice_gen_in <- getSliceIdleNewTable(input$yearInput_in, input$sourceInput_in, input$energySourceInput_in)
    gen_idle_new_map <- getLeafletMap(slice_gen_in, "US")
    
    
    output$leaf_in <- renderLeaflet({
      gen_idle_new_map
    })
  })
  
  #reset button idle or new
  observeEvent(input$reset_in, {
    slice_gen_in <- getSliceIdleNewTable(input$yearInput_in, input$sourceInput_in, input$energySourceInput_in)
    gen_idle_new_map <- getLeafletMap(slice_gen_in, "US")
    
    
    output$leaf_in <- renderLeaflet({
      gen_idle_new_map
    })
  })
  
  #################### generate graph ####################
  getLeafletMap <- function(slice_gen, stateInput) {
    leaflet() %>% 
      addProviderTiles(
        providers$CartoDB.Positron, group = "Light"
      ) %>%
      addProviderTiles(
        providers$CartoDB.DarkMatter, group = "Dark"
      ) %>%
      addProviderTiles(
        providers$Esri.WorldTopoMap, group = "Terrain"
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
        radius = ~sqrt(GEN/100)*150, 
        fillOpacity=0.4, 
        color = "#e6194B", 
        popup=paste("ORIS Code: ", subset(slice_gen, SOURCE == "Coal")$ORIS_CODE, "<br>",
                    "Plant Name: ", subset(slice_gen, SOURCE == "Coal")$PLANT_NAME, "<br>",
                    "Coal Generation Capacity: ", formatC(as.numeric(subset(slice_gen, SOURCE == "Coal")$GEN), format="f", digits=2, big.mark=","), "<br>",
                    "Renewable Energy Source (%)", format(round(subset(slice_gen, SOURCE == "Coal")$TOTAL_RENEWABLE_PER, 2), nsmall = 2), "<br>",
                    "Non-Renewable Energy Source (%)", format(round(subset(slice_gen, SOURCE == "Coal")$TOTAL_NONRENEWABLE_PER, 2), nsmall = 2), "<br>")
      ) %>%
      addCircles(
        data = subset(slice_gen, SOURCE == "Oil"),
        lng = ~PLANT_LONG, 
        lat = ~PLANT_LAT, 
        weight = 1,
        radius = ~sqrt(GEN/100)*150, 
        fillOpacity=0.4, 
        color = "#f58231", 
        popup=paste("ORIS Code: ", subset(slice_gen, SOURCE == "Oil")$ORIS_CODE, "<br>",
                    "Plant Name: ", subset(slice_gen, SOURCE == "Oil")$PLANT_NAME, "<br>",
                    "Oil Generation Capacity: ", formatC(as.numeric(subset(slice_gen, SOURCE == "Oil")$GEN), format="f", digits=2, big.mark=","), "<br>",
                    "Renewable Energy Source (%)", format(round(subset(slice_gen, SOURCE == "Oil")$TOTAL_RENEWABLE_PER, 2), nsmall = 2), "<br>",
                    "Non-Renewable Energy Source (%)", format(round(subset(slice_gen, SOURCE == "Oil")$TOTAL_NONRENEWABLE_PER, 2), nsmall = 2), "<br>")
      ) %>%
      addCircles(
        data = subset(slice_gen, SOURCE == "Gas"),
        lng = ~PLANT_LONG, 
        lat = ~PLANT_LAT, 
        weight = 1,
        radius = ~sqrt(GEN/100)*150, 
        fillOpacity=0.4, 
        color = "#808000", 
        popup = paste("ORIS Code: ", subset(slice_gen, SOURCE == "Gas")$ORIS_CODE, "<br>",
                "Plant Name: ", subset(slice_gen, SOURCE == "Gas")$PLANT_NAME, "<br>",
                "Gas Generation Capacity: ", formatC(as.numeric(subset(slice_gen, SOURCE == "Gas")$GEN), format="f", digits=2, big.mark=","), "<br>",
                "Renewable Energy Source (%)", format(round(subset(slice_gen, SOURCE == "Gas")$TOTAL_RENEWABLE_PER, 2), nsmall = 2), "<br>",
                "Non-Renewable Energy Source (%)", format(round(subset(slice_gen, SOURCE == "Gas")$TOTAL_NONRENEWABLE_PER, 2), nsmall = 2), "<br>")
      ) %>%
      addCircles(
        data = subset(slice_gen, SOURCE == "Nuclear"),
        lng = ~PLANT_LONG, 
        lat = ~PLANT_LAT,
        weight = 1,
        radius = ~sqrt(GEN/100)*150, 
        fillOpacity=0.2, 
        color = "#800000", 
        popup = paste("ORIS Code: ", subset(slice_gen, SOURCE == "Nuclear")$ORIS_CODE, "<br>",
                      "Plant Name: ", subset(slice_gen, SOURCE == "Nuclear")$PLANT_NAME, "<br>",
                      "Nuclear Generation Capacity: ", formatC(as.numeric(subset(slice_gen, SOURCE == "Nuclear")$GEN), format="f", digits=2, big.mark=","), "<br>",
                      "Renewable Energy Source (%)", format(round(subset(slice_gen, SOURCE == "Nuclear")$TOTAL_RENEWABLE_PER, 2), nsmall = 2), "<br>",
                      "Non-Renewable Energy Source (%)", format(round(subset(slice_gen, SOURCE == "Nuclear")$TOTAL_NONRENEWABLE_PER, 2), nsmall = 2), "<br>")
      ) %>%
      addCircles(
        data = subset(slice_gen, SOURCE == "Hydro"),
        lng = ~PLANT_LONG, 
        lat = ~PLANT_LAT,
        weight = 1,
        radius = ~sqrt(GEN/100)*150, 
        fillOpacity=0.3, 
        color = "#3cb44b", 
        popup = paste("ORIS Code: ", subset(slice_gen, SOURCE == "Hydro")$ORIS_CODE, "<br>",
                      "Plant Name: ", subset(slice_gen, SOURCE == "Hydro")$PLANT_NAME, "<br>",
                      "Hydro Generation Capacity: ", formatC(as.numeric(subset(slice_gen, SOURCE == "Hydro")$GEN), format="f", digits=2, big.mark=","), "<br>",
                      "Renewable Energy Source (%)", format(round(subset(slice_gen, SOURCE == "Hydro")$TOTAL_RENEWABLE_PER, 2), nsmall = 2), "<br>",
                      "Non-Renewable Energy Source (%)", format(round(subset(slice_gen, SOURCE == "Hydro")$TOTAL_NONRENEWABLE_PER, 2), nsmall = 2), "<br>")
      ) %>%
      addCircles(
        data = subset(slice_gen, SOURCE == "Biomass"),
        lng = ~PLANT_LONG, 
        lat = ~PLANT_LAT, 
        weight = 1,
        radius = ~sqrt(GEN/100)*150, 
        fillOpacity=0.3, 
        color = "#42d4f4", 
        popup = paste("ORIS Code: ", subset(slice_gen, SOURCE == "Biomass")$ORIS_CODE, "<br>",
                      "Plant Name: ", subset(slice_gen, SOURCE == "Biomass")$PLANT_NAME, "<br>",
                      "Biomass Generation Capacity: ", formatC(as.numeric(subset(slice_gen, SOURCE == "Biomass")$GEN), format="f", digits=2, big.mark=","), "<br>",
                      "Renewable Energy Source (%)", format(round(subset(slice_gen, SOURCE == "Biomass")$TOTAL_RENEWABLE_PER, 2), nsmall = 2), "<br>",
                      "Non-Renewable Energy Source (%)", format(round(subset(slice_gen, SOURCE == "Biomass")$TOTAL_NONRENEWABLE_PER, 2), nsmall = 2), "<br>")
      ) %>%
      addCircles(
        data = subset(slice_gen, SOURCE == "Wind"),
        lng = ~PLANT_LONG, 
        lat = ~PLANT_LAT, 
        weight = 1,
        radius = ~sqrt(GEN/100)*150, 
        fillOpacity=0.3, 
        color = "#4363d8", 
        popup = paste("ORIS Code: ", subset(slice_gen, SOURCE == "Wind")$ORIS_CODE, "<br>",
                      "Plant Name: ", subset(slice_gen, SOURCE == "Wind")$PLANT_NAME, "<br>",
                      "Wind Generation Capacity: ", formatC(as.numeric(subset(slice_gen, SOURCE == "Wind")$GEN), format="f", digits=2, big.mark=","), "<br>",
                      "Renewable Energy Source (%)", format(round(subset(slice_gen, SOURCE == "Wind")$TOTAL_RENEWABLE_PER, 2), nsmall = 2), "<br>",
                      "Non-Renewable Energy Source (%)", format(round(subset(slice_gen, SOURCE == "Wind")$TOTAL_NONRENEWABLE_PER, 2), nsmall = 2), "<br>")
      ) %>%
      addCircles(
        data = subset(slice_gen, SOURCE == "Solar"),
        lng = ~PLANT_LONG, 
        lat = ~PLANT_LAT, 
        weight = 1,
        radius = ~sqrt(GEN/100)*150, 
        fillOpacity=0.5, 
        color = "#911eb4", 
        popup = paste("ORIS Code: ", subset(slice_gen, SOURCE == "Solar")$ORIS_CODE, "<br>",
                      "Plant Name: ", subset(slice_gen, SOURCE == "Solar")$PLANT_NAME, "<br>",
                      "Solar Generation Capacity: ", formatC(as.numeric(subset(slice_gen, SOURCE == "Solar")$GEN), format="f", digits=2, big.mark=","), "<br>",
                      "Renewable Energy Source (%)", format(round(subset(slice_gen, SOURCE == "Solar")$TOTAL_RENEWABLE_PER, 2), nsmall = 2), "<br>",
                      "Non-Renewable Energy Source (%)", format(round(subset(slice_gen, SOURCE == "Solar")$TOTAL_NONRENEWABLE_PER, 2), nsmall = 2), "<br>")
      ) %>%
      addCircles(
        data = subset(slice_gen, SOURCE == "Geothermal"),
        lng = ~PLANT_LONG, 
        lat = ~PLANT_LAT, 
        weight = 1,
        radius = ~sqrt(GEN/100)*150, 
        fillOpacity=0.3, 
        color = "#f032e6", 
        popup = paste("ORIS Code: ", subset(slice_gen, SOURCE == "Geothermal")$ORIS_CODE, "<br>",
                      "Plant Name: ", subset(slice_gen, SOURCE == "Geothermal")$PLANT_NAME, "<br>",
                      "Geothermal Generation Capacity: ", formatC(as.numeric(subset(slice_gen, SOURCE == "Geothermal")$GEN), format="f", digits=2, big.mark=","), "<br>",
                      "Renewable Energy Source (%)", format(round(subset(slice_gen, SOURCE == "Geothermal")$TOTAL_RENEWABLE_PER, 2), nsmall = 2), "<br>",
                      "Non-Renewable Energy Source (%)", format(round(subset(slice_gen, SOURCE == "Geothermal")$TOTAL_NONRENEWABLE_PER, 2), nsmall = 2), "<br>")
      ) %>%
      addCircles(
        data = subset(slice_gen, SOURCE == "Other"),
        lng = ~PLANT_LONG, 
        lat = ~PLANT_LAT, 
        weight = 1,
        radius = ~sqrt(GEN/100)*150, 
        fillOpacity=0.3, 
        color = "#a9a9a9", 
        popup = paste("ORIS Code: ", subset(slice_gen, SOURCE == "Other")$ORIS_CODE, "<br>",
                              "Plant Name: ", subset(slice_gen, SOURCE == "Other")$PLANT_NAME, "<br>",
                              "Other Generation Capacity: ", formatC(as.numeric(subset(slice_gen, SOURCE == "Other")$GEN), format="f", digits=2, big.mark=","), "<br>",
                              "Renewable Energy Source (%)", format(round(subset(slice_gen, SOURCE == "Other")$TOTAL_RENEWABLE_PER, 2), nsmall = 2), "<br>",
                              "Non-Renewable Energy Source (%)", format(round(subset(slice_gen, SOURCE == "Other")$TOTAL_NONRENEWABLE_PER, 2), nsmall = 2), "<br>")
        ) %>%
      
      addCircles(
        data = subset(slice_gen, SOURCE == "Unknown"),
        lng = ~PLANT_LONG, 
        lat = ~PLANT_LAT, 
        weight = 1,
        radius = 100, 
        fillOpacity=0.3, 
        color = "#a9a9a9", 
        popup = paste("ORIS Code: ", subset(slice_gen, SOURCE == "Unknown")$ORIS_CODE, "<br>",
                      "Plant Name: ", subset(slice_gen, SOURCE == "Unknown")$PLANT_NAME, "<br>",
                      "Unknown Generation Capacity: ", formatC(as.numeric(subset(slice_gen, SOURCE == "Unknown")$GEN), format="f", digits=2, big.mark=","), "<br>",
                      "Renewable Energy Source (%)", format(round(subset(slice_gen, SOURCE == "Unknown")$TOTAL_RENEWABLE_PER, 2), nsmall = 2), "<br>",
                      "Non-Renewable Energy Source (%)", format(round(subset(slice_gen, SOURCE == "Unknown")$TOTAL_NONRENEWABLE_PER, 2), nsmall = 2), "<br>")
      ) %>%
      addLegend("bottomright", colors= c("#e6194B", "#f58231","#808000" ,"#800000", "#3cb44b", "#42d4f4", "#4363d8", "#911eb4", "#f032e6", "#a9a9a9", "black"), 
                labels=c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other", "Unknown"), title="Energy Source") %>%
      addLayersControl(
        baseGroups = c("Light", "Dark", "Terrain"),
        options = layersControlOptions(collapsed = FALSE)
      )
  }
}
 

