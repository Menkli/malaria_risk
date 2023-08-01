# ows4R tutorial: https://inbo.github.io/tutorials/tutorials/spatial_wfs_services/ 

library(sf) # simple features packages for handling vector GIS data
library(httr) # generic webservice package
library(tidyverse) # a suite of packages for data wrangling, transformation, plotting, ...
library(ows4R) # interface for OGC webservices
library(here) # to use relative paths
library(h3) # to create the DGGS hexagons
library(rnaturalearth) 
#-----------------

# BURUNDI
wfs <- "https://gistmaps.itos.uga.edu/arcgis/services/COD_External/BDI_pcode/MapServer/WFSServer"
url <- parse_url(wfs)

url$query <- list(service = "wfs",
                  request = "GetCapabilities")
request <- build_url(url)
request

# Generate a connection to the WFS with ows4R

wfs_client <- WFSClient$new(wfs,
                            serviceVersion = "2.0.0")
wfs_client

# Lists all available layers for that WFS
layers <- wfs_client$getFeatureTypes(pretty = TRUE)

print("done")
#--------------------

# CONGO
wfs <- "https://gistmaps.itos.uga.edu/arcgis/services/COD_External/COD_pcode/MapServer/WFSServer"
url <- parse_url(wfs)

url$query <- list(service = "wfs",
                  request = "GetCapabilities")
request <- build_url(url)
request

# Generate a connection to the WFS with ows4R

wfs_client <- WFSClient$new(wfs,
                            serviceVersion = "2.0.0")
wfs_client

# Lists all available layers for that WFS
wfs_client$getFeatureTypes(pretty = TRUE)

#------------------------
# UGANDA

wfs <- "https://gistmaps.itos.uga.edu/arcgis/services/COD_External/UGA_pcode/MapServer/WFSServer"
url <- parse_url(wfs)

url$query <- list(service = "wfs",
                  request = "GetCapabilities")
request <- build_url(url)
request

# Generate a connection to the WFS with ows4R

wfs_client <- WFSClient$new(wfs,
                            serviceVersion = "2.0.0")
wfs_client

# Lists all available layers for that WFS
wfs_client$getFeatureTypes(pretty = TRUE)

#-----------------------------

# Call the Web Feature Service
wfs <- function(country, admin){
  
  path = "https://gistmaps.itos.uga.edu/arcgis/services/COD_External/"
  nation = country
  path2 = "/MapServer/WFSServer"
  wfs_full = paste0(path, nation, path2)
    
  url <- parse_url(wfs_full)

  url$query <- list(service = "wfs",
                    request = "GetFeature",
                    typename = admin,
                    serviceVersion = "2.0.0",
                    outputFormat = "GEOJSON")
  
  request <- build_url(url)
  read_sf(request)
}

# The list of available countries + codes can bee loked up here: https://gistmaps.itos.uga.edu/arcgis/rest/services/COD_External 

BDI_adm0 = wfs("BDI_pcode", "admin0")
COD_adm0 = wfs("COD_pcode", "admin0")
UGA_adm0 = wfs("UGA_pcode", "admin0")

BDI_adm1 = wfs("BDI_pcode", "admin1")
COD_adm1 = wfs("COD_pcode", "admin1")
UGA_adm1 = wfs("UGA_pcode", "admin1")

BDI_adm2 = wfs("BDI_pcode", "admin2")
COD_adm2 = wfs("COD_pcode", "admin2")
UGA_adm2 = wfs("UGA_pcode", "admin2")

#-------------------
# Write results to hard drive

st_write(BDI_adm0, here("data/geopackages","BDI_adm0.gpkg"), append = TRUE)
st_write(BDI_adm1, here("data/geopackages","BDI_adm1.gpkg"), append = TRUE)
st_write(BDI_adm2, here("data/geopackages","BDI_adm2.gpkg"), append = TRUE)

