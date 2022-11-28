# smartcitizen-R-data

R package to interact with the Smart Citizen API

Should be easily installable by:

```
library(devtools)
install_github("fablabbcn/smartcitizen-R-data")
```

And work as in the [example](example.R) file, or the [example notebook](notebook_example.ipynb) file (see below for installing kernel in jupyter):

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

## Installing in jupyter

Assuming you have R installed, you could run this in the terminal:

```
Rscript -e 'install.packages(c("repr", "IRdisplay", "IRkernel"), type = "source", repos="https://cran.rstudio.com");'
Rscript -e 'IRkernel::installspec()'
```

And run `jupyter`. A example notebook is also provided.
