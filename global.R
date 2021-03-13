library(stringr)

################### read file ####################
#2018
gen_2018 <- read.csv("egrid2018_data_v2_adj.csv", sep = ",", header = TRUE)
gen_2018 <- gen_2018[-c(6:18, 22:107, 121:123, 137:139)]
gen_2018 <- gen_2018[-c(1), ]
names(gen_2018)[1] <- c("SEQ")
names(gen_2018)[2] <- c("YEAR")
names(gen_2018)[3] <- c("STATE")
names(gen_2018)[4] <- c("PLANT_NAME")
names(gen_2018)[5] <- c("ORIS_CODE")
names(gen_2018)[6] <- c("COUNTY")
names(gen_2018)[7] <- c("PLANT_LAT")
names(gen_2018)[8] <- c("PLANT_LONG")

names(gen_2018)[9] <- c("COAL_GEN")
names(gen_2018)[10] <- c("OIL_GEN")
names(gen_2018)[11] <- c("GAS_GEN")
names(gen_2018)[12] <- c("NUCLEAR_GEN")
names(gen_2018)[13] <- c("HYDRO_GEN")
names(gen_2018)[14] <- c("BIOMASS_GEN")
names(gen_2018)[15] <- c("WIND_GEN")
names(gen_2018)[16] <- c("SOLAR_GEN")
names(gen_2018)[17] <- c("GEOTHERMAL_GEN")
names(gen_2018)[18] <- c("OTHER_FOSSIL_GEN")
names(gen_2018)[19] <- c("OTHER_UNKNOWN_GEN")
names(gen_2018)[20] <- c("TOTAL_NONRENEWABLE_GEN")
names(gen_2018)[21] <- c("TOTAL_RENEWABLE_GEN")

names(gen_2018)[22] <- c("COAL_PER")
names(gen_2018)[23] <- c("OIL_PER")
names(gen_2018)[24] <- c("GAS_PER")
names(gen_2018)[25] <- c("NUCLEAR_PER")
names(gen_2018)[26] <- c("HYDRO_PER")
names(gen_2018)[27] <- c("BIOMASS_PER")
names(gen_2018)[28] <- c("WIND_PER")
names(gen_2018)[29] <- c("SOLAR_PER")
names(gen_2018)[30] <- c("GEOTHERMAL_PER")
names(gen_2018)[31] <- c("OTHER_FOSSIL_PER")
names(gen_2018)[32] <- c("OTHER_UNKNOWN_PER")
names(gen_2018)[33] <- c("TOTAL_NONRENEWABLE_PER")
names(gen_2018)[34] <- c("TOTAL_RENEWABLE_PER")


#2000
gen_2000 <- read.csv("eGRID2000_plant_adj.csv", sep = ",", header = TRUE)
gen_2000 <- gen_2000[-c(2, 6:22, 26:68, 82, 96:155)]
gen_2000 <- gen_2000[-c(1:3), ]
names(gen_2000)[1] <- c("SEQ")
names(gen_2000)[2] <- c("STATE")
names(gen_2000)[3] <- c("PLANT_NAME")
names(gen_2000)[4] <- c("ORIS_CODE")
names(gen_2000)[5] <- c("COUNTY")
names(gen_2000)[6] <- c("PLANT_LAT")
names(gen_2000)[7] <- c("PLANT_LONG")

names(gen_2000)[8] <- c("COAL_GEN")
names(gen_2000)[9] <- c("OIL_GEN")
names(gen_2000)[10] <- c("GAS_GEN")
names(gen_2000)[11] <- c("NUCLEAR_GEN")
names(gen_2000)[12] <- c("HYDRO_GEN")
names(gen_2000)[13] <- c("BIOMASS_GEN")
names(gen_2000)[14] <- c("WIND_GEN")
names(gen_2000)[15] <- c("SOLAR_GEN")
names(gen_2000)[16] <- c("GEOTHERMAL_GEN")
names(gen_2000)[17] <- c("OTHER_FOSSIL_GEN")
names(gen_2000)[18] <- c("OTHER_WASTE_GEN")
names(gen_2000)[19] <- c("TOTAL_NONRENEWABLE_GEN")
names(gen_2000)[20] <- c("TOTAL_RENEWABLE_GEN")

