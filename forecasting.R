library(forecast)

area_c_acc <- read.csv(file = 'dataset/area_c_access.csv', sep = ';')
area_c_acc$date <- as.Date(area_c_acc$timeIndex, format = "%d/%m/%Y")
area_c_acc$timeIndex <- NULL

myts <- ts(area_c_acc$PERSONE, frequency = 7, start = c(2012,1,1), end = c(2014,12,31))
myts <- ts(area_c_acc$PERSONE, frequency = 365, start = c(2012,1,1), end = c(2014,12,31))
myts <- msts(area_c_acc$PERSONE, seasonal.periods=c(7,12,365.25),start = c(2012,1,1), end = c(2014,12,31))
plot(myts)
fit <- stl(myts, s.window = "period")
plot(fit)
monthplot(myts)
seasonplot(myts)

myts <- msts(area_c_acc$PERSONE, seasonal.periods=c(7, 365.25),start = c(2012,1), end = c(2015,1))
fit <- tbats(myts)
fc <- forecast(fit, 31)
plot(fc)

x <- as.numeric(area_c_acc$PERSONE)
y <- ts(x, frequency=365)
z <- fourier(ts(x, frequency=365.25), K=5)
zf <- fourierf(ts(x, frequency=365.25), K=5, h=100)
# fit <- auto.arima(y, xreg=z, seasonal=FALSE)
fit <- auto.arima(y)
# fc <- forecast(fit, xreg=zf, h=100)
fc <- forecast(fit)
fc
# simple exponential - models level
fit <- HoltWinters(myts, beta=FALSE, gamma=FALSE)
# double exponential - models level and trend
fit <- HoltWinters(myts, gamma=FALSE)
# triple exponential - models level, trend, and seasonal components
fit <- HoltWinters(myts)

# predictive accuracy
library(forecast)
accuracy(fit)

# predict next three future values
library(forecast)
forecast(fit, 3)
plot(forecast(fit, 3))

