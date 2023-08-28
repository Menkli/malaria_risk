# Creates the folder structure that is used for the assessment data
library(dplyr)
library(here)

file.path(here(),"data") %>% 
  dir.create()

file.path(here("data"),"downloads") %>% 
  dir.create()

file.path(here("data"),"geopackages") %>% 
  dir.create()

file.path(here("data"),"rasters") %>% 
  dir.create()

# List of required packages
required_packages <- c(
  "acled.api", 
  "fable",
  "ecmwfr",
  "h3",
  "here",
  "httr",
  "malariaAtlas",
  "MetBrewer",
  "ows4R",
  "R.utils",
  "raster",
  "rmapshaper",
  "rnaturalearth",
  "Rsagacmd",
  "sf",
  "sfhotspot",
  "terra",
  "tidyverse",
  "timetk",
  "tmap",
  "tsibble",
  "utils"
)

# Check and install missing packages
for (package in required_packages) {
  if (!requireNamespace(package, quietly = TRUE)) {
    install.packages(package, dependencies = TRUE)
  }
}

# For packages not hosted on CRAN
install.packages("devtools")
devtools::install_github("crazycapivara/h3-r")
devtools::install_github("afrimapr/afrihealthsites")

# # acled.api - to access ACLED data
# # fable - time series analysis <<- ??
# # ecmwfr - to access ECMWF seasonal precipitation forecast data via the Copernicus Climate Data Store or ECMWF
# # h3 - to create the DGGS hexagons
# # here - to use relative paths
# # httr - for working with URLs and HTTP
# # malariaAtlas - download malaria data
# # MetBrewer - color palettes for plots
# # ows4R - interface for OGC webservices
# # R.utils - additional to the core package utils
# # raster - working with raster data
# # rjsonlite - for converting, streaming, validating and prettifying JSON data - really needed?
# # rnaturalearth - to access the naturalearthdata database
# # Rsagacmd - to access SAGA geoprocessing tools
# # sf - simple features packages for handling vector GIS data
# # sfhotspot - to perform hotspot analysis based on vector features
# # terra - to work with raster files (successor of raster)
# # tidyverse -  a suite of packages for data wrangling, transformation, plotting, ... Includes dplyr, ggplot2, httr, lubridate, stringr, tidyr (all used in this project)
#   - # dplyr - for tidy data manipulation
#   - # ggplot2 - plotting
#   - # httr - generic webservice package
#   - # lubridate - to work with dates
    - # purr - for functional programming
#   - # stringr - to manipulate string variables
#   - # tidyr - for tidying data
# # timetk - for working with timeseries data
# # tmap - for map making
# # tsibble - time series analysis
# # utils - general purpose programming tasks


print("done")