names(gen_2000)[21] <- c("COAL_PER")
names(gen_2000)[22] <- c("OIL_PER")
names(gen_2000)[23] <- c("GAS_PER")
names(gen_2000)[24] <- c("NUCLEAR_PER")
names(gen_2000)[25] <- c("HYDRO_PER")
names(gen_2000)[26] <- c("BIOMASS_PER")
names(gen_2000)[27] <- c("WIND_PER")
names(gen_2000)[28] <- c("SOLAR_PER")
names(gen_2000)[29] <- c("GEOTHERMAL_PER")
names(gen_2000)[30] <- c("OTHER_FOSSIL_PER")
names(gen_2000)[31] <- c("OTHER_WASTE_PER")
names(gen_2000)[32] <- c("TOTAL_NONRENEWABLE_PER")
names(gen_2000)[33] <- c("TOTAL_RENEWABLE_PER")


#2010
gen_2010 <- read.csv("eGRID2010_Data_adj.csv", sep = ",", header = TRUE)
gen_2010 <- gen_2010[-c(5:19, 23:81, 95:97, 111:165)]
gen_2010 <- gen_2010[-c(1:4), ]
names(gen_2010)[1] <- c("SEQ")
names(gen_2010)[2] <- c("STATE")
names(gen_2010)[3] <- c("PLANT_NAME")
names(gen_2010)[4] <- c("ORIS_CODE")
names(gen_2010)[5] <- c("COUNTY")
names(gen_2010)[6] <- c("PLANT_LAT")
names(gen_2010)[7] <- c("PLANT_LONG")

names(gen_2010)[8] <- c("COAL_GEN")
names(gen_2010)[9] <- c("OIL_GEN")
names(gen_2010)[10] <- c("GAS_GEN")
names(gen_2010)[11] <- c("NUCLEAR_GEN")
names(gen_2010)[12] <- c("HYDRO_GEN")
names(gen_2010)[13] <- c("BIOMASS_GEN")
names(gen_2010)[14] <- c("WIND_GEN")
names(gen_2010)[15] <- c("SOLAR_GEN")
names(gen_2010)[16] <- c("GEOTHERMAL_GEN")
names(gen_2010)[17] <- c("OTHER_FOSSIL_GEN")
names(gen_2010)[18] <- c("OTHER_UNKNOWN_GEN")
names(gen_2010)[19] <- c("TOTAL_NONRENEWABLE_GEN")
names(gen_2010)[20] <- c("TOTAL_RENEWABLE_GEN")

names(gen_2010)[21] <- c("COAL_PER")
names(gen_2010)[22] <- c("OIL_PER")
names(gen_2010)[23] <- c("GAS_PER")
names(gen_2010)[24] <- c("NUCLEAR_PER")
names(gen_2010)[25] <- c("HYDRO_PER")
names(gen_2010)[26] <- c("BIOMASS_PER")
names(gen_2010)[27] <- c("WIND_PER")
names(gen_2010)[28] <- c("SOLAR_PER")
names(gen_2010)[29] <- c("GEOTHERMAL_PER")
names(gen_2010)[30] <- c("OTHER_FOSSIL_PER")
names(gen_2010)[31] <- c("OTHER_UNKNOWN_PER")
names(gen_2010)[32] <- c("TOTAL_NONRENEWABLE_PER")
names(gen_2010)[33] <- c("TOTAL_RENEWABLE_PER")



################### Data modification ##################
#2018
gen_2018$PLANT_LAT <- as.double(gen_2018$PLANT_LAT)
gen_2018$PLANT_LONG <- as.double(gen_2018$PLANT_LONG)

