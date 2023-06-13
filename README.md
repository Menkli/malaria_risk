# African Great lakes region: Malaria Risk Mapping

The project is focused on analyzing and visualizing various datasets to study different aspects of a specific topic. This repository contains scripts and workflows for performing reproducible analysis.

## Features

- Accesses and downloads Common Operational Datasets (administrative boundaries) from the web on all available administrative levels.
- Provides armed conflicts locations and events information. [View here](https://menkli.github.io/malaria_risk/reports/armed_conflicts.html)
- Presents long-term trends in malaria prevalence. [View here](https://menkli.github.io/malaria_risk/reports/malaria_prevalence.html)

## Requirements

Before running the scripts, make sure to follow these requirements:

- Place the file `acled_credentials.R` in the root folder.
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
3. `acc_armed_conflicts.Rmd`
4. `acc_malaria_prevalence.Rmd`
5. `acc_access_to_healthcare.Rmd`
6. `acc_seasonal_precipitation.Rmd`
7. `ana_armed_conflicts.Rmd`
8. `ana_malaria_prevalence.Rmd`
9. `ana_access_to_healthcare.Rmd`
10. `ana_seasonal_precipitation.Rmd`
