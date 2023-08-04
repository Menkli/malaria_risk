library(dplyr)
library(here)
library(raster)
library(tmap)

# Load the level 6 hexagons for the whole AOI to join the indicators with
aoi_shape <- st_read(here("data/geopackages", "AOI_hex5.gpkg"))
                     
names(aoi_shape)

# Load all the indicators in hexagon format
conflict <- st_read(here("data/geopackages","AOI_hex5_ind1.gpkg")) # Conflict hotspots
malaria_prevalence <- st_read(here("data/geopackages","AOI_hex5_ind2.gpkg")) # Percentage change of malaria prevalence between 2013 and 2020
hf_walking <- st_read(here("data/geopackages","AOI_hex5_ind3.gpkg")) # Walking time to the nearest healthcare facility
pop_served <- st_read(here("data/geopackages","AOI_hex5_ind4.gpkg")) # Population served by one healthcare facility
precipitation_forecast <- st_read(here("data/geopackages","AOI_hex5_ind5.gpkg")) # Wet rainy season expected

head(conflict)
head(hf_walking)
head(pop_served)
head(malaria_prevalence)
head(precipitation_forecast)

# Join all indicators into one dataset. Since they are all based on the same hexagons, we can just simply write the column holding the indicator values 
# to the shape object. If this wasn't the case, we would have to merger the data based on a shared column, such as the h3_index column. 
aoi_shape$conflict <- conflict$hotspot_num
aoi_shape$hf_walking <- hf_walking$access
aoi_shape$pop_served <- pop_served$pop_served_hex
aoi_shape$malaria_prevalence <- malaria_prevalence$pf_hexa
aoi_shape$prec_forecast <- precipitation_forecast$prec_risk

head(aoi_shape)

#plot(aoi_shape)

# Write the result into the databse
st_write(aoi_shape, here("data/geopackages", "AOI_hex5_all_indicators.gpkg"), append = FALSE)

#-------
# Normalize
# Min-max normalization into 8-bit interval

# Define the function to apply to each polygon and attribute
hexa_norm <- function(layer) {
  (layer - min(layer, na.rm = TRUE)) / (max(layer, na.rm = TRUE) - min(layer, na.rm = TRUE)) #* 254
}

# apply(st_drop_geometry(indic_vect[, 2:5]), 2, hexa_norm)
aoi_shape$norm_conflict <- hexa_norm(aoi_shape$conflict)
aoi_shape$norm_malaria_prevalence <- hexa_norm(aoi_shape$malaria_prevalence)
aoi_shape$norm_hf_walking <- hexa_norm(aoi_shape$hf_walking)
aoi_shape$norm_pop_served <- hexa_norm(aoi_shape$pop_served)
aoi_shape$norm_prec_fore <- hexa_norm(aoi_shape$prec_forecast)

# indic_vect$conflict_norm[is.na(indic_vect$conflict_norm)] <- 255
# indic_vect$hf_walking_norm [is.na(indic_vect$hf_walking_norm )] <- 255
# indic_vect$pop_served_norm[is.na(indic_vect$pop_served_norm)] <- 255
# indic_vect$malaria_prevalence_norm[is.na(indic_vect$malaria_prevalence_norm )] <- 255

st_write(aoi_shape, here("data/geopackages","All_indicators_final.gpkg"))

hist(aoi_shape$norm_conflict)
hist(aoi_shape$norm_malaria_prevalence)
hist(aoi_shape$norm_hf_walking)
hist(aoi_shape$norm_pop_served)
hist(aoi_shape$norm_prec_fore)

# Plot normalized values
tmap_mode("view")

pal <- c('#60b564','#fed400')

conf <- tm_shape(aoi_shape) +
  tm_polygons(col = "conflict_norm", palette = pal, popup.vars = c("Conflict category"="conflict_norm")) +
  tm_borders(lwd = 0.2) + 
  tm_layout(title = "Conflict hotspots") + 
  tm_fill(col = '#BFE1F4') + 
  tm_borders(lwd = 1, col = "black") 

walk <- tm_shape(indic_vect) +
  tm_polygons(col = "hf_walking_norm", palette = pal, id = "h3_index", popup.vars = c("Walking time"="hf_walking_norm")) +
  tm_borders(lwd = 0.2) + 
  tm_layout(title = "Walking time to nearest healthcare facility") + 
  tm_fill(col = '#BFE1F4') + 
  tm_borders(lwd = 1, col = "black") 

pop_ser <- tm_shape(indic_vect) +
  tm_polygons(col = "pop_served_norm", palette = pal, id = "h3_index", popup.vars = c("Population served"="pop_served_norm")) +
  tm_borders(lwd = 0.2) + 
  tm_layout(title = "Population served by one healthcare facility") +
  tm_fill(col = '#BFE1F4') + 
  tm_borders(lwd = 1, col = "black")

# Visualize composite indicator as a map
mala <- tm_shape(indic_vect) +
  tm_polygons(col = "malaria_prevalence_norm", palette = pal, id = "h3_index", popup.vars = c("Malaria incidence"="malaria_prevalence_norm")) +
  tm_borders(lwd = 0.2) + 
  tm_layout(title = "Malaria incidence change between 2013 - 2020") +
  tm_fill(col = '#BFE1F4') + 
  tm_borders(lwd = 1, col = "black")

x <- list(conf, walk, pop_ser, mala)

tmap_arrange(x, sync = TRUE)


# # Rasterize
# raster <- raster(here("data", "perc_aoi_brick_90_19.tif"))
# aoi_spatial <- as(aoi_shape, "Spatial")
# 
# conflict_col <- aoi_shape$conflict
# conflict_rast <- rasterize(aoi_spatial, raster(raster), field = conflict_col)
# 
# hf_walking_col <- aoi_shape$hf_walking
# hf_walking_rast <- rasterize(aoi_spatial, raster(raster), field = hf_walking_col)
# 
# pop_served_col <- aoi_shape$pop_served
# pop_served_rast <- rasterize(aoi_spatial, raster(raster), field = pop_served_col)
# 
# malaria_prevalence_col <- aoi_shape$malaria_prevalence
# malaria_prevalence_rast <- rasterize(aoi_spatial, raster(raster), field = malaria_prevalence_col)
# 
# vect <- c(conflict_rast, hf_walking_rast, pop_served_rast, malaria_prevalence_rast)
# brick <- brick(vect)
# 
# plot(brick)
# writeRaster(brick, here("data","indicator_brick.tif"))
