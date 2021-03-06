function(data, stateInput, energySourceInput) {
  gen_year_state <- subset(gen_2018, STATE == stateInput)
  
  
  slice_gen_year_state <- data.frame(matrix(ncol = 7, nrow = 0))
  slice_gen_year_state_col <- c("ORIS_CODE", "PLANT_LONG", "PLANT_LAT" , "GEN", "SOURCE", "U_PLANT_LONG", "U_PLANT_LONG")
  colnames(slice_gen_year_state) <- slice_gen_year_state_col
  slice_gen_year_state$PLANT_LONG <- as.double(slice_gen_year_state$PLANT_LONG)
  slice_gen_year_state$PLANT_LAT <- as.double(slice_gen_year_state$PLANT_LAT)
  slice_gen_year_state$GEN <- as.numeric(slice_gen_year_state$GEN)
  slice_gen_year_state$U_PLANT_LONG <- as.double(slice_gen_year_state$U_PLANT_LONG)
  slice_gen_year_state$U_PLANT_LONG <- as.double(slice_gen_year_state$U_PLANT_LONG)
  
  #Coal
  if("Coal" %in% energySourceInput) {
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
  if("Oil" %in% energySourceInput) {
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
  if("Gas" %in% energySourceInput) {
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
  if("Nuclear" %in% energySourceInput) {
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
  if("Hydro" %in% energySourceInput) {
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
  if("Biomass" %in% energySourceInput) {
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
  if("Wind" %in% energySourceInput) {
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
  if("Solar" %in% energySourceInput) {
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
  if("Geothermal" %in% energySourceInput) {
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
  if("Other" %in% energySourceInput) {
    energySourceInputList <- c("OTHER_GEN", as.list(energySourceInputList))
    
    other_plants_table <- gen_2018_IL[c("ORIS_CODE", "PLANT_LONG", "PLANT_LAT", "OTHER_GEN")]
    other_plants_table <- other_plants_table[!(is.na(other_plants_table$OTHER_GEN)),]
    names(other_plants_table)[names(other_plants_table) == "OTHER_GEN"] <- c("GEN")
    
    if(nrow(other_plants_table) > 0) {
      other_plants_table$SOURCE <- "Other"
      slice_gen_2018_IL <- rbind(slice_gen_2018_IL, other_plants_table)
    }
  }
}