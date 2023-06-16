<h1>
  <img src="./GEOHUM_background.PNG" alt="GEOHUM Logo" width="100px">
  Malaria Risk Mapping
</h1>


## Context

In the field of humanitarian work, coordination initiatives like INFORM underscore the significance of comparable and standardized spatial risk assessments. These assessments are crucial for enabling timely and targeted responses to crises. Humanitarian aid organizations, operating at local and regional levels, focus on assisting the most vulnerable individuals. Hence, it is essential that risk assessments are transferable across different locations, time frames, and scopes. Achieving this level of transferability requires leveraging open data, adopting community standards, and establishing transparent, automated, and open workflows.

This repository presents a case study showcasing an approach to a reliable and transferable malaria risk assessment process. The collaboration involved stakeholders from MSF and Epicentre, organizations actively involved in malaria control in Africa. Together, we co-developed a conceptual composite-indicator framework for malaria risk assessment. The aim is to highlight the strengths and limitations of this approach, along with reporting on the current maturity of its transferability.


## Requirements

Before running the scripts, make sure to follow these requirements:

- Place the file `acled_credentials.R` in the root folder.
- Place the file `copernicus_credentials.R`in the root folder.
- Store the file `hexagonify.R` in the root folder.
- Use filenames beginning with "acc_" for accessing data from the web.
- Use filenames beginning with "ana_" for performing data manipulation and analysis tasks.
- Export a geopackage or .tif file at the end of each "acc_" file.
- Load the respective geopackage or .tif file at the beginning of each "ana_" file.

The folder structure should include the following sub-folders:

- `root/data/downloads` - For manually downloaded data.
- `root/data/raster` - For storing rasters created during the analysis.
- `root/data/geopackages` - For storing geopackages created during the analysis.

### Indicator Information

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

## Workflow Details

The project was developed and successfully tested using the following environment:

- R 4.2.3
- RStudio 2023.03.1
- Windows 10

## Script Execution Order

To run the scripts and reproduce the analysis, follow this order:

1. `packages.R`
2. `aoi.R`
3. `population.Rmd`
4. `acc_armed_conflicts.Rmd`
5. `acc_malaria_prevalence.Rmd`
6. `acc_access_to_healthcare.Rmd`
7. `acc_seasonal_precipitation.Rmd`
8. `ana_armed_conflicts.Rmd`
9. `ana_malaria_prevalence.Rmd`
10. `ana_access_to_healthcare.Rmd`
11. `ana_seasonal_precipitation.Rmd`

## Important tasks to do in the beginning

Some data must be downloaded manually. These must be manually saved into the "data/downloads" folder.

- RWA Common Operational Datasets admin boundaries from the HDX platform    
  - Link:  [https://data.humdata.org/dataset/cod-ab-rwa](https://data.humdata.org/dataset/cod-ab-rwa)  
  - Download the .zip folder containing the Shapefiles  
  - Under `data/downloads`, unzip the data into a new sub-folder. The folder should automatically get the name `rwa_adm_2006_nisr_wgs1984_20181002_shp` 

- Malaria incidence 2018, 2019 and 2020  
Links:  

## Features

- Accesses and downloads Common Operational Datasets (administrative boundaries) from the web on all available administrative levels.
- Provides armed conflicts locations and events information. [View here](https://menkli.github.io/malaria_risk/reports/armed_conflicts.html)
- Presents long-term trends in malaria prevalence. [View here](https://menkli.github.io/malaria_risk/reports/malaria_prevalence.html)