gen_2018$COAL_GEN <- sub("^-", "^$", gen_2018$COAL_GEN)
gen_2018$OIL_GEN <- sub("^-", "^$", gen_2018$OIL_GEN)
gen_2018$GAS_GEN <- sub("^-", "^$", gen_2018$GAS_GEN)
gen_2018$NUCLEAR_GEN <- sub("^-", "^$", gen_2018$NUCLEAR_GEN)
gen_2018$HYDRO_GEN <- sub("^-", "^$", gen_2018$HYDRO_GEN)
gen_2018$BIOMASS_GEN <- sub("^-", "^$", gen_2018$BIOMASS_GEN)
gen_2018$WIND_GEN <- sub("^-", "^$", gen_2018$WIND_GEN)
gen_2018$SOLAR_GEN <- sub("^-", "^$", gen_2018$SOLAR_GEN)
gen_2018$GEOTHERMAL_GEN <- sub("^-", "^$", gen_2018$GEOTHERMAL_GEN)
gen_2018$OTHER_FOSSIL_GEN <- sub("^-", "^$", gen_2018$OTHER_FOSSIL_GEN)
gen_2018$OTHER_UNKNOWN_GEN <- sub("^-", "^$", gen_2018$OTHER_UNKNOWN_GEN)
gen_2018$TOTAL_NONRENEWABLE_GEN <- sub("^-", "^$", gen_2018$TOTAL_NONRENEWABLE_GEN)
gen_2018$TOTAL_RENEWABLE_GEN <- sub("^-", "^$", gen_2018$TOTAL_RENEWABLE_GEN)

gen_2018$COAL_GEN <- as.numeric(gsub(",", "", gen_2018$COAL_GEN))
gen_2018$OIL_GEN <- as.numeric(gsub(",", "", gen_2018$OIL_GEN))
gen_2018$GAS_GEN <- as.numeric(gsub(",", "", gen_2018$GAS_GEN))
gen_2018$NUCLEAR_GEN <- as.numeric(gsub(",", "", gen_2018$NUCLEAR_GEN))
gen_2018$HYDRO_GEN <- as.numeric(gsub(",", "", gen_2018$HYDRO_GEN))
gen_2018$BIOMASS_GEN <- as.numeric(gsub(",", "", gen_2018$BIOMASS_GEN))
gen_2018$WIND_GEN <- as.numeric(gsub(",", "", gen_2018$WIND_GEN))
gen_2018$SOLAR_GEN <- as.numeric(gsub(",", "", gen_2018$SOLAR_GEN))
gen_2018$GEOTHERMAL_GEN <- as.numeric(gsub(",", "", gen_2018$GEOTHERMAL_GEN))
gen_2018$OTHER_FOSSIL_GEN <- as.numeric(gsub(",", "", gen_2018$OTHER_FOSSIL_GEN))
gen_2018$OTHER_UNKNOWN_GEN <- as.numeric(gsub(",", "", gen_2018$OTHER_UNKNOWN_GEN))
gen_2018$TOTAL_NONRENEWABLE_GEN <- as.numeric(gsub(",", "", gen_2018$TOTAL_NONRENEWABLE_GEN))
gen_2018$TOTAL_RENEWABLE_GEN <- as.numeric(gsub(",", "", gen_2018$TOTAL_RENEWABLE_GEN))

gen_2018$TOTAL_RENEWABLE_PER <- as.numeric(gsub(",", "", gsub("%", "", gen_2018$TOTAL_RENEWABLE_PER)))
gen_2018$TOTAL_NONRENEWABLE_PER <- as.numeric(gsub(",", "", gsub("%", "", gen_2018$TOTAL_NONRENEWABLE_PER)))

gen_2018$OTHER_GEN <- (gen_2018$OTHER_FOSSIL_GEN + gen_2018$OTHER_UNKNOWN_GEN)

