pre_process <- function(dt, date_column, format){
  dt <- na.omit(dt)
  dt[[date_column]] <- as.Date(dt[[date_column]], format = format)
  dt$X <- NULL
  return(dt)
}


generate_data <- function(fun_data, data_file, dates, date_column){
  require(dplyr)
  print("Generating dataset")
  df <- tryCatch(
    {
      dt <- read.csv(data_file)
      dt
    }, error = function(cond){
      print(paste("Dataset '", data_file, "' do not exists. Creating a new one."))
      df <- data.frame()
      for (date in dates) {
        date_df <- fun_data(date)
        if (!is.null(date_df)) {
          df <- c(df, date_df)
        }else{
          break
        }
      }
      df <- combine(df)
      write.csv(df, data_file, row.names = FALSE)
      df
    }
  )
  return(df)
}


data_milan_area_c_access <- function(date_column,
                                     dates = build_dates(),
                                     data_file = "area_c_acces.csv"){
  fun <- function(date){
    return(build_milan_area_c_dataset(date$first_day, date$last_day))
  }
  dt <- generate_data(dates = dates,
                      fun,
                      data_file = data_file,
                      date_column = date_column)
  return(dt)
}


data_milan_accidents <- function(data_file = "accidents.csv"){
  df <- tryCatch(
    {
      read.csv(data_file)
    }, error = function(cond){
      print(paste("Dataset '", data_file, "' do not exists. Creating a new one."))
      df <- build_milan_accidents_dataset()
      write.csv(df, data_file, row.names = FALSE)
      df
    }
  )
  return(df)
}


data_weather <- function(dates = build_dates(),
                         data_file = "weather.csv",
                         date_column = "DATA"){
  fun <- function(date){
    date_pieces <- get_year_month(date$first_day)
    date_df <- build_milan_weather_dataset(year = date_pieces$year, 
                                           month_name = date_pieces$month_name)
    return(date_df)
  }
  return(generate_data(dates = dates,
                       fun_data =  fun,
                       data_file = data_file,
                       date_column = date_column))
}


training_data <- function(){
  
  require(lubridate)
  
  entries <- data_milan_area_c_access() %>%
    mutate(Mese = month(Date), Anno = year(Date)) %>%
    select(-one_of(c("Date", "Morti"))) %>%
    group_by(Mese, Anno) %>%
    summarise(Entries = mean(Entries)) %>%
    ungroup()
  
  accidents <- data_milan_accidents() %>%
    select(-one_of(c("Morti"))) %>%
    group_by(Mese, Anno) %>%
    summarise(Incidenti = mean(Incidenti), Feriti = mean(Feriti)) %>%
    ungroup()
  
  weather <- data_weather() %>%
    mutate(Mese = month(DATA), Anno = year(DATA)) %>%
    select(-one_of(c("LOCALITA", "DATA", "FENOMENI"))) %>%
    group_by(Mese, Anno) %>%
    summarise_each(funs(mean)) %>%
    ungroup()
  
  training_data <- inner_join(entries, accidents) %>% inner_join(weather) %>%
    select(-one_of(c("Mese", "Anno")))
  
  return(training_data)
}