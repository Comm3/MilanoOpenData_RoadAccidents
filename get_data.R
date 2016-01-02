dwld_csv <- function(m_url, d_sep = ",", d_dec = "."){
  # print(paste("Downloading data from", m_url))
  require(curl)
  conn <- NULL
  while (is.data.frame(conn) == FALSE) {
    conn <- tryCatch(
      curl(m_url),
      error = function(cond) {
        print("Retring download")
        Sys.sleep(15)
      }
    )
  }
  # conn <- curl(m_url)
  m_csv <- read.csv(conn, sep = d_sep, dec = d_dec)
  return(m_csv)
}


# AREA C ----


build_area_c_url <- function(start_date, end_date){
  url_base <- "https://areac.amat-mi.it/areac/json/accessiGiornalieri/"
  url_end <- "?disaggregazione=categoria_veicolo&download=1"
  url_date <- paste(start_date,
                    "/",
                    end_date,
                    sep = "")
  return(paste(url_base, url_date, url_end, sep = ""))
}


parse_milan_area_c_csv <- function(m_csv){
  prsd_csv <- m_csv[,c("timeIndex", "PERSONE")]
  m_csv$time_index <- as.Date(m_csv$timeIndex)
  colnames(prsd_csv) <- c("Date", "Entries")
  return(prsd_csv)
}


build_milan_area_c_dataset <- function(start_date, end_date){
  print(paste("Building 'Area C' dataset from", start_date, "to", end_date))
  m_url <- build_area_c_url(start_date, end_date)
  m_csv <- dwld_csv(m_url)
  if (any(is.na(m_csv[1,]))) {
    return(NA)
  }
  m_df <- parse_milan_area_c_csv(m_csv)
  return(m_df)
}


# ACCIDENTS ----


build_milan_accidents_dataset <- function(){
  m_csv <- dwld_csv("http://dati.comune.milano.it/media/rdp/comunemilano/dati/177_Incidenti_Infortunati_Zone_SerieSt.csv", d_sep = ";")
  return(m_csv)
} 


# WEATHER ----

build_weather_url <- function(city, year, month_name){
  url_base = 'http://www.ilmeteo.it/portale/archivio-meteo/'
  url_location_date <- paste(city, "/", year, "/", month_name, sep = "")
  url_end <- "?format=csv"
  return(paste(url_base, url_location_date, url_end, sep = ""))
}


build_milan_weather_dataset <- function(year, month_name){
  url <- build_weather_url(city = "Milano", year, month_name)
  print(paste("Downloading data from", url, sep = "\n"))
  m_csv <- dwld_csv(url, d_sep = ";")
  return(m_csv)
} 