gen_2018$COAL_GEN <- ifelse(gen_2018$COAL_GEN == 0, NA, gen_2018$COAL_GEN)
gen_2018$OIL_GEN <- ifelse(gen_2018$OIL_GEN == 0, NA, gen_2018$OIL_GEN)
gen_2018$GAS_GEN <- ifelse(gen_2018$GAS_GEN == 0, NA, gen_2018$GAS_GEN)
gen_2018$NUCLEAR_GEN <- ifelse(gen_2018$NUCLEAR_GEN == 0, NA, gen_2018$NUCLEAR_GEN)
gen_2018$HYDRO_GEN <- ifelse(gen_2018$HYDRO_GEN == 0, NA, gen_2018$HYDRO_GEN)
gen_2018$BIOMASS_GEN <- ifelse(gen_2018$BIOMASS_GEN == 0, NA, gen_2018$BIOMASS_GEN)
gen_2018$WIND_GEN <- ifelse(gen_2018$WIND_GEN == 0, NA, gen_2018$WIND_GEN)
gen_2018$SOLAR_GEN <- ifelse(gen_2018$SOLAR_GEN == 0, NA, gen_2018$SOLAR_GEN)
gen_2018$GEOTHERMAL_GEN <- ifelse(gen_2018$GEOTHERMAL_GEN == 0, NA, gen_2018$GEOTHERMAL_GEN)
gen_2018$OTHER_FOSSIL_GEN <- ifelse(gen_2018$OTHER_FOSSIL_GEN == 0, NA, gen_2018$OTHER_FOSSIL_GEN)
gen_2018$OTHER_UNKNOWN_GEN <- ifelse(gen_2018$OTHER_UNKNOWN_GEN == 0, NA, gen_2018$OTHER_UNKNOWN_GEN)
gen_2018$TOTAL_NONRENEWABLE_GEN <- ifelse(gen_2018$TOTAL_NONRENEWABLE_GEN == 0, NA, gen_2018$TOTAL_NONRENEWABLE_GEN)
gen_2018$TOTAL_RENEWABLE_GEN <- ifelse(gen_2018$TOTAL_RENEWABLE_GEN == 0, NA, gen_2018$TOTAL_RENEWABLE_GEN)
gen_2018$OTHER_GEN <- ifelse(gen_2018$OTHER_GEN == 0, NA, gen_2018$OTHER_GEN)

#2000
gen_2000$PLANT_LAT <- as.double(gen_2000$PLANT_LAT)
gen_2000$PLANT_LONG <- as.double(gen_2000$PLANT_LONG)
gen_2000$PLANT_LONG <- gen_2000$PLANT_LONG * -1

gen_2000$COAL_GEN <- sub("^-", "^$", gen_2000$COAL_GEN)
gen_2000$OIL_GEN <- sub("^-", "^$", gen_2000$OIL_GEN)
gen_2000$GAS_GEN <- sub("^-", "^$", gen_2000$GAS_GEN)
gen_2000$NUCLEAR_GEN <- sub("^-", "^$", gen_2000$NUCLEAR_GEN)
gen_2000$HYDRO_GEN <- sub("^-", "^$", gen_2000$HYDRO_GEN)
gen_2000$BIOMASS_GEN <- sub("^-", "^$", gen_2000$BIOMASS_GEN)
gen_2000$WIND_GEN <- sub("^-", "^$", gen_2000$WIND_GEN)
gen_2000$SOLAR_GEN <- sub("^-", "^$", gen_2000$SOLAR_GEN)
gen_2000$GEOTHERMAL_GEN <- sub("^-", "^$", gen_2000$GEOTHERMAL_GEN)
gen_2000$OTHER_FOSSIL_GEN <- sub("^-", "^$", gen_2000$OTHER_FOSSIL_GEN)
gen_2000$OTHER_WASTE_GEN <- sub("^-", "^$", gen_2000$OTHER_WASTE_GEN)
gen_2000$TOTAL_NONRENEWABLE_GEN <- sub("^-", "^$", gen_2000$TOTAL_NONRENEWABLE_GEN)
gen_2000$TOTAL_RENEWABLE_GEN <- sub("^-", "^$", gen_2000$TOTAL_RENEWABLE_GEN)