st_write(COD_adm0, here("data/geopackages","COD_adm0.gpkg"), append = TRUE)
st_write(COD_adm1, here("data/geopackages","COD_adm1.gpkg"), append = TRUE)
st_write(COD_adm2, here("data/geopackages","COD_adm2.gpkg"), append = TRUE)

st_write(UGA_adm0, here("data/geopackages","UGA_adm0.gpkg"), append = TRUE)
st_write(UGA_adm1, here("data/geopackages","UGA_adm1.gpkg"), append = TRUE)
st_write(UGA_adm2, here("data/geopackages","UGA_adm2.gpkg"), append = TRUE)

#-----------------------------
# RWA is not on the server: https://gistmaps.itos.uga.edu/arcgis/rest/services/COD_External
# Therefore, I downloaded it from: https://data.humdata.org/dataset/cod-ab-rwa

RWA_adm0 <- st_read(here("data/downloads/rwa_adm_2006_nisr_wgs1984_20181002_shp/rwa_adm0_2006_NISR_WGS1984_20181002.shp"))
RWA_adm1 <- st_read(here("data/downloads/rwa_adm_2006_nisr_wgs1984_20181002_shp/rwa_adm1_2006_NISR_WGS1984_20181002.shp"))
RWA_adm2 <- st_read(here("data/downloads/rwa_adm_2006_nisr_wgs1984_20181002_shp/rwa_adm2_2006_NISR_WGS1984_20181002.shp"))

st_write(RWA_adm0, here("data/geopackages","RWA_adm0.gpkg"), append = TRUE)
st_write(RWA_adm1, here("data/geopackages","RWA_adm1.gpkg"), append = TRUE)
st_write(RWA_adm2, here("data/geopackages","RWA_adm2.gpkg"), append = TRUE)

ggplot2::ggplot() + 
  geom_sf(data = BDI_adm0) +
  geom_sf(data = COD_adm0) +
  geom_sf(data = UGA_adm0) +
  geom_sf(data = RWA_adm0) +
  geom_sf(data = BDI_adm1)

#-----------------------------
# For re-runs: Load the admin layers

BDI_adm0 <- st_read(here("data/geopackages","BDI_adm0.gpkg"))
BDI_adm1 <- st_read(here("data/geopackages","BDI_adm1.gpkg"))
BDI_adm2 <- st_read(here("data/geopackages","BDI_adm2.gpkg"))

COD_adm0 <- st_read(here("data/geopackages","COD_adm0.gpkg"))
COD_adm1 <- st_read(here("data/geopackages","COD_adm1.gpkg"))
COD_adm2 <- st_read(here("data/geopackages","COD_adm2.gpkg"))

UGA_adm0 <- st_read(here("data/geopackages","UGA_adm0.gpkg"))
UGA_adm1 <- st_read(here("data/geopackages","UGA_adm1.gpkg"))
UGA_adm2 <- st_read(here("data/geopackages","UGA_adm2.gpkg"))

RWA_adm0 <- st_read(here("data/geopackages","RWA_adm0.gpkg"))
RWA_adm1 <- st_read(here("data/geopackages","RWA_adm1.gpkg"))
RWA_adm2 <- st_read(here("data/geopackages","RWA_adm2.gpkg"))

#-----------------------------
# Make area of interest layer

# Step 1: The provinces of interest in COD
target <- c("Ituri", "Nord-Kivu","Sud-Kivu")
East_COD <- filter(COD_adm2, admin1Name_fr %in% target)
plot(East_COD)       

st_write(East_COD, here("data/geopackages","COD_east_adm2.gpkg"), append = TRUE)

# Step 2: Merge with adm2 of the other countries. To bin the data together, they all need the same column names.
# Some come from a french server and some from the english server. So we must tweak names a bit for them to match exactly. 
# The Rwanda file, coming from a different source, had completely other column names, though. 

names(East_COD) <- gsub(x = names(East_COD), pattern = "_fr", replacement = "")
colnames(East_COD)

