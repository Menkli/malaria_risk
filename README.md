aoi.R accesses and downloads the Common Operational Datasets (administrative boundaries) from the web on all available administrative levels.  
[Armed conflicts Locations and Events](https://menkli.github.io/malaria_risk/reports/armed_conflicts.html)   
[Long-term trends in malaria prevalence](https://menkli.github.io/malaria_risk/reports/malaria_prevalence.html)  

Reproducible analysis workflows  

- the file acled_credentials.R must be stored in the root folder   
- the file hexagonify.R must be stored in the root folder  
- filenames beginning with “acc_” are accessing data from the web   
- filenames beginning with “ana_” are performing data manipulation and analysis tasks   
- at the end of each acc_ file, a geopackage or .tif is exported  
- at the beginning of each ana_ file, the respective geopackage or .tif is loaded   

- the folder stucture must have the following sub-folders:  
  - root/data/downloads   -- for the data that I manually downloaded  
  - root/data/raster      -- for storing the rasters that will be created during the analysis  
  - foot/data/geopackages -- for storing the geopackages that will be created during the analysis  
  
The scripts are to be used in the following order  
- aoi.R  
- ---script that initially created the hexagons?---  
- acc_armed_conflicts.Rmd  
- acc_malaria_prevalence.Rmd  
- acc_access_to_healthcare.Rmd  
- acc_seasonal_precipitation.Rmd  
- ana_armed_conflicts.Rmd  
- ana_malaria_prevalence.Rmd  
- ana_access_to_healthcare.Rmd  
- ana_seasonal_precipitation.Rmd  
