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
    energySourceInputList <- NULL
    #print(input$energySourceInput)
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
  fff<- NULL
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
    temp <- input$energySourceInput_first
  })
  
  observe({
    updateCheckboxGroupInput(session, "energySourceInput_first_adm", 
                             choices = c("Select All", "Select Renewable", "Select nonRenewable"),
                             selected = input$energySourceInput_second_adm)
  })
  
  observe({
    print("ZZ")
    updateCheckboxGroupInput(session, "energySourceInput_second", 
                             choices = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other"),
                             selected = input$energySourceInput_first)
    #fff <- input$energySourceInput_first
    
    #print(fff)
  })
  
  observe({
    print("EE")
    updateCheckboxGroupInput(session, "energySourceInput_first", 
                             choices = c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other"),
                             selected = input$energySourceInput_second)
  })
  
  output$leaf3 <- renderLeaflet({
    leaflet_IL_2018 <- leaflet(gen_2018_IL) %>%
      # Base groups
      addTiles(group = "OSM (default)") %>%
      addProviderTiles(providers$Stamen.Toner, group = "Toner") %>%
      addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
      # Overlay groups
      #if("COAL_GEN" %in% colnames(gen_2018_IL)) 
      leaflet_IL_2018 <- leaflet_IL_2018 %>% addCircles(~PLANT_LONG, ~PLANT_LAT, 2000, stroke = F, fillOpacity=1, group = "Coal", color = "#e6194B", popup=paste("ORIS Code: ", gen_2018_IL$ORIS_CODE, "<br>", "Generation Capacity: ", gen_2018_IL$COAL_GEN)) %>%
        #if("OIL_GEN" %in% colnames(gen_2018_IL)) 
        leaflet_IL_2018 <- leaflet_IL_2018 %>% addCircles(~PLANT_LONG, ~PLANT_LAT, 2000, stroke = F, fillOpacity=1, group = "Oil", color = "#f58231", popup=paste("ORIS Code: ", gen_2018_IL$ORIS_CODE, "<br>", "Generation Capacity: ", gen_2018_IL$OIL_GEN)) %>%
          
          
          addCircles(~PLANT_LONG, ~PLANT_LAT, ~GAS_GEN/100, stroke = F, fillOpacity=0.4, group = "Gas", color = "#ffe119", popup=paste("ORIS Code: ", gen_2018_IL$ORIS_CODE, "<br>",
                                                                                                                                       "Generation Capacity: ", gen_2018_IL$GAS_GEN)) %>%
          addCircles(~PLANT_LONG, ~PLANT_LAT, ~NUCLEAR_GEN/100, stroke = F, fillOpacity=0.2, group = "Nuclear", color = "#bfef45", popup=paste("ORIS Code: ", gen_2018_IL$ORIS_CODE, "<br>",
                                                                                                                                               "Generation Capacity: ", gen_2018_IL$NUCLEAR_GEN)) %>%
          addCircles(~PLANT_LONG, ~PLANT_LAT, ~HYDRO_GEN/100, stroke = F, fillOpacity=0.3, group = "Hydro", color = "#3cb44b", popup=paste("ORIS Code: ", gen_2018_IL$ORIS_CODE, "<br>",
                                                                                                                                           "Generation Capacity: ", gen_2018_IL$HYDRO_GEN)) %>%
          addCircles(~PLANT_LONG, ~PLANT_LAT, ~BIOMASS_GEN/100, stroke = F, fillOpacity=0.3, group = "Biomass", color = "#42d4f4", popup=paste("ORIS Code: ", gen_2018_IL$ORIS_CODE, "<br>",
                                                                                                                                               "Generation Capacity: ", gen_2018_IL$BIOMASS_GEN)) %>%
          addCircles(~PLANT_LONG, ~PLANT_LAT, ~WIND_GEN/100, stroke = F, fillOpacity=0.3, group = "Wind", color = "#4363d8", popup=paste("ORIS Code: ", gen_2018_IL$ORIS_CODE, "<br>",
                                                                                                                                         "Generation Capacity: ", gen_2018_IL$WIND_GEN)) %>%
          addCircles(~PLANT_LONG, ~PLANT_LAT, ~SOLAR_GEN/100, stroke = F, fillOpacity=0.3, group = "Solar", color = "#911eb4", popup=paste("ORIS Code: ", gen_2018_IL$ORIS_CODE, "<br>",
                                                                                                                                           "Generation Capacity: ", gen_2018_IL$SOLAR_GEN)) %>%
          addCircles(~PLANT_LONG, ~PLANT_LAT, ~GEOTHERMAL_GEN/100, stroke = F, fillOpacity=0.3, group = "Geothermal", color = "#f032e6", popup=paste("ORIS Code: ", gen_2018_IL$ORIS_CODE, "<br>",
                                                                                                                                                     "Generation Capacity: ", gen_2018_IL$GEOTHERMAL_GEN)) %>%
          addCircles(~PLANT_LONG, ~PLANT_LAT, ~OTHER_FOSSIL_GEN/100, stroke = F, fillOpacity=0.3, group = "Other", color = "#a9a9a9", popup=paste("ORIS Code: ", gen_2018_IL$ORIS_CODE, "<br>",
                                                                                                                                                  "Generation Capacity: ", gen_2018_IL$OTHER_GEN)) %>%
          addLegend("bottomright", colors= c("#e6194B", "#f58231","#ffe119" ,"#bfef45", "#3cb44b", "#42d4f4", "#4363d8", "#911eb4", "#f032e6", "#a9a9a9"), 
                    labels=c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other"), title="Energy Source") %>%
          
          # Layers control
          addLayersControl(
            baseGroups = c("OSM (default)", "Toner", "Toner Lite"),
            overlayGroups = c("Coal", "Oil"),
            options = layersControlOptions(collapsed = FALSE)
          )
  })
  
  
  #    output$map <- renderLeaflet({
  #      leaflet() %>%
  #        addTiles() %>%
  #        setView(lng = -93.85, lat = 37.45, zoom = 4)
  #    })
  
  #    leafletProxy("map", data = gen_2018_IL) %>%
  #      clearShapes() %>%
  #      addCircles(~PLANT_LONG, ~PLANT_LAT, radius=~COAL_GEN/100, layerId=~ORIS_CODE,
  #               stroke=FALSE, fillOpacity=0.4, fillColor="#e6194B")
  #  
  
  
  output$leaf2 <- renderLeaflet({
    leaflet(gen_2018_IL) %>%
      # Base groups
      addTiles(group = "OSM (default)") %>%
      addProviderTiles(providers$Stamen.Toner, group = "Toner") %>%
      addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
      
      # Overlay groups
      addCircles(~PLANT_LONG, ~PLANT_LAT, ~COAL_GEN/100, stroke = F, fillOpacity=0.3, group = "Coal", color = "#e6194B", popup=paste("ORIS Code: ", gen_2018_IL$ORIS_CODE, "<br>",
                                                                                                                                     "Generation Capacity: ", gen_2018_IL$COAL_GEN)) %>%
      addCircles(~PLANT_LONG, ~PLANT_LAT, ~OIL_GEN/100, stroke = F, fillOpacity=0.3, group = "Oil", color = "#f58231", popup=paste("ORIS Code: ", gen_2018_IL$ORIS_CODE, "<br>",
                                                                                                                                   "Generation Capacity: ", gen_2018_IL$OIL_GEN)) %>%
      addCircles(~PLANT_LONG, ~PLANT_LAT, ~GAS_GEN/100, stroke = F, fillOpacity=0.4, group = "Gas", color = "#ffe119", popup=paste("ORIS Code: ", gen_2018_IL$ORIS_CODE, "<br>",
                                                                                                                                   "Generation Capacity: ", gen_2018_IL$GAS_GEN)) %>%
      addCircles(~PLANT_LONG, ~PLANT_LAT, ~NUCLEAR_GEN/100, stroke = F, fillOpacity=0.2, group = "Nuclear", color = "#bfef45", popup=paste("ORIS Code: ", gen_2018_IL$ORIS_CODE, "<br>",
                                                                                                                                           "Generation Capacity: ", gen_2018_IL$NUCLEAR_GEN)) %>%
      addCircles(~PLANT_LONG, ~PLANT_LAT, ~HYDRO_GEN/100, stroke = F, fillOpacity=0.3, group = "Hydro", color = "#3cb44b", popup=paste("ORIS Code: ", gen_2018_IL$ORIS_CODE, "<br>",
                                                                                                                                       "Generation Capacity: ", gen_2018_IL$HYDRO_GEN)) %>%
      addCircles(~PLANT_LONG, ~PLANT_LAT, ~BIOMASS_GEN/100, stroke = F, fillOpacity=0.3, group = "Biomass", color = "#42d4f4", popup=paste("ORIS Code: ", gen_2018_IL$ORIS_CODE, "<br>",
                                                                                                                                           "Generation Capacity: ", gen_2018_IL$BIOMASS_GEN)) %>%
      addCircles(~PLANT_LONG, ~PLANT_LAT, ~WIND_GEN/100, stroke = F, fillOpacity=0.3, group = "Wind", color = "#4363d8", popup=paste("ORIS Code: ", gen_2018_IL$ORIS_CODE, "<br>",
                                                                                                                                     "Generation Capacity: ", gen_2018_IL$WIND_GEN)) %>%
      addCircles(~PLANT_LONG, ~PLANT_LAT, ~SOLAR_GEN/100, stroke = F, fillOpacity=0.3, group = "Solar", color = "#911eb4", popup=paste("ORIS Code: ", gen_2018_IL$ORIS_CODE, "<br>",
                                                                                                                                       "Generation Capacity: ", gen_2018_IL$SOLAR_GEN)) %>%
      addCircles(~PLANT_LONG, ~PLANT_LAT, ~GEOTHERMAL_GEN/100, stroke = F, fillOpacity=0.3, group = "Geothermal", color = "#f032e6", popup=paste("ORIS Code: ", gen_2018_IL$ORIS_CODE, "<br>",
                                                                                                                                                 "Generation Capacity: ", gen_2018_IL$GEOTHERMAL_GEN)) %>%
      addCircles(~PLANT_LONG, ~PLANT_LAT, ~OTHER_FOSSIL_GEN/100, stroke = F, fillOpacity=0.3, group = "Other", color = "#a9a9a9", popup=paste("ORIS Code: ", gen_2018_IL$ORIS_CODE, "<br>",
                                                                                                                                              "Generation Capacity: ", gen_2018_IL$OTHER_GEN)) %>%
      addLegend("bottomright", colors= c("#e6194B", "#f58231","#ffe119" ,"#bfef45", "#3cb44b", "#42d4f4", "#4363d8", "#911eb4", "#f032e6", "#a9a9a9"), 
                labels=c("Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other"), title="Energy Source") %>%
      
      # Layers control
      addLayersControl(
        baseGroups = c("OSM (default)", "Toner", "Toner Lite"),
        overlayGroups = c("Coal", "Oil"),
        options = layersControlOptions(collapsed = FALSE)
      )
  })
  
  
  
  
}
 

