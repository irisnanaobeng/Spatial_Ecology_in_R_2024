# R Project focusing on Assessing Fire Severity and Vegetation Change from California Wildfires Using Sentinel-2 Imagery​

# Load required packages
library(terra)
library(ggplot2)
library(dplyr)
library(viridis)

# Set working directory
setwd("/Users/irisnanaobeng/Desktop/Spatial Ecology in r project")

# Load satellite bands for Before Fire (July 2020)
red_before <- rast("S2B_MSIL2A_20200701T185919_N0500_R013_T10TDK_20230318T102719.SAFE/T10TDK_20200701T185919_B04_10m.jp2")
nir_before <- rast("S2B_MSIL2A_20200701T185919_N0500_R013_T10TDK_20230318T102719.SAFE/T10TDK_20200701T185919_B08_10m.jp2")
green_before <- rast("S2B_MSIL2A_20200701T185919_N0500_R013_T10TDK_20230318T102719.SAFE/T10TDK_20200701T185919_B03_10m.jp2")
blue_before <- rast("S2B_MSIL2A_20200701T185919_N0500_R013_T10TDK_20230318T102719.SAFE/T10TDK_20200701T185919_B02_10m.jp2")
swir_before <- rast("S2B_MSIL2A_20200701T185919_N0500_R013_T10TDK_20230318T102719.SAFE/T10TDK_20200701T185919_B12_20m.jp2")

# Load satellite bands for After Fire (October 2020)
red_after <- rast("S2B_MSIL2A_20201029T190519_N0500_R013_T10TDK_20230315T101006.SAFE/T10TDK_20201029T190519_B04_10m.jp2")
nir_after <- rast("S2B_MSIL2A_20201029T190519_N0500_R013_T10TDK_20230315T101006.SAFE/T10TDK_20201029T190519_B08_10m.jp2")
green_after <- rast("S2B_MSIL2A_20201029T190519_N0500_R013_T10TDK_20230315T101006.SAFE/T10TDK_20201029T190519_B03_10m.jp2")
blue_after <- rast("S2B_MSIL2A_20201029T190519_N0500_R013_T10TDK_20230315T101006.SAFE/T10TDK_20201029T190519_B02_10m.jp2")
swir_after <- rast("S2B_MSIL2A_20201029T190519_N0500_R013_T10TDK_20230315T101006.SAFE/T10TDK_20201029T190519_B12_20m.jp2")

# Load satellite bands for Recovery Phase (October 2022)
red_recovery <- rast("S2B_MSIL2A_20221019T190419_N0400_R013_T10TDK_20221019T224048.SAFE/T10TDK_20221019T190419_B04_10m.jp2")
nir_recovery <- rast("S2B_MSIL2A_20221019T190419_N0400_R013_T10TDK_20221019T224048.SAFE/T10TDK_20221019T190419_B08_10m.jp2")
green_recovery <- rast("S2B_MSIL2A_20221019T190419_N0400_R013_T10TDK_20221019T224048.SAFE/T10TDK_20221019T190419_B03_10m.jp2")
blue_recovery <- rast("S2B_MSIL2A_20221019T190419_N0400_R013_T10TDK_20221019T224048.SAFE/T10TDK_20221019T190419_B02_10m.jp2")
swir_recovery <- rast("S2B_MSIL2A_20221019T190419_N0400_R013_T10TDK_20221019T224048.SAFE/T10TDK_20221019T190419_B12_20m.jp2")

# Resample SWIR bands to match NIR resolution
swir_before <- resample(swir_before, nir_before)
swir_after <- resample(swir_after, nir_after)
swir_recovery <- resample(swir_recovery, nir_recovery)

# Downsampling all RGB bands 
fact_val <- 10
red_before_ds <- aggregate(red_before, fact = fact_val, fun = mean)
green_before_ds <- aggregate(green_before, fact = fact_val, fun = mean)
blue_before_ds <- aggregate(blue_before, fact = fact_val, fun = mean)

red_after_ds <- aggregate(red_after, fact = fact_val, fun = mean)
green_after_ds <- aggregate(green_after, fact = fact_val, fun = mean)
blue_after_ds <- aggregate(blue_after, fact = fact_val, fun = mean)

red_recovery_ds <- aggregate(red_recovery, fact = fact_val, fun = mean)
green_recovery_ds <- aggregate(green_recovery, fact = fact_val, fun = mean)
blue_recovery_ds <- aggregate(blue_recovery, fact = fact_val, fun = mean)

# Calculating  NDVI
calc_ndvi <- function(nir, red) {
  (nir - red) / (nir + red)
}
ndvi_before <- calc_ndvi(nir_before, red_before)
ndvi_after <- calc_ndvi(nir_after, red_after)
ndvi_recovery <- calc_ndvi(nir_recovery, red_recovery)

# Calculating NDVI loss and gain
ndvi_loss <- ndvi_before - ndvi_after
ndvi_gain <- ndvi_recovery - ndvi_after

