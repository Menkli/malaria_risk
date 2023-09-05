<h1>
  <img src="./GEOHUM_background.PNG" alt="GEOHUM Logo" width="100px">
  Malaria Risk Mapping
</h1>


## Context

In the field of humanitarian work, coordination initiatives like INFORM underscore the significance of comparable and standardized spatial risk assessments. These assessments are crucial for enabling timely and targeted responses to crises. Humanitarian aid organizations, operating at local and regional levels, focus on assisting the most vulnerable individuals. Hence, it is essential that risk assessments are transferable across different locations, time frames, and scopes. Achieving this level of transferability requires leveraging open data, adopting community standards, and establishing transparent, automated, and open workflows.

This repository presents a case study showcasing an approach to a reliable and transferable malaria risk assessment process. The collaboration involved stakeholders from MSF and Epicentre, organizations actively involved in malaria control in Africa. Together, we co-developed a conceptual composite-indicator framework for malaria risk assessment. The aim is to highlight the strengths and limitations of this approach, along with reporting on the current maturity of its transferability.


## Requirements

Before running the scripts, make sure to follow these requirements:

- Get an ACLED access key and put your credentials into `acled_credentials.R`.
- Get Copernicus ID and access key and put your credentials into `copernicus_credentials.R`.
- Have Rtools installed

## General  
- Filenames beginning with "acc_" are for accessing data from the web.
- Filenames beginning with "ana_" for performing data manipulation and analysis tasks.
- Scripts beginning with 00_ do not need to be run,
- Run the scripts in consecutive order starting with 01_packages.R

## Overview of individual scripts  

### 00_acled_credentials.R
To download data via the ACLED API, you need an access key. Follow the instructions on their website to obtain one by describing your case. They typically respond within a day or two. Register with an email address and add both the email address and access key to this script. These pieces of information are required to execute `03_acc_armed_conflicts.Rmd`.

### 00_copernicus_credentials.R
To download data from the Copernicus Climate Change Climate Data Store, you'll need a user ID and an access key. Follow the instructions on their website and place the credentials in this script. They will be necessary to execute `09_acc_seasonal_precipitation.Rmd`.

### 00_hexagonify.R
This script contains the function that integrates the results of individual indicators into one polygon layer of a hexagonal DGGS grid.

### 01_packages.R
This script checks which required packages are already available on your computer and downloads and installs the ones that are not yet installed. It also creates a folder structure within your root folder. After running this script, the following folders should exist in your root folder:
- `.../data/downloads` - for manually downloaded data.
- `.../data/raster` - for storing rasters created during the analysis.
- `.../data/geopackages` - for storing geopackages created during the analysis.

### 02_aoi.R
This script downloads country boundaries from the Common Operational Datasets website, crops where necessary, and combines the shapes into one AOI file. It downloads admin 0, 1, and 2 boundaries, cleans and removes unnecessary columns, and creates the output `AOI.gpkg` in the geopackages folder. It also uses the H3 library to generate a DGGS hexagonal grid over the AOI, creating the output `AOI_hex5.gpkg` in the geopackages folder.

### 03_acc_armed_conflicts.Rmd
This script accesses the ACLED database and downloads events for a defined timeframe (currently Jan 2017 to Dec 2019) based on the AOI outlines. It creates the output `acled_17_20_aoi.gpkg` in the geopackages folder.

### 04_ana_armed_conflicts.Rmd
This script applies a hotspot classification algorithm to classify the AOI into hexagons of different categories of conflict hotspots based on event time and location. It creates the output `AOI_hex5_ind1.gpkg` in the geopackages folder.

### 05_acc_malaria_prevalence.Rmd
This script downloads malaria incidence data from the Malaria Atlas Project for the years 2000-2017. Years 2018-2020 need to be downloaded manually (follow instructions at the end of the page). It combines the rasters into one stack and converts the raster cells to points. Each point has attributes representing malaria incidence values from 2000-2020. It creates the output `pf_00_20_points.gpkg` in the geopackages folder.

### 06_ana_malaria_prevalence.Rmd
This script performs exploratory analysis on the malaria incidence data. It calculates the percentage difference in malaria incidence values between the years 2013 and 2020, creating the `AOI_hex5_ind2.gpkg` in the geopackages folder.

