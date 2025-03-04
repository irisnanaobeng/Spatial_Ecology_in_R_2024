install.packages(c("terra", "ggplot2", "sf", "tidyverse", “viridis"))

# Load required libraries
library(terra)
library(ggplot2)
library(sf)
library(tidyverse)
library(viridis)

# Set working directory (update this path)
setwd("/Users/irisnanaobeng/Desktop/Amsterdam_Land_Cover/Data/")

# Load land cover data
land_cover_2006 <- vect("/Users/irisnanaobeng/Desktop/Amsterdam_Land_Cover/Data/Shapefiles/NL002L2_AMSTERDAM_UA2006_Revised.shp")
land_cover_2018 <- vect("/Users/irisnanaobeng/Desktop/Amsterdam_Land_Cover/Data/land_cover_2018.gpkg", layer = "NL002L3_AMSTERDAM_UA2018")

# Confirm both datasets are loaded
print(land_cover_2006)
print(land_cover_2018)

# Check field names
names(land_cover_2006)
names(land_cover_2018)

# Unique land cover classes
unique(land_cover_2006$ITEM2006)
unique(land_cover_2018$class_2018)

# Convert to sf format
land_cover_2006_sf <- st_as_sf(land_cover_2006)
land_cover_2018_sf <- st_as_sf(land_cover_2018)

# Define land cover groupings
group_mapping <- c(
  "Continuous urban fabric (S.L. : > 80%)" = "Urban",
  "Discontinuous dense urban fabric (S.L. : 50% - 80%)" = "Urban",
  "Discontinuous medium density urban fabric (S.L. : 30% - 50%)" = "Urban",
  "Discontinuous low density urban fabric (S.L. : 10% - 30%)" = "Urban",
  "Discontinuous very low density urban fabric (S.L. : < 10%)" = "Urban",
  "Isolated structures" = "Urban",
  "Industrial, commercial, public, military and private units" = "Urban",
  "Port areas" = "Urban",
  "Airports" = "Urban",
  "Construction sites" = "Urban",
  "Railways and associated land" = "Urban",
  "Other roads and associated land" = "Urban",
  "Fast transit roads and associated land" = "Urban",
  
  # Natural / Green Spaces
  "Green urban areas" = "Natural / Green Spaces",
  "Sports and leisure facilities" = "Natural / Green Spaces",
  "Forests" = "Natural / Green Spaces",
  "Herbaceous vegetation associations (natural grassland, moors...)" = "Natural / Green Spaces",
  "Wetlands" = "Natural / Green Spaces",
  "Open spaces with little or no vegetation (beaches, dunes, bare rocks, glaciers)" = "Natural / Green Spaces",
  
  # Agricultural areas
  "Agricultural, semi-natural areas, wetlands" = "Agriculture",
  "Pastures" = "Agriculture",
  "Arable land (annual crops)" = "Agriculture",
  "Permanent crops (vineyards, fruit trees, olive groves)" = "Agriculture",
  
  # Water bodies
  "Water" = "Water",
  
  # Other/Unused
  "Mineral extraction and dump sites" = "Other",
  "Land without current use" = "Other")