# Calculating NBR (for fire severity)
calc_nbr <- function(nir, swir) {
  (nir - swir) / (nir + swir)
}
nbr_before <- calc_nbr(nir_before, swir_before)
nbr_after <- calc_nbr(nir_after, swir_after)
fire_severity <- nbr_before - nbr_after

# Downsample NDVI/NBR difference layers for plotting
ndvi_loss_down <- aggregate(ndvi_loss, fact = 10, fun = mean)
ndvi_gain_down <- aggregate(ndvi_gain, fact = 10, fun = mean)
fire_severity_down <- aggregate(fire_severity, fact = 10, fun = mean)

# Convert raster to data frame for ggplot
r_to_df <- function(raster_obj, label) {
  df <- as.data.frame(raster_obj, xy = TRUE)
  colnames(df)[3] <- "value"
  df$label <- label
  return(df)
}


# Convert to data frames
df_before <- r_to_df(ndvi_before_down, "Before Fire (Jul 2020)")
df_after <- r_to_df(ndvi_after_down, "After Fire (Oct 2020)")
df_recovery <- r_to_df(ndvi_recovery_down, "Recovery Phase (Oct 2022)")
df_loss <- r_to_df(ndvi_loss_down, "Vegetation Loss (2020)")
df_gain <- r_to_df(ndvi_gain_down, "Vegetation Regrowth (2020–2022)")
df_severity <- r_to_df(fire_severity_down, "Fire Severity")

# NDVI Time Series Map
ndvi_all <- rbind(df_before, df_after, df_recovery)
ndvi_all$label <- factor(ndvi_all$label, levels = c("Before Fire (Jul 2020)", "After Fire (Oct 2020)", "Recovery Phase (Oct 2022)"))

ggplot(ndvi_all, aes(x = x, y = y, fill = value)) +
  geom_raster() +
  scale_fill_viridis(name = "NDVI", option = "viridis", na.value = "transparent") +
  coord_equal() +
  facet_wrap(~label) +
  labs(title = "NDVI Changes Over Time",
       subtitle = "NDVI: Darker = low vegetation, Yellow-green = high vegetation",
       x = "Longitude", y = "Latitude")
  
# Barplot of Mean NDVI by Phase
ndvi_summary <- ndvi_all %>%
  group_by(label) %>%
  summarise(mean_ndvi = mean(value, na.rm = TRUE))

ggplot(ndvi_summary, aes(x = label, y = mean_ndvi, fill = label)) +
  geom_col(width = 0.6, show.legend = FALSE) +
  scale_fill_viridis(discrete = TRUE) +
  labs(
    title = "Average NDVI Across Fire Phases",
    x = "", y = "Mean NDVI"
  ) 

# Plotting for Vegetation Loss
ggplot(df_loss, aes(x = x, y = y, fill = value)) +
  geom_raster() +
  scale_fill_gradient2(low = "darkgreen", mid = "yellow", high = "red", midpoint = 0, name = "NDVI Loss") +
  coord_equal() +
  labs(title = "Vegetation Loss (2020 Fire Impact)",
       subtitle = "NDVI Difference: Before - After Fire",
       x = "Longitude", y = "Latitude") 


# Plottinf for Vegetation Regrowth
ggplot(df_gain, aes(x = x, y = y, fill = value)) +
  geom_raster() +
  scale_fill_gradient2(low = "red", mid = "yellow", high = "darkgreen", midpoint = 0, name = "NDVI Gain") +
  coord_equal() +
  labs(title = "Vegetation Regrowth (2020–2022)",
       subtitle = "NDVI Difference (Recovery Phase - After Fire):\nRed = Loss, Yellow = No Change, DarkGreen = Regrowth",
       x = "Longitude", y = "Latitude") 
 

# Plotting for Fire Severity
ggplot(df_severity, aes(x = x, y = y, fill = value)) +
  geom_raster() +
  scale_fill_viridis(name = "Fire Severity", option = "cividis", direction = -1, na.value = "transparent") +
  coord_equal() +
  labs(title = "Fire Severity Map (NBR Difference)",
       subtitle = "High values = more vegetation burned",
       x = "Longitude", y = "Latitude") 
 

# Plotting fo=r True Color Composites 
# BEFORE FIRE
par(mar = c(2, 2, 5, 2))
plotRGB(c(red_before_ds, green_before_ds, blue_before_ds),
        r = 1, g = 2, b = 3, stretch = "lin",
        main = "True Color - Before Fire (Jul 2020)", cex.main = 1.5)

# AFTER FIRE
par(mar = c(2, 2, 5, 2))
plotRGB(c(red_after_ds, green_after_ds, blue_after_ds),
        r = 1, g = 2, b = 3, stretch = "lin",
        main = "True Color - After Fire (Oct 2020)", cex.main = 1.5)

# RECOVERY PHASE
par(mar = c(2, 2, 5, 2))
plotRGB(c(red_recovery_ds, green_recovery_ds, blue_recovery_ds),
        r = 1, g = 2, b = 3, stretch = "lin",
        main = "True Color - Recovery Phase (Oct 2022)", cex.main = 1.5)
