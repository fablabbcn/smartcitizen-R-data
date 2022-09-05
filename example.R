
# Run this only the first time for installing the library
# library(devtools)
# install_github("fablabbcn/smartcitizen-R-data")

library(smartcitizenRdata)
# Change below to have the path to to the library (not needed in RStudio in OSx)
# load_all(path="/path/to/smartcitizen-R-data")
# source("apidevice.R") #script and functions to be used

# Change below to set your working directory (where data will go)
setwd("/path/to/data/folder")

# Input here device ID
device_id <- 14675
d <- ScDevice$new(id = device_id)

# This gets sensor and metrics names
d$get_names()
d$names

# Some metadata of the device...
d$get_json()
d$json

# Request the data of the device
# You can also pass rollup, min_date and max_date as an argument (see help)
d$get_device_data()

# Tabular data
data <- d$data

# Change the xts format to dataframe (matrix)
data <- data.frame(date= index(data), coredata(data))

# Save the data to a txt file
write.table(data, file=sprintf("%s.csv", device_id),  dec=".", sep ="\t", col.names=T, row.names=F, append=F)