names(BDI_adm2) <- gsub(x = names(BDI_adm2), pattern = "_fr", replacement = "")
colnames(BDI_adm2)

names(UGA_adm2) <- gsub(x = names(UGA_adm2), pattern = "_en", replacement = "")
names(UGA_adm2) <- gsub(x = names(UGA_adm2), pattern = "validTo", replacement = "ValidTo")
colnames(UGA_adm2)

# To check if there are differences between the column names
# To do: Gives an error message - why?
# setdiff(East_COD, BDI_adm2, UGA_adm2)

# Bind East COD, Burundi and Uganda together.
aoi <- rbind(East_COD, BDI_adm2, UGA_adm2)
plot(aoi)

# st_write(aoi, here("data/geopackages","AOI.gpkg"), append = TRUE)

# To add Rwanda to the dataset, I have compared all columns from the aoi dataset with all columns from the Rwanda dataset. 
# All columns that are only present in Rwanda will be dropped, and some unnecessary from the aoi dataset will be dropped. 
# I designed a new set of shared variables to stich both datasets together. 
# This required renaming and dropping by hand, which limits the reproducibility (if the analysis workflow were to be applied to other locations).

colnames(RWA_adm2)

# To remove columns
col_remove <- c("admin2RefName","admin2AltName1","admin2AltName2","ValidTo","Shape.STArea__","Shape.STLength__")
aoi_clean <- aoi %>%            # Apply select & one_of functions
  select(- one_of(col_remove))

col_remove <- c("ADM0_FR","ADM0_RW","ADM0_SW", "ADM1_FR","ADM1_RW")

rwa_clean <- RWA_adm2 %>%            # Apply select & one_of functions
  select(- one_of(col_remove))

rwa_clean <- tibble::rowid_to_column(rwa_clean, "OBJECTID")
rwa_clean$date <- NA
rwa_clean$validOn <- NA

# To rename columns
rwa_clean <- rename(rwa_clean,admin2Name = ADM2_EN)
rwa_clean <- rename(rwa_clean,admin2Pcode = ADM2_PCODE)
rwa_clean <- rename(rwa_clean,admin1Name = ADM1_EN)
rwa_clean <- rename(rwa_clean,admin1Pcode = ADM1_PCODE)
rwa_clean <- rename(rwa_clean,admin0Name = ADM0_EN)
rwa_clean <- rename(rwa_clean,admin0Pcode = ADM0_PCODE)

# Binds the new, clean table and writes it to hard drive
aoi <- rbind(aoi_clean, rwa_clean)
st_write(aoi, here("data/geopackages","AOI.gpkg"), append = TRUE)

#----------------------------------------------
# Uncomment in case of wanting to re-run the AOI pre-processing
# without downloading the boundary data again.
aoi <- st_read(here("data/geopackages","AOI.gpkg"))

# Makes one polygon of the AOI's outer boundaries
# Dissolves the inner boundaries of the AOI polygon
aoi_dissolve = st_union(aoi) %>% 
  st_as_sf()

#-----------------------------------------------
# Created H3 DGGS hexagons over the entire AOI and removes the big lakes
# Makes an h3 index within the AOI
h3_index <- h3::polyfill(aoi_dissolve, res = 5)

# Converts the h3 language into sf polygons
index_sf <- h3::h3_to_geo_boundary_sf(h3_index)

# Download lakes from Naturalearthdata
world_lakes <- ne_download(scale = 10, type = 'lakes', category = 'physical')

# Transforms the lakes to an sf object, repairs broken geometries and crops to the AOI boundaries
aoi_lakes <- st_as_sf(world_lakes) %>% 
  st_make_valid() %>% 
  st_crop(aoi)

# Erases the lakes from the hexagon layer
index_sf_lakes <- rmapshaper::ms_erase(index_sf, aoi_lakes) 

st_write(index_sf_lakes, here("data/geopackages", "AOI_hex5.gpkg"), append = TRUE)
