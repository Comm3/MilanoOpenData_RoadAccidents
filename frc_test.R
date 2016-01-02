library(forecast)
gas_raw <-read.csv("http://robjhyndman.com/data/gasoline.csv", header=FALSE)
gas <- ts(gas_raw[,1], 
          freq=365.25/7, start=1991+31/7/365.25)
bestfit <- list(aicc=Inf)
