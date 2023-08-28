library(dplyr)
library(here)
library(raster)
library(tmap)
library(tidyverse)
library(sf)
library(here)

# Load the level 6 hexagons for the whole AOI to join the indicators with
aoi_shape <- st_read(here("data/geopackages", "AOI_hex5.gpkg"))
                     
# Load all the indicators in hexagon format
conflict <- st_read(here("data/geopackages","AOI_hex5_ind1.gpkg")) # Conflict hotspots
malaria_prevalence <- st_read(here("data/geopackages","AOI_hex5_ind2.gpkg")) # Percentage change of malaria prevalence between 2013 and 2020
hf_walking <- st_read(here("data/geopackages","AOI_hex5_ind3.gpkg")) # Walking time to the nearest healthcare facility
pop_served <- st_read(here("data/geopackages","AOI_hex5_ind4.gpkg")) # Population served by one healthcare facility
precipitation_forecast <- st_read(here("data/geopackages","AOI_hex5_ind5.gpkg")) # Wet rainy season expected

# Show first 6 rows of all read datasets 
head(conflict)
head(hf_walking)
head(pop_served)
head(malaria_prevalence)
head(precipitation_forecast)

# Join all indicators into one dataset. 
conflict_drop <- st_drop_geometry(conflict)
aoi_shape <- merge(aoi_shape, conflict_drop, by = "h3_index") 

hf_walking_drop <- st_drop_geometry(hf_walking)
aoi_shape <- merge(aoi_shape, hf_walking_drop, by = "h3_index")

pop_served_drop <- st_drop_geometry(pop_served)
aoi_shape <- merge(aoi_shape, pop_served_drop, by = "h3_index")

malaria_prevalence_drop <- st_drop_geometry(malaria_prevalence)
aoi_shape <- merge(aoi_shape, malaria_prevalence_drop, by = "h3_index")

precipitation_forecast_drop <- st_drop_geometry(precipitation_forecast)
aoi_shape <- merge(aoi_shape, precipitation_forecast_drop, by = "h3_index")

# Renames the column names for clearer names
aoi_shape <- aoi_shape %>% 
  rename(
    conflict = hotspot_num,
    access = access.x,
    pop_served = pop_served_hex,
    malaria_prevalence = pf_hexa,
    prec_forecast = prec_risk
  )

# Removes one redundant column
aoi_shape <- subset(aoi_shape, select = -c(access.y))

# Shows the first 6 rows of the newly assembled dataset
head(aoi_shape)

# Writes the result into the databse
st_write(aoi_shape, here("data/geopackages", "AOI_hex5_all_indicators.gpkg"), append = FALSE)

#-------
# Normalize
# Min-max normalization into 8-bit interval

# Define the function to apply to each polygon and attribute
hexa_norm <- function(layer) {
  (layer - min(layer, na.rm = TRUE)) / (max(layer, na.rm = TRUE) - min(layer, na.rm = TRUE)) #* 254
}

# Applies the normalization function to each indicator and writes a new column for each
aoi_shape$norm_conflict <- hexa_norm(aoi_shape$conflict)
aoi_shape$norm_malaria_prevalence <- hexa_norm(aoi_shape$malaria_prevalence)
aoi_shape$norm_hf_walking <- hexa_norm(aoi_shape$access)
aoi_shape$norm_pop_served <- hexa_norm(aoi_shape$pop_served)
aoi_shape$norm_prec_fore <- hexa_norm(aoi_shape$prec_forecast)


# Calculates final risk layer
aoi_shape$final_risk <- (aoi_shape$norm_conflict + aoi_shape$norm_malaria_prevalence + aoi_shape$norm_hf_walking + aoi_shape$norm_pop_served + 
  aoi_shape$norm_prec_fore)/5

# Writes the final result to a dataset
st_write(aoi_shape, here("data/geopackages","All_indicators_final.gpkg"), append = FALSE)

# Plot normalized values
tmap_mode("view")

pal <- c('#60b564','#fed400')

conf <- tm_shape(aoi_shape) +
  tm_polygons(col = "conflict_norm", palette = pal, popup.vars = c("Conflict category"="conflict_norm")) +
  tm_borders(lwd = 0.2) + 
  tm_layout(title = "Conflict hotspots") + 
  tm_fill(col = '#BFE1F4') + 
  tm_borders(lwd = 1, col = "black") 

walk <- tm_shape(aoi_shape) +
  tm_polygons(col = "hf_walking_norm", palette = pal, id = "h3_index", popup.vars = c("Walking time"="hf_walking_norm")) +
  tm_borders(lwd = 0.2) + 
  tm_layout(title = "Walking time to nearest healthcare facility") + 
  tm_fill(col = '#BFE1F4') + 
  tm_borders(lwd = 1, col = "black") 

pop_ser <- tm_shape(aoi_shape) +
  tm_polygons(col = "pop_served_norm", palette = pal, id = "h3_index", popup.vars = c("Population served"="pop_served_norm")) +
  tm_borders(lwd = 0.2) + 
  tm_layout(title = "Population served by one healthcare facility") +
  tm_fill(col = '#BFE1F4') + 
  tm_borders(lwd = 1, col = "black")

mala <- tm_shape(aoi_shape) +
  tm_polygons(col = "malaria_prevalence_norm", palette = pal, id = "h3_index", popup.vars = c("Malaria incidence"="malaria_prevalence_norm")) +
  tm_borders(lwd = 0.2) + 
  tm_layout(title = "Malaria incidence change between 2013 - 2020") +
  tm_fill(col = '#BFE1F4') + 
  tm_borders(lwd = 1, col = "black")

# Visualize composite indicator as a map
fin <- tm_shape(aoi_shape) +
  tm_polygons(col = "final_risk", palette = pal, id = "h3_index", popup.vars = c("Final risk"="final_risk")) +
  tm_borders(lwd = 0.2) + 
  tm_layout(title = "Final risk") +
  tm_fill(col = '#BFE1F4') + 
  tm_borders(lwd = 1, col = "black")

x <- list(conf, walk, pop_ser, mala)

tmap_arrange(x, sync = TRUE)
