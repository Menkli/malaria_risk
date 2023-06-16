# List of required packages
required_packages <- c(
  "acled.api", 
  "fable",
  "h3",
  "here",
  "malariaAtlas",
  "MetBrewer",
  "ows4R",
  "R.utils",
  "raster",
  "rnaturalearth",
  "sf",
  "sfhotspot",
  "terra",
  "tidyverse",
  "tmap",
  "tsibble",
  "utils",
  "wpgpDownloadR",
  "ecmwfr"
)

# Check and install missing packages
for (package in required_packages) {
  if (!requireNamespace(package, quietly = TRUE)) {
    install.packages(package, dependencies = TRUE)
  }
}


# # acled.api - to access ACLED data
# # fable - time series analysis
# # h3 - to create the DGGS hexagons
# # here - to use relative paths
# # malariaAtlas - download malaria data
# # MetBrewer - color palettes for plots
# # ows4R - interface for OGC webservices
# # R.utils - additional to the core package utils
# # raster - working with raster data
# # rnaturalearth - to access the naturalearthdata database
# # sf - simple features packages for handling vector GIS data
# # sfhotspot - to perform hotspot analysis based on vector features
# # terra - to work with raster files (successor of raster)
# # tidyverse -  a suite of packages for data wrangling, transformation, plotting, ... Includes dplyr, ggplot2, httr, lubridate, stringr, tidyr (all used in this project)
#   - # dplyr - for tidy data manipulation
#   - # ggplot2 - plotting
#   - # httr - generic webservice package
#   - # lubridate - to work with dates
#   - # stringr - to manipulate string variables
#   - # tidyr - for tidying data
# # tmap - for map making
# # tsibble - time series analysis
# # utils - general purpose programming tasks
# # wpgpDownloadR - to access the Worldpop database