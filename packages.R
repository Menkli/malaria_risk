# List of required packages
required_packages <- c(
  "acled.api", "afrihealthsites", "chirps", "osmdata","malariaAtlas", "rnaturalearth", "wpgpDownloadR",
  "leaflet", "sf", "terra", "raster", "dplyr", "h3"
)

# Check and install missing packages
for (package in required_packages) {
  if (!requireNamespace(package, quietly = TRUE)) {
    install.packages(package, dependencies = TRUE)
  }
}

