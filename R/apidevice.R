library(jsonlite)
library(httr)
library(methods)
library(zoo)
library("xts")
library("lubridate")

#' Title
#'
#' @field id numeric.
#' @field json ANY.
#' @field data ANY.
#' @field names ANY.
#'
#' @return
#' @export
#'
#' @examples
ScDevice <- setRefClass(
         "ScDevice",
         fields = list(
           id = "numeric",
           json = "ANY",
           data = "ANY",
           names = "ANY"
         ),
         methods = list(
           initialize = function (id = NULL) {
             id <<- id
             json <<- NULL
             data <<- NULL
             names <<- NULL
             print (sprintf("Device %s initialized", id))
           },
           get_json = function() {
             "Gets a json with information about the device"
             if (is.null(d$json)) {
               url <- sprintf("https://api.smartcitizen.me/v0/devices/%s/", id)
               response <- GET(url)

               content <- rawToChar(response$content)
               JsonContent <- fromJSON(content)

               json <<- JsonContent
             }
           },
           get_names = function() {
             "Gets a table with the names of the sensors in the device"
             get_json()

             JsonDataDf  <- as.data.frame(json$data$sensors)
             rownames(JsonDataDf) <- JsonDataDf$id
             JsonDataDf$id <- NULL

             JsonDataDf$metric <- sub('.+- (.+)', '\\1', JsonDataDf$name)
             JsonDataDf$sensor <- sub("(^[^-]+) -.*", "\\1", JsonDataDf$name)

             names <<- JsonDataDf[ , c('metric', 'unit', 'sensor')]
           },
           get_device_data = function(rollup="1m", min_date = "", max_date = "") {
             "
             Gets tabular data of the device
              Parameters
                rollup:
                  String. Default: 1m
                  See reference in https://developer.smartcitizen.me/#rollup-measurements
                min_date:
                  String. Default: ''
                  Minimum date to request to the API (from). Format YYYY-MM-DD
                max_date
                  String. Default: ''
                  Maximum date to request to the API (from). Format YYYY-MM-DD
             "
             get_names()

             for (sensor_id in rownames(names)) {
               ts <- get_sensor_data(sensor_id, rollup, min_date, max_date)
               if (is.null(ts)) {
                 print (sprintf('Data for %s (%s) received is empty', sensor_id, names[sensor_id, "metric"]))
                 data <<- merge(data, matrix(NA, ncol=1, nrow=nrow(data), dimnames=list(NULL, names[sensor_id, "metric"])))
               } else {
                ts <- setNames(ts, names[sensor_id, "metric"])
                if (is.null(data)) {
                  data <<- ts
                } else {
                  data <<- merge(data, ts, all=TRUE)
                }
               }
             }
           },
           get_sensor_data = function(sensor_id, rollup="1m", min_date = "", max_date = "") {

             url_base <- sprintf("https://api.smartcitizen.me/v0/devices/%s/readings?sensor_id=%s&rollup=%s",
                                 id,
                                 sensor_id,
                                 rollup
             )

             if (min_date == "") {
               min_date = "2010-01-01"
             }

             add <- sprintf("&from=%s", min_date)

             if (max_date != "") {
               add <- paste(add, sprintf("&to=%s", max_date), sep="")
             }

             url <- paste(url_base, add, sep = "")
             print (sprintf ("Requesting url %s", url))

             response <- GET(url)

             raw <- rawToChar(response$content)
             jsonTS <- fromJSON(raw)
             if (jsonTS$sample_size > 0) {
               df <- as.data.frame(jsonTS)
               my_ts <- xts(as.numeric(df$readings.2), round(as.POSIXct(df$readings.1, format="%Y-%m-%dT%H:%M:%SZ", tz="UTC"), "mins"))
               my_ts
             } else {
               my_ts <- NULL
               my_ts
             }
           }
         )
)
