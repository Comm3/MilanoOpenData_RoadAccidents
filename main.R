source("dates.R")
source("get_data.R")
source("multi_period_frcst.R")

# plot(fit)
# plot(frcast_entries)
# 
# monthplot(fit$y)
# seasonplot(fit$y)

training_dataset <- function(){
  source("data_factory.R")
  require(dplyr)
  ml_dataset <- as.data.frame(training_data()) %>%
    select(Incidenti,
           Entries,
           TMEDIA..C,
           TMIN..C,
           TMAX..C,
           UMIDITA..,
           VENTOMEDIA.km.h,
           VENTOMAX.km.h,
           PRESSIONESLM.mb,
           PIOGGIA.mm)
}

input_instance <- function(tomorrow_entries = predict_tomorrow_entries(),
                           day_date = as.Date(Sys.time()) + 1){
  require(dplyr)
  source("weather.R")
  weather <- model_forecast_data() %>%
      filter(day == day_date) %>%
      mutate(Entries = tomorrow_entries) %>%
      select(-contains("day"))
  }
  
tomorrow_data <- input_instance(tomorrow_entries = 120000)

form <- Incidenti ~ .
fit <- lm(form, data = training_dataset())

predict.lm(fit, newdata = tomorrow_data)

# form <- Feriti ~ . - Incidenti - Entries
# fit <- lm(Feriti ~ . - Incidenti - Entries, data = ml_dataset)
summary(fit)

library(DAAG)
cv.lm(data = ml_dataset, form.lm = form, m = 5, legend.pos = "bottom", printit = T) # 3 fold cross-validation
detach("package:DAAG", unload = T)



library(MASS)
step <- stepAIC(fit, direction="both")
step$anova # display results
detach("package:MASS", unload = T)




# Other useful functions 
coefficients(fit) # model coefficients
confint(fit, level=0.95) # CIs for model parameters 
fitted(fit) # predicted values
residuals(fit) # residuals
anova(fit) # anova table 
vcov(fit) # covariance matrix for model parameters 
influence(fit) # regression diagnostics






# diagnostic plots 
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page 
plot(fit)
