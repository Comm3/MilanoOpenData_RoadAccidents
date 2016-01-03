# Milano Open Data RoadAccidents
The municipality of Milan did recently partecipate to the Open Data project, making available to the community a moltitude of data. One of these is the number of monthly road accidents. As a Milanese, I see everytime that is raining how the risk of driving accidents increase: the number of cars in the roads increase, drivers get mad and the streets become so slippery that you can get to work as if you are in a [gymkhana](https://www.youtube.com/watch?v=LuDN2bCIyus).
So it seemed natural to ask myself if there is a correlation between traffic, weather and accidents. And *Machine Learning* is quite suitable to solve this kind of problem.

#The Language
For this project it has been used the [R](https://www.r-project.org/) language

#The Data

##The Traffic - Entries into the Area C
The traffic is measured by considering the number of access into the *Area C*, which is the *restricted area traffic* representing the heart of the city.

##Milan's Open Data
The data used for training the prediction model is provided by the municipality of Milan trough it's Open Data project:
* [Daily Area C entries](http://dati.comune.milano.it/dato/item/68)
* [Monthly road accidents](http://dati.comune.milano.it/dato/item/177)
* Weather events per month:
  * [Rain](http://dati.comune.milano.it/dato/item/306)
  * [Atmospheric pressure](http://dati.comune.milano.it/dato/item/309)
  * [Temperature](http://dati.comune.milano.it/dato/item/305)
  * [Humidity](http://dati.comune.milano.it/dato/item/307)
  * [Wind speed](http://dati.comune.milano.it/dato/item/308)

These data is already available and is ready for use with the script.
If it is missing for some reason when the script is launched, it'll be automaticaly downloaded and preprocessed.
In this case, you're going to accept it's licence agreements ([in Italian](http://dati.comune.milano.it/principi-chiave)).

##Open Weather Map
As provider of the weather forecast it has been choosen [OpenWeatherMap](http://openweathermap.org/).

#The algorithms
For predicting the number of entries in the Area C it has been used the TBATS model for the a time series and seasonality analysis, using 

Since the weather forecast provider is [OpenWeatherMap](http://openweathermap.org/), you have to register yourself (for a lite use as this one is [free](http://openweathermap.org/price))and get an [API key](http://openweathermap.org/appid)
Once you obtain your API KEY, it has to be saved in an environment variable called *OPENWEATHERMAP_TOKEN*:

``` R
Sys.setenv("OPENWEATHERMAP_TOKEN" = "YOUR_KEY_HERE")
```

To check the entered key:

``` R
Sys.getenv("OPENWEATHERMAP_TOKEN")
```

#Input variables
The input variables for predicting the number of daily road accidents are:
* TMEDIA..C
* TMIN..C
* TMAX..C
* UMIDITA..
* VENTOMEDIA.km.h
* VENTOMAX.km.h
* PRESSIONESLM.mb
* PIOGGIA.mm
* Entries

Till "PIOGGIA.mm", the data is provided by the Open Weather Map service.
The last one (*Entries*) can be insered manually or can be predicted by itself.

## The *Entries* variable
The municipality of Milan offers an interactive site for analyze the number of cars that did access the *Area C*, which is the restricted area traffic comprehensive of the heart of the city. It has been used as a measure of the traffic of the city.
By analyzing it, we can see that is ciclical


, beside the weather, there is also
For predicting the
Linear regression [R stats package](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/lm.html)
###Accuracy measure
The training set is formed by the 
The model is a linear regression model
### The Data
The training set is build by using the month accidents from the city  from the 
As training data
Predicts the road accidents in the city of Milan (IT) by considering the weather forecast and the estimated traffic.

## Why
Give an example of what you can do with Open Data and Machine Learning.
 
##Data
 
The data provided from the municipality of Milan has CC license (http://creativecommons.org/licenses/by/2.5/it/deed.it)
The data used for weather is provided by OpenWeatherMap.