gen_2000$COAL_GEN <- as.numeric(gsub(",", "", gen_2000$COAL_GEN))
gen_2000$OIL_GEN <- as.numeric(gsub(",", "", gen_2000$OIL_GEN))
gen_2000$GAS_GEN <- as.numeric(gsub(",", "", gen_2000$GAS_GEN))
gen_2000$NUCLEAR_GEN <- as.numeric(gsub(",", "", gen_2000$NUCLEAR_GEN))
gen_2000$HYDRO_GEN <- as.numeric(gsub(",", "", gen_2000$HYDRO_GEN))
gen_2000$BIOMASS_GEN <- as.numeric(gsub(",", "", gen_2000$BIOMASS_GEN))
gen_2000$WIND_GEN <- as.numeric(gsub(",", "", gen_2000$WIND_GEN))
gen_2000$SOLAR_GEN <- as.numeric(gsub(",", "", gen_2000$SOLAR_GEN))
gen_2000$GEOTHERMAL_GEN <- as.numeric(gsub(",", "", gen_2000$GEOTHERMAL_GEN))
gen_2000$OTHER_FOSSIL_GEN <- as.numeric(gsub(",", "", gen_2000$OTHER_FOSSIL_GEN))
gen_2000$OTHER_WASTE_GEN <- as.numeric(gsub(",", "", gen_2000$OTHER_WASTE_GEN))
gen_2000$TOTAL_NONRENEWABLE_GEN <- as.numeric(gsub(",", "", gen_2000$TOTAL_NONRENEWABLE_GEN))
gen_2000$TOTAL_RENEWABLE_GEN <- as.numeric(gsub(",", "", gen_2000$TOTAL_RENEWABLE_GEN))

gen_2000$TOTAL_RENEWABLE_PER <- as.numeric(gsub(",", "", gen_2000$TOTAL_RENEWABLE_PER))
gen_2000$TOTAL_NONRENEWABLE_PER <- as.numeric(gsub(",", "", gen_2000$TOTAL_NONRENEWABLE_PER))

gen_2000$OTHER_GEN <- (gen_2000$OTHER_FOSSIL_GEN + gen_2000$OTHER_WASTE_GEN)

gen_2000$COAL_GEN <- ifelse(gen_2000$COAL_GEN == 0, NA, gen_2000$COAL_GEN)
gen_2000$OIL_GEN <- ifelse(gen_2000$OIL_GEN == 0, NA, gen_2000$OIL_GEN)
gen_2000$GAS_GEN <- ifelse(gen_2000$GAS_GEN == 0, NA, gen_2000$GAS_GEN)
gen_2000$NUCLEAR_GEN <- ifelse(gen_2000$NUCLEAR_GEN == 0, NA, gen_2000$NUCLEAR_GEN)
gen_2000$HYDRO_GEN <- ifelse(gen_2000$HYDRO_GEN == 0, NA, gen_2000$HYDRO_GEN)
gen_2000$BIOMASS_GEN <- ifelse(gen_2000$BIOMASS_GEN == 0, NA, gen_2000$BIOMASS_GEN)
gen_2000$WIND_GEN <- ifelse(gen_2000$WIND_GEN == 0, NA, gen_2000$WIND_GEN)
gen_2000$SOLAR_GEN <- ifelse(gen_2000$SOLAR_GEN == 0, NA, gen_2000$SOLAR_GEN)
gen_2000$GEOTHERMAL_GEN <- ifelse(gen_2000$GEOTHERMAL_GEN == 0, NA, gen_2000$GEOTHERMAL_GEN)
gen_2000$OTHER_FOSSIL_GEN <- ifelse(gen_2000$OTHER_FOSSIL_GEN == 0, NA, gen_2000$OTHER_FOSSIL_GEN)
gen_2000$OTHER_WASTE_GEN <- ifelse(gen_2000$OTHER_WASTE_GEN == 0, NA, gen_2000$OTHER_WASTE_GEN)
gen_2000$TOTAL_NONRENEWABLE_GEN <- ifelse(gen_2000$TOTAL_NONRENEWABLE_GEN == 0, NA, gen_2000$TOTAL_NONRENEWABLE_GEN)
gen_2000$TOTAL_RENEWABLE_GEN <- ifelse(gen_2000$TOTAL_RENEWABLE_GEN == 0, NA, gen_2000$TOTAL_RENEWABLE_GEN)
gen_2000$OTHER_GEN <- ifelse(gen_2000$OTHER_GEN == 0, NA, gen_2000$OTHER_GEN)