### 07_acc_access_to_healthcare.Rmd
This script downloads a healthcare accessibility layer from the Malaria Atlas Project and writes `AOI_traveltime_foot_hf.tif` into the rasters folder. It also downloads gridded population statistics for the AOI from Worldpop, with individual rasters named `XXX_ppp_2020_unconst_1km_UNadj.tif`, which are placed in the rasters folder. The combined statistics layer for the AOI is called `AOI_ppp_2020_unconst_UNadj.tif` and is written into the rasters folder.

### 08_ana_access_to_healthcare.Rmd
This script calculates the average walking time in minutes to the nearest healthcare facility for each hexagon. It also calculates service areas using an allocated costs algorithm for each healthcare facility based on the shortest walking time and blends these service areas with the gridded population layer to estimate the number of persons approaching individual healthcare facilities. The results are integrated with the hexagon layer, creating the output `AOI_hex5_ind4.gpkg` in the geopackages folder.

### 09_acc_seasonal_precipitation.Rmd
This script downloads monthly CHIRPS data from 1990-2020, creates a stack from the layers, and writes the stack into the file `perc_aoi_brick_90_19.tif` in the rasters folder. The individual monthly tif's and tar.gz files are automatically removed at the end. It also downloads seasonal precipitation forecast data from the Copernicus Climate Data Store.

### 10_ana_seasonal_precipitation.Rmd
This script conducts exploratory analysis on the CHIRPS precipitation data. It calculates means and standard deviations to distinguish dry from rainy seasons in individual locations and assigns a higher risk to rainy seasons. It also calculates means and standard deviations for the forecast data and assigns higher risk to areas expected to experience strong rainfall. The script overlays the seasonality data with the forecast data to calculate the overall risk score and transfers the results into the hexagonal layer, creating the output `AOI_hex5_ind5.gpkg` in the geopackages folder.

### 11_assemble_hexagons.R
This script loads all the individual indicator results from the geopackages folder, combines them into one file, cleans the data, and calculates a version of the results where the values are normalized to a min-max stratification. It then sums the normalized values and divides the sum by 5 to calculate the final risk score. The script creates the final results file `All_indicators_final.gpkg` and writes it into the geopackages folder.


### Output data
The scripts produce the following outputs:  

- A geopackage or .tif file at the end of each "acc_" file.
- Then it loads the respective geopackage or .tif file at the beginning of each "ana_" file.

The final indicators are added to a set of hexagonal polygons in a specific order:

- Data ending with "_ind1.gpkg" holds the first indicator.
- Data ending with "_ind2.gpkg" holds the second indicator.
- ...  
- The order of indicators is as follows:
  - 1 = Armed conflicts
  - 2 = Malaria prevalence
  - 3 = Access to healthcare: Walking time to the nearest healthcare facility
  - 4 = Access to healthcare: Population served by the same healthcare facility
  - 5 = Seasonal precipitation

## Development Details

The project was developed and successfully tested using the following environment:

- R 4.2.3
- RStudio 2023.03.1
- Windows 10

## Important tasks to do in the beginning

Some data must be downloaded manually and saved into the "data/downloads" folder.

- RWA Common Operational Datasets admin boundaries from the HDX platform    
  - Link:  [https://data.humdata.org/dataset/cod-ab-rwa](https://data.humdata.org/dataset/cod-ab-rwa)  
  - Download the .zip folder containing the Shapefiles  
  - Under `data/downloads`, unzip the data into a new sub-folder. The folder should automatically have the name `rwa_adm_2006_nisr_wgs1984_20181002_shp` 

- Malaria incidence 2018, 2019 and 2020  
Links:   [https://data.malariaatlas.org/maps?layers=Malaria:202206_Global_Pf_Incidence_Rate,Malaria:202206_Global_Pf_Parasite_Rate](https://data.malariaatlas.org/maps?layers=Malaria:202206_Global_Pf_Incidence_Rate,Malaria:202206_Global_Pf_Parasite_Rate)

## Features

- Accesses and downloads Common Operational Datasets (administrative boundaries) from the web on all available administrative levels.
- Provides armed conflicts locations and events information. [View here](https://menkli.github.io/malaria_risk/reports/armed_conflicts.html)
- Presents long-term trends in malaria prevalence. [View here](https://menkli.github.io/malaria_risk/reports/malaria_prevalence.html)