# smartcitizen-R-data

R package to interact with the Smart Citizen API

Should be easily installable by:

```
library(devtools)
install_github("fablabbcn/smartcitizen-R-data")
```

And work as in the [example](example.R) file:

```
# source("R/apidevice.R")
load_all()

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
```