gen_2000$ORIS_CODE = substr(gen_2000$ORIS_CODE,1,nchar(gen_2000$ORIS_CODE)-2)

#2010
gen_2010$PLANT_LAT <- as.double(gen_2010$PLANT_LAT)
gen_2010$PLANT_LONG <- as.double(gen_2010$PLANT_LONG)

gen_2010$COAL_GEN <- as.numeric(gsub(",", "", gen_2010$COAL_GEN))
gen_2010$OIL_GEN <- as.numeric(gsub(",", "", gen_2010$OIL_GEN))
gen_2010$GAS_GEN <- as.numeric(gsub(",", "", gen_2010$GAS_GEN))
gen_2010$NUCLEAR_GEN <- as.numeric(gsub(",", "", gen_2010$NUCLEAR_GEN))
gen_2010$HYDRO_GEN <- as.numeric(gsub(",", "", gen_2010$HYDRO_GEN))
gen_2010$BIOMASS_GEN <- as.numeric(gsub(",", "", gen_2010$BIOMASS_GEN))
gen_2010$WIND_GEN <- as.numeric(gsub(",", "", gen_2010$WIND_GEN))
gen_2010$SOLAR_GEN <- as.numeric(gsub(",", "", gen_2010$SOLAR_GEN))
gen_2010$GEOTHERMAL_GEN <- as.numeric(gsub(",", "", gen_2010$GEOTHERMAL_GEN))
gen_2010$OTHER_FOSSIL_GEN <- as.numeric(gsub(",", "", gen_2010$OTHER_FOSSIL_GEN))
gen_2010$OTHER_UNKNOWN_GEN <- as.numeric(gsub(",", "", gen_2010$OTHER_UNKNOWN_GEN))
gen_2010$TOTAL_NONRENEWABLE_GEN <- as.numeric(gsub(",", "", gen_2010$TOTAL_NONRENEWABLE_GEN))
gen_2010$TOTAL_RENEWABLE_GEN <- as.numeric(gsub(",", "", gen_2010$TOTAL_RENEWABLE_GEN))

gen_2010$TOTAL_RENEWABLE_PER <- as.numeric(gsub(",", "", gen_2010$TOTAL_RENEWABLE_PER))
gen_2010$TOTAL_NONRENEWABLE_PER <- as.numeric(gsub(",", "", gen_2010$TOTAL_NONRENEWABLE_PER))

gen_2010$OTHER_GEN <- (gen_2010$OTHER_FOSSIL_GEN + gen_2010$OTHER_UNKNOWN_GEN)

gen_2010$COAL_GEN <- ifelse(gen_2010$COAL_GEN == 0, NA, gen_2010$COAL_GEN)
gen_2010$OIL_GEN <- ifelse(gen_2010$OIL_GEN == 0, NA, gen_2010$OIL_GEN)
gen_2010$GAS_GEN <- ifelse(gen_2010$GAS_GEN == 0, NA, gen_2010$GAS_GEN)
gen_2010$NUCLEAR_GEN <- ifelse(gen_2010$NUCLEAR_GEN == 0, NA, gen_2010$NUCLEAR_GEN)
gen_2010$HYDRO_GEN <- ifelse(gen_2010$HYDRO_GEN == 0, NA, gen_2010$HYDRO_GEN)
gen_2010$BIOMASS_GEN <- ifelse(gen_2010$BIOMASS_GEN == 0, NA, gen_2010$BIOMASS_GEN)
gen_2010$WIND_GEN <- ifelse(gen_2010$WIND_GEN == 0, NA, gen_2010$WIND_GEN)
gen_2010$SOLAR_GEN <- ifelse(gen_2010$SOLAR_GEN == 0, NA, gen_2010$SOLAR_GEN)
gen_2010$GEOTHERMAL_GEN <- ifelse(gen_2010$GEOTHERMAL_GEN == 0, NA, gen_2010$GEOTHERMAL_GEN)
gen_2010$OTHER_FOSSIL_GEN <- ifelse(gen_2010$OTHER_FOSSIL_GEN == 0, NA, gen_2010$OTHER_FOSSIL_GEN)
gen_2010$OTHER_UNKNOWN_GEN <- ifelse(gen_2010$OTHER_UNKNOWN_GEN == 0, NA, gen_2010$OTHER_UNKNOWN_GEN)
gen_2010$TOTAL_NONRENEWABLE_GEN <- ifelse(gen_2010$TOTAL_NONRENEWABLE_GEN == 0, NA, gen_2010$TOTAL_NONRENEWABLE_GEN)
gen_2010$TOTAL_RENEWABLE_GEN <- ifelse(gen_2010$TOTAL_RENEWABLE_GEN == 0, NA, gen_2010$TOTAL_RENEWABLE_GEN)
gen_2010$OTHER_GEN <- ifelse(gen_2010$OTHER_GEN == 0, NA, gen_2010$OTHER_GEN)


