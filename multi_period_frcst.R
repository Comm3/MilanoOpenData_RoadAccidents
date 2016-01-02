#' Title
#'
#' @param data_f 
#' @param periodicity 
#' @param start_date 
#' @param end_date 
#' @param units_to_forecast 
#'
#' @return
#' @export
#'
#' @examples

predict <- function(model, units_to_forecast = 1){
  print("Predicting entries to 'Area C'")
  library(forecast)
  frcst <- forecast(model, units_to_forecast)
  return(frcst)
}


generate_model <- function(times_series){
  print("Generating model")
  library(forecast)
  fit <- tbats(times_series)
  return(fit)
}


load_frcst_area_c_entries <- function(model_name = "area_c_access_forecast.rds"){
  print("Loading model")
  fit <- tryCatch(
    {
      readRDS(model_name)
    }, error = function(cond){
      print(paste("Model names '", model_name, "' do not exists. Creating a new one."))
      dt <- data_milan_area_c_access(date_column = "Date")
      dt <- pre_process(dt, date_column = "Date", format = "%Y-%m-%d")
      dts <- build_time_series(dt)
      fit <- generate_model(dts)
      fit$dates <- dt$Date
      saveRDS(fit, model_name)
      fit
    }
  )
  return(fit)
}


predict_future_entries <- function(fit, days){
  pred <- predict(fit, days)
  return(pred)
}


predict_tomorrow_entries <- function(){
  fit <- load_frcst_area_c_entries()
  days <- as.integer(Sys.Date() - max(fit$dates) + 1)
  preds <- predict_future_entries(fit, days)
  tm_pred <- tail(preds$mean, n=1)
  return(tm_pred)
}
