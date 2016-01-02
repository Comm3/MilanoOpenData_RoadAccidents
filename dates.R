
build_dates <- function(start_date = "2012-01-01", end_date = NULL){
  library(timeDate)
  if (is.null(end_date)) {
    end_date <- Sys.Date() - 1
  }
  print(paste("Generating months from", start_date, "to", end_date))
  first_d_month <- timeSequence(from = start_date, to = end_date, by = "month")
  last_d_month <- timeLastDayInMonth(first_d_month)
  dates <- mapply(function(x,y) list(first_day = x,
                                     last_day = y
                                     ),
         as.Date(first_d_month),
         as.Date(last_d_month),
         SIMPLIFY = FALSE,
         USE.NAMES = FALSE)
  return(dates)
}


build_time_series <- function(data,
                     periods = c(7,365.25)){
  print("Building time series")
  library(forecast)
  time_series <- msts(data$Entries,
               seasonal.periods = periods,
               start = c(as.integer(format(min(dt$Date), "%Y")),
                         as.integer(format(min(dt$Date), "%M")),
                         as.integer(format(min(dt$Date), "%d"))
               ),
               end = c(as.integer(format(max(dt$Date), "%Y")),
                       as.integer(format(max(dt$Date), "%M")),
                       as.integer(format(max(dt$Date), "%d"))
               )
  )
  return(time_series)
}


get_year_month <- function(number_date){
  require(zoo)
  return(list(year = format(as.yearmon(number_date), format = "%Y"),
              month_name = months(number_date)))
}