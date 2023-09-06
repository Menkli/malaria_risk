<h1>
  <img src="./GEOHUM_background.PNG" alt="GEOHUM Logo" width="100px">
  Malaria Risk Mapping
</h1>


## Context

**Conducting Transferable Malaria Risk Assessment**

Comparable and standardized risk assessments are vital for effective crisis response by humanitarian aid organizations, which focus on assisting vulnerable individuals. Achieving this requires leveraging open data, adopting community standards, and establishing transparent, automated workflows.

This repository showcases a case study collaboration between geospatial researchers from the University of Salzburg (ZGIS) and stakeholders from Médecins Sans Frontières (MSF) and Epicentre, actively involved in African malaria control. Together, they developed a composite-indicator framework for malaria risk assessment.

**Utilizing Reproducible Research with R and Python**

R and Python, with their extensive package ecosystems, enable transparent and replicable workflows. The objective was to assess whether open-source technology could support a fully scripted assessment process, from data collection to analysis and export. An R-based setup was developed for reproducibility, and this GitHub repository (Petutschnig 2023) promotes transparency and workflow sharing.

**Technical Maturity of Open-Source Software**

R demonstrated a high level of quality in data harvesting, processing, analysis, and visualization. Data-specific packages served as interfaces to data providers' databases, while generic geospatial packages like sf, raster, or terra equaled commercial counterparts in functionality. However, some data access required manual downloads.

**Challenges in Maintenance and Collaboration**

Maintaining the reproducible workflow posed challenges, with links going dead and scripts breaking after package updates. Collaboration between risk modelers, software developers, and computer scientists is crucial for proper deployment and maintenance, preventing costly and ineffective technical issues.

**Future Prospects**

Future work could involve developing an R package for comprehensive risk assessment. Open-source libraries have streamlined data integration, reducing reliance on proprietary software. Growing communities in R and Python have been instrumental in advancing geospatial capabilities.

In conclusion, open-source tools offer robust solutions for standardized risk assessments, emphasizing the importance of collaboration and proper maintenance in ensuring their effectiveness.

## Requirements

Before running the scripts, ensure that all requirements are met:

1. **ACLED Access Key**: Obtain an ACLED access key and insert your credentials into `acled_credentials.R`.

2. **Copernicus Credentials**: Get a Copernicus ID and access key and place your credentials in `copernicus_credentials.R`.

3. **Rtools**: Make sure you have Rtools installed.

### Manual Data Download

Some data must be downloaded manually and saved in the "data/downloads" folder, which is automatically generated when you execute the `01_packages.R` script.

#### 1. Common Operational Datasets of Rwanda
   - Go to the Humanitarian Data Exchange Platform (HDX): [https://data.humdata.org/dataset/cod-ab-rwa](https://data.humdata.org/dataset/cod-ab-rwa).
   - Download the .zip folder containing the Shapefiles.
   - Unzip the data into `data/downloads`. This will create a new sub-folder named `rwa_adm_2006_nisr_wgs1984_20181002_shp`.

#### 2. Malaria Incidence Data for 2018, 2019, and 2020
   - Visit the website of the Malaria Atlas Project and select the Global_Pf_Incidence_Rate data: [https://data.malariaatlas.org/maps?layers=Malaria:202206_Global_Pf_Incidence_Rate,Malaria:202206_Global_Pf_Parasite_Rate](https://data.malariaatlas.org/maps?layers=Malaria:202206_Global_Pf_Incidence_Rate,Malaria:202206_Global_Pf_Parasite_Rate).
   - Download the layer "Number of newly diagnosed Plasmodium falciparum cases per 1,000 population" for the years 2018, 2019, and 2020 into `data/downloads`. Ensure that the downloaded files are named `202206_Global_Pf_Incidence_Rate_2018.tif`, `202206_Global_Pf_Incidence_Rate_2019.tif`, and `202206_Global_Pf_Incidence_Rate_2020.tif`, respectively.

## General Information

- Filenames starting with "acc_" are used for accessing data from the web.
- Filenames starting with "ana_" are for performing data manipulation and analysis tasks.
- Scripts beginning with "00_" do not need to be executed.
- Run the scripts in consecutive order, starting with `01_packages.R`.
- Detailed information about the indicators can be found in the [publication].
- Information about the source data can be found in the [Excel table].

## Development Details

The project was developed and successfully tested using the following environment:

- R 4.2.3
- RStudio 2023.03.1
- Windows 10


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

## Package usage  

| R Package         | Used for                                                        | Reference                          |
|-------------------|-----------------------------------------------------------------|------------------------------------|
| acled.api v1.1.6  | To access ACLED data                                            | Dworschak (2022)                   |
| afrihealthsites   | To access healthcare facility location data                     |                                    |
| ecmwfr v1.5.0     | To access ECMWF seasonal precipitation forecast data           | Hufkens (2023)                     |
|                   | via the Copernicus Climate Data Store or ECMWF                 |                                    |
| malariaAtlas v1.0.1 | To download malaria incidence datasets & healthcare accessibility dataset | Pfeffer et al. (2018; 2020)   |
| Rnaturalearth v0.3.3 | To access lake-shapes to exclude them from the AOI             |                                    |
| Other             |                                                                 |                                    |
| h3 v3.7.2         | To create the DGGS hexagons                                     |                                    |
| raster v3.6-23    | Working with raster data                                        |                                    |
| Rsagacmd v0.4.1   | To use SAGA geoprocessing tools (“Accumulated cost” algorithm to calculate healthcare facility catchment areas) | |
| sf v1.0-14        | Simple features packages for handling vector GIS data           | Pebesma et al. (2023)              |
| sfhotspot v0.7.1  | To perform hotspot analysis based on ACLED data                | Ashby (2023)                       |
| terra v1.7-39     | To work with raster files (successor of raster)                 |                                    |
| tsibble v1.1.3    | Time series analysis                                            |                                    |

Additional packages used, which are, however, unspecific to the case study, include here (v1.0.1), httr (v1.4.6), MetBrewer (v0.2.0), ows4R (0.3-5), tidyverse (v2.0.0), tmap (v3.3.3), tsibble (v1.3.3).  