gen_2010$ORIS_CODE = substr(gen_2010$ORIS_CODE,1,nchar(gen_2010$ORIS_CODE)-2)

####################### idle & new ###########################
#2018
new_2018 <- subset(gen_2018, !(ORIS_CODE %in% gen_2010$ORIS_CODE))
old_2018 <- subset(gen_2018, (ORIS_CODE %in% gen_2010$ORIS_CODE))
idle_2018 <- subset(gen_2010, !(ORIS_CODE %in% gen_2018$ORIS_CODE))

#2010
new_2010 <- subset(gen_2010, !(ORIS_CODE %in% gen_2000$ORIS_CODE))
old_2010 <- subset(gen_2010, (ORIS_CODE %in% gen_2000$ORIS_CODE))
idle_2010 <- subset(gen_2000, !(ORIS_CODE %in% gen_2010$ORIS_CODE))


######################## input list ##########################
energySource_dist <- c("Select All", "Select Renewable", "Select nonRenewable", "Coal", "Oil", "Gas", "Nuclear", "Hydro", "Biomass", "Wind", "Solar", "Geothermal", "Other")
year_dist <- c("2000", "2010", "2018")
state_dist <- state.name
map_dist <- c("Light", "Dark", "Terrain")

source_idle_new <- c("New Plants", "Idle Plants")

####################### state location ########################
state_location <- data.frame (state  = c("US", "AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA","MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"),
                  longtitude = c(-94.6, -86.902298, -153.369141, -111.093735, -92.199997, -119.417931, -105.358887, -72.699997, -75.5, -81.760254, -83.441162, -155.844437, -114.742043, -89, -86.126976, -93.581543, -98, -85.270020, -92.329102, -68.972168, -76.641273, -71.382439, -84.506836, -94.636230, -90, -92.603760, -109.533691, -100, -117.224121, -71.5, -74.871826, -106.018066, -75, -80.793457, -100.437012, -82.996216, -96.921387, -120.5, -77.194527, -71.5, -81.163727,-100,-86.660156, -100, -111.950684, -72.699997, -78.024902, -120.740135, -80.5, -89, -107.290283),
                  latitude = c(39, 32.318230, 66.160507, 34.048927, 34.799999, 36.778259, 39.113014, 41.599998, 39, 27.994402, 33.247875, 19.741755, 44.068203, 40, 40.273502, 42.032974, 38.5, 37.839333, 30.391830, 45.367584, 39.045753, 42.407211, 44.182205, 46.392410, 33, 38.573936, 46.965260, 41.5, 39.876019, 44, 39.833851, 34.307144, 43, 35.782169, 47.650589	, 40.367474, 36.084621, 44, 41.203323, 41.700001, 33.836082, 44.500000, 35.860119, 31, 39.419220, 44.000000, 37.926868, 47.751076, 39, 44.5, 43.075970),
                  zoom = c(5, 7, 5, 6, 7, 6, 7, 9, 8, 6, 7, 7, 6, 6.5, 7, 7, 6.5, 6.5, 6.5, 6.5, 6.5, 7.5, 6, 6, 7, 6.5, 6, 6, 6, 8, 8, 7, 6.5, 6.5, 7, 7, 7, 7, 6.5, 9, 7, 6.5, 6, 6, 7, 8, 7, 6.5, 7, 7, 6)
)



