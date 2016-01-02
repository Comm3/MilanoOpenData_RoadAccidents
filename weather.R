require(rjson)


url_base <- function()
  "http://api.openweathermap.org/data"

city_to_id <- function(city, country_code = "IT", country="Italy", api_key) {
  require(rjson)
  require(curl)
  url <- sprintf("%s/2.5/find?q=%s,%s&APPID=%s",
                 url_base(),
                 city,
                 country_code,
                 api_key)
  conn <- curl(url)
  res <- fromJSON(file = conn)
  close(conn)
  if (!is.null(country)) {
    ok <- sapply(res$list, function(x) x$sys$country %in% country)
    res$list <- res$list[ok]
  }
  
  n <- length(res$list)
  if (n < 1)
    stop("Failed to find information for city ", city)
  if (n > 1)
    warning("More than one possible hit, returning first")
  res$list[[1]]$id
}


five_days_forecast <- function(city, country_code = "IT", api_key){
  require(curl)
  url <- sprintf("%s/2.5/forecast?q=%s,%s&units=metric&mode=json&appid=%s", url_base(), city, country_code, api_key)
  conn <- curl(url, "r")
  res <- fromJSON(file = conn)
  close(conn)
  return(res)
}


extract_weather <- function(x){
  return(data.frame(
                    temp = x$main$temp,
                    min = x$main$temp_min,
                    max = x$main$temp_max,
                    pressure = x$main$pressure,
                    humidity = x$main$humidity,
                    wind = unlist(x$wind$speed[1]),
                    rain = ifelse(length(x$rain$`3h`) == 0, 0, x$rain$`3h`),
                    tstmp = x$dt
  )
  )
}


prepare_forecast_data <- function(raw_forecast_df){
  require(dplyr)
  weather_forecast <- Reduce(rbind,lapply(raw_forecast_df$list , extract_weather)) %>%
    mutate(day = as.Date(as.POSIXct(tstmp, origin = as.Date("1970-01-01")))) %>%
    select(-contains("tstmp")) %>%
    group_by(day) %>%
    summarise(
              TMEDIA..C = mean(temp),
              TMIN..C = min(min),
              TMAX..C = max(max),
              UMIDITA.. = mean(humidity),
              VENTOMEDIA.km.h = mean(wind),
              VENTOMAX.km.h = max(wind),
              PRESSIONESLM.mb = mean(pressure),
              PIOGGIA.mm = mean(rain)
              )
  return(weather_forecast)
}


model_forecast_data <- function(){
  api_key <- Sys.getenv("OPENWEATHERMAP_TOKEN")
  return(prepare_forecast_data(
    five_days_forecast(city = "Milan", country_code = "IT", api_key = api_key))
  )
}

