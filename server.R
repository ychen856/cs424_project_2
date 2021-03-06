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
    
    
    #melt column into multiple table
    gen_2018_IL <- subset(gen_2018, STATE=="IL")
    
    
    slice_gen_2018_IL <- data.frame(matrix(ncol = 7, nrow = 0))
    slice_gen_2018_IL_col <- c("ORIS_CODE", "PLANT_LONG", "PLANT_LAT" , "GEN", "SOURCE", "U_PLANT_LONG", "U_PLANT_LONG")
    colnames(slice_gen_2018_IL) <- slice_gen_2018_IL_col
    slice_gen_2018_IL$PLANT_LONG <- as.double(slice_gen_2018_IL$PLANT_LONG)
    slice_gen_2018_IL$PLANT_LAT <- as.double(slice_gen_2018_IL$PLANT_LAT)
    slice_gen_2018_IL$GEN <- as.numeric(slice_gen_2018_IL$GEN)
    slice_gen_2018_IL$U_PLANT_LONG <- as.double(slice_gen_2018_IL$U_PLANT_LONG)
    slice_gen_2018_IL$U_PLANT_LONG <- as.double(slice_gen_2018_IL$U_PLANT_LONG)
    
    #Coal
    if("Coal" %in% input$energySourceInput) {
      energySourceInputList <- c("COAL_GEN", as.list(energySourceInputList))
      
      coal_plants_table <- gen_2018_IL[c("ORIS_CODE", "PLANT_LONG", "PLANT_LAT", "COAL_GEN")]
      coal_plants_table<-coal_plants_table[!(is.na(coal_plants_table$COAL_GEN)),]
      names(coal_plants_table)[names(coal_plants_table) == "COAL_GEN"] <- c("GEN")
      
      if(nrow(coal_plants_table) > 0) {
        coal_plants_table$SOURCE <- "Coal"
        slice_gen_2018_IL <- rbind(slice_gen_2018_IL, coal_plants_table)
      }
    }
    
    #Oil
    if("Oil" %in% input$energySourceInput) {
      energySourceInputList <- c("OIL_GEN", as.list(energySourceInputList))
      
      oil_plants_table <- gen_2018_IL[c("ORIS_CODE", "PLANT_LONG", "PLANT_LAT", "OIL_GEN")]
      oil_plants_table <- oil_plants_table[!(is.na(oil_plants_table$OIL_GEN)),]
      names(oil_plants_table)[names(oil_plants_table) == "OIL_GEN"] <- c("GEN")
      
      if(nrow(oil_plants_table) > 0) {
        oil_plants_table$SOURCE <- "Oil"
        slice_gen_2018_IL <- rbind(slice_gen_2018_IL, oil_plants_table)
      }
    }
    
    #Gas
    if("Gas" %in% input$energySourceInput) {
      energySourceInputList <- c("GAS_GEN", as.list(energySourceInputList))
      
      gas_plants_table <- gen_2018_IL[c("ORIS_CODE", "PLANT_LONG", "PLANT_LAT", "GAS_GEN")]
      gas_plants_table <- gas_plants_table[!(is.na(gas_plants_table$GAS_GEN)),]
      names(gas_plants_table)[names(gas_plants_table) == "GAS_GEN"] <- c("GEN")
      
      if(nrow(gas_plants_table) > 0) {
        gas_plants_table$SOURCE <- "Gas"
        slice_gen_2018_IL <- rbind(slice_gen_2018_IL, gas_plants_table)
      }
    }
    
    #Nuclear
    if("Nuclear" %in% input$energySourceInput) {
      energySourceInputList <- c("NUCLEAR_GEN", as.list(energySourceInputList))
      
      nuclear_plants_table <- gen_2018_IL[c("ORIS_CODE", "PLANT_LONG", "PLANT_LAT", "NUCLEAR_GEN")]
      nuclear_plants_table <- nuclear_plants_table[!(is.na(nuclear_plants_table$NUCLEAR_GEN)),]
      names(nuclear_plants_table)[names(nuclear_plants_table) == "NUCLEAR_GEN"] <- c("GEN")
      
      if(nrow(nuclear_plants_table) > 0) {
        nuclear_plants_table$SOURCE <- "Nuclear"
        slice_gen_2018_IL <- rbind(slice_gen_2018_IL, nuclear_plants_table)
      }
    }
    
    #Hydro
    if("Hydro" %in% input$energySourceInput) {
      energySourceInputList <- c("HYDRO_GEN", as.list(energySourceInputList))
      
      hydro_plants_table <- gen_2018_IL[c("ORIS_CODE", "PLANT_LONG", "PLANT_LAT", "HYDRO_GEN")]
      hydro_plants_table <- hydro_plants_table[!(is.na(hydro_plants_table$HYDRO_GEN)),]
      names(hydro_plants_table)[names(hydro_plants_table) == "HYDRO_GEN"] <- c("GEN")
      
      if(nrow(hydro_plants_table) > 0) {
        hydro_plants_table$SOURCE <- "Hydro"
        slice_gen_2018_IL <- rbind(slice_gen_2018_IL, hydro_plants_table)
      }
    }
    
    #Biomass
    if("Biomass" %in% input$energySourceInput) {
      energySourceInputList <- c("BIOMASS_GEN", as.list(energySourceInputList))
      
      biomass_plants_table <- gen_2018_IL[c("ORIS_CODE", "PLANT_LONG", "PLANT_LAT", "BIOMASS_GEN")]
      biomass_plants_table <- biomass_plants_table[!(is.na(biomass_plants_table$BIOMASS_GEN)),]
      names(biomass_plants_table)[names(biomass_plants_table) == "BIOMASS_GEN"] <- c("GEN")
      
      if(nrow(biomass_plants_table) > 0) {
        biomass_plants_table$SOURCE <- "Biomass"
        slice_gen_2018_IL <- rbind(slice_gen_2018_IL, biomass_plants_table)
      }
    }
    
    #Wind
    if("Wind" %in% input$energySourceInput) {
      energySourceInputList <- c("WIND_GEN", as.list(energySourceInputList))
      
      wind_plants_table <- gen_2018_IL[c("ORIS_CODE", "PLANT_LONG", "PLANT_LAT", "WIND_GEN")]
      wind_plants_table <- wind_plants_table[!(is.na(wind_plants_table$WIND_GEN)),]
      names(wind_plants_table)[names(wind_plants_table) == "WIND_GEN"] <- c("GEN")
      
      if(nrow(wind_plants_table) > 0) {
        wind_plants_table$SOURCE <- "Wind"
        slice_gen_2018_IL <- rbind(slice_gen_2018_IL, wind_plants_table)
      }
    }
    
    #Solar
    if("Solar" %in% input$energySourceInput) {
      energySourceInputList <- c("SOLAR_GEN", as.list(energySourceInputList))
      
      solar_plants_table <- gen_2018_IL[c("ORIS_CODE", "PLANT_LONG", "PLANT_LAT", "SOLAR_GEN")]
      solar_plants_table <- solar_plants_table[!(is.na(solar_plants_table$SOLAR_GEN)),]
      names(solar_plants_table)[names(solar_plants_table) == "SOLAR_GEN"] <- c("GEN")
      
      if(nrow(solar_plants_table) > 0) {
        solar_plants_table$SOURCE <- "Solar"
        slice_gen_2018_IL <- rbind(slice_gen_2018_IL, solar_plants_table)
      }
    }
    
    #Geothermal
    if("Geothermal" %in% input$energySourceInput) {
      energySourceInputList <- c("GEOTHERMAL_GEN", as.list(energySourceInputList))
      
      geothermal_plants_table <- gen_2018_IL[c("ORIS_CODE", "PLANT_LONG", "PLANT_LAT", "GEOTHERMAL_GEN")]
      geothermal_plants_table <- geothermal_plants_table[!(is.na(geothermal_plants_table$GEOTHERMAL_GEN)),]
      names(geothermal_plants_table)[names(geothermal_plants_table) == "GEOTHERMAL_GEN"] <- c("GEN")
      
      if(nrow(geothermal_plants_table) > 0) {
        geothermal_plants_table$SOURCE <- "Geothermal"
        slice_gen_2018_IL <- rbind(slice_gen_2018_IL, geothermal_plants_table)
      }
    }
    
    #Other
    if("Other" %in% input$energySourceInput) {
      energySourceInputList <- c("OTHER_GEN", as.list(energySourceInputList))
      
      other_plants_table <- gen_2018_IL[c("ORIS_CODE", "PLANT_LONG", "PLANT_LAT", "OTHER_GEN")]
      other_plants_table <- other_plants_table[!(is.na(other_plants_table$OTHER_GEN)),]
      names(other_plants_table)[names(other_plants_table) == "OTHER_GEN"] <- c("GEN")
      
      if(nrow(other_plants_table) > 0) {
        other_plants_table$SOURCE <- "Other"
        slice_gen_2018_IL <- rbind(slice_gen_2018_IL, other_plants_table)
      }
    }

    #print(slice_gen_2018_IL)
    #order generation, let smaller circle at the top layer
    slice_gen_2018_IL[order(slice_gen_2018_IL$GEN),]
    
    slice_gen_2018_IL$U_PLANT_LAT <- jitter(slice_gen_2018_IL$PLANT_LAT, factor = 0.1)
    slice_gen_2018_IL$U_PLANT_LONG <- jitter(slice_gen_2018_IL$PLANT_LONG, factor = 0.1)
    
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
  
  
  
  })

}
 

