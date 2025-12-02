library(ncdf4)
library(ggplot2)
library(dplyr)
library(tidyr)
library(raster)
nc_file <- nc_open("C:\\Users\\azizj\\Desktop\\finalrproject\\ncfile\\PREmm20220101000000120IMPGS01GL.nc")
var_names <- names(nc_file$var)
print("Available variables:")
print(var_names)
lon <- ncvar_get(nc_file, "lon_bnds")
lat <- ncvar_get(nc_file, "lat_bnds")
time <- ncvar_get(nc_file, "time_bnds")
precipitation <- ncvar_get(nc_file, "precipitation")
num_obs_fraction <- ncvar_get(nc_file, "num_obs_fraction")
num_obs_rate <- ncvar_get(nc_file, "num_obs_rate")
num_days <- ncvar_get(nc_file, "num_days")
quality_flag <- ncvar_get(nc_file, "quality_flag")

precip_raster <- raster(t(precipitation), 
                        xmn = min(lon), xmx = max(lon),
                        ymn = min(lat), ymx = max(lat))

# Plot precipitation map
plot(precip_raster, main = "Monthly Precipitation (mm)",
     xlab = "Longitude", ylab = "Latitude")
maps::map('world', add = TRUE, col = "gray50")


# Prepare data for ggplot
precip_df <- as.data.frame(precip_raster, xy = TRUE)
colnames(precip_df) <- c("lon", "lat", "precipitation")

ggplot(precip_df, aes(x = lon, y = lat, fill = precipitation)) +
  geom_tile() +
  borders("world", colour = "black", fill = NA) +
  scale_fill_viridis_c(option = "plasma", name = "Precipitation (mm)") +
  coord_quickmap() +
  labs(title = "Global Precipitation - January 2022",
       subtitle = "Monthly mean of daily accumulated precipitation",
       x = "Longitude", y = "Latitude") +
  theme_minimal()

# Histogram of precipitation values
precip_vector <- as.vector(precipitation)
precip_vector <- precip_vector[!is.na(precip_vector)]

hist(precip_vector, breaks = 50, col = "lightblue",
     main = "Distribution of Precipitation Values",
     xlab = "Precipitation (mm)", ylab = "Frequency")

# Focus on a specific region (e.g., Europe)
europe_bbox <- extent(-10, 40, 35, 70)  # xmin, xmax, ymin, ymax
precip_europe <- crop(precip_raster, europe_bbox)

plot(precip_europe, main = "Precipitation - Europe")
maps::map('world', add = TRUE, col = "gray50")


as.POSIXct(696988800, origin = "1970-01-01", tz = "UTC")
as.Date(as.POSIXct(696988800, origin = "1970-01-01", tz = "UTC"))