                              #### TRANSFORMACION DE DATOS ####
                              
### VICTORINO HDZ MTZ                              


library(tidyverse)
library(nycflights13)


tt<-nycflights13::flights
?flights
View(flights)
?tibble

head(flights)
tail(flights)

#tibble es un data frame mejorado para tidyverse
## * int -> números enteros
## * dbl -> números reales (double)
## * chr -> vector de caracteres o strings
## * dttm -> date + time 
## * lgl -> logical, contiene valores booleanos (T o F)
## * fctr -> factor, variables categóricas
## * date -> fecha (día, mes y año)

## * filter() -> filtrar observaciones a partir de valores concretos
## * arrange() -> reordenar las filas
## * select() -> seleccionar variables por sus nombres
## * mutate() -> crea nuevas variables con funciones a partir de las existentes
## * summarise() -> colapsar varios valores para dar un resumen de los mismos

## * group_by() -> opera la función a la que acompaña grupo a grupo

## 1 - data frame 
## 2 - operaciones que queremos hacer a las variables del data frame
## 3 - resultado en un nuevo data frame



                                    ### FILTER

jan1 <- filter(flights, month == 1, day == 1)
flights %>% 
  filter(month == 1, day == 1) %>%
  filter(dep_delay>0)

may19 <- filter(flights, month == 5, day == 19)

dec25 <- filter(flights, month == 12, day == 25)
# >, >=, <, <=, ==, !=

may <- filter(flights, month == 5)

2 == 2

sqrt(2)^2 == 2
sqrt(2)^2 - 2
near(sqrt(2)^2, 2)
?near
1/pi * pi == 1
1/49 * 49 == 1
near(1/49*49, 1)

mayojun <- filter(flights, month == 5 | month == 6)

mayyjun <- filter(flights, month == 5 & month == 6)

filter(flights, month == 5 | 6)# NO FUNCIONA...

may_june <- filter(flights, month %in% c(5,6)) # igual que usar |
#LEYES DE MORGAN
#!(x&y) == (!x)|(!y)
#!(x|y) == (!x)&(!y)

vuelosretrasados <- filter(flights, !(arr_delay > 60 | dep_delay >60))
vuelos_retrasados <- filter(flights, arr_delay <= 60, dep_delay <= 60)

NA > 0
10 == NA
NA + 5
NA / 5
NA == NA


#La tía Mery tiene una edad desconocida. No se como de vieja es...
age.mery <- NA
#El tío John también hace mucho que no lo veo, y no se cuantos años debe tener...
age.john <- NA
#¿Deben de tener la misma edad John y Mery?
age.mery == age.john

is.na(age.mery)

df <- tibble(x = c(1,2,NA,4,5))
View(df)
filter(df, x>2)
filter(df, is.na(x)|x>2)

#Ejercicio 1
filter(flights, arr_delay > 60)

#Ejercicio 2
filter(flights, dest == "SFO" | dest == "OAK")

#Ejercicio 3
filter(flights, carrier == "UA" | carrier == "AA")

#Ejercicio 4
filter(flights, month == 4 | month == 5 | month == 6)

#Ejercicio 5
filter(flights, arr_delay > 60, dep_delay <= 60)

#Ejercicio 6
filter(flights, arr_delay > 60, dep_delay <= 30)

#Ejercicio 7
filter(flights, hour >= 0, hour < 7)

#Ejercicio 8
filter(flights, between(hour,0,6))

#Ejercicio 9
filter(flights, is.na(dep_time))


head(flights, 10) # primeros 10

tail(flights, 10) # ultimos 10



                                      ### ARRANGE


sorted_date <- arrange(flights, year, month, day)
flights %>% arrange(year, month, day)
tail(flights)
tail(sorted_date)

head(arrange(flights, desc(arr_delay))) #ordena en forma descencente con respecto a la var indcada

arrange(flights, desc(dep_delay))

arrange(df, x)
arrange(df, desc(x))

View(arrange(flights, carrier))

View(arrange(flights, desc(distance)))


                                  ### SELECT


View(sorted_date[1024:1068,TRUE]) # selecciona las filas 1024 a 1063

View(select(sorted_date[1024:1068,], dep_delay, arr_delay)) ## selecciona las filas 1024 a 1063,pero solo selecciona dos variables

select(flights, year, month, day)

select(flights, dep_time:arr_delay) #selecciona un rango

select(flights, -(year:day)) # selecciona todas excepto year a day

select(flights, starts_with("dep")) #selecciona las que comienzan con "dep"

select(flights, ends_with("delay")) #selecciona las que terminan con "delay"

select(flights, contains("st")) #seleciona las que ocntinene "st"

select(flights, matches("(.)\\1")) #selecciona las que tienen dos caracteres iguales

select(flights, num_range("x",1:5))# x1, x2, x3, x4, x5

?select

rename(flights, deptime = dep_time,           #cambia el nombre a las variables
       anio = year, mes = month, dia = day)

select(flights, deptime = dep_time) #selecciona y cmabia el nombre a la variable indicada

select(flights, time_hour, distance, air_time, everything()) #seleciona las variables al inicio y las demas restantes

sorted_date


?is.na


#Ejercicio 1
arrange(flights,!is.na(dep_time)) #ordena con respecto a la variable y los NA

#Ejercicio 2
arrange(flights, desc(dep_delay))[1,] #muestra la primera fila, la cual esta en orden descendente

arrange(flights, dep_delay)[1,] # muestar la primera fila, la cual esta en orden ascendente

#Ejercicio 3
View(arrange(flights, desc(distance/air_time))) #ordena en desc con respecto al cociente (rapidez)

#Ejercicio 4 y 5
View(arrange(flights, desc(distance))[1,]) #muestra la menor distancia
View(arrange(flights, distance)[1,])       #muestra la mayor distancia

#Ejercicio 6
select(flights,dep_time, dep_delay, arr_time, arr_delay)
select(flights,starts_with("dep"), starts_with("arr"))
select(flights,ends_with("time"), ends_with("delay") -starts_with("sched"),-starts_with("air") )

#Ejercicio 7
select(flights, distance, distance) # no ocurre nada si seleccionas varias veces la misma var


#Ejercicio 8 y 9
select(flights, one_of(c("year", "month", "day", "dep_delay", "arr_delay"))) #permite crear un vectos con variables en string

select(flights, contains("TIME")) #devuelve las variables que contengan "time" sin embargo vemos que no diferencia entre mayusculas



                                       ### MUTATE


#creando un nuevo dataset, solo selecionando ciertas variables

flights_new <- select(flights,
                      year:day, 
                      ends_with("delay"),
                      distance, 
                      air_time)               

flights_new

#creando nuevas variables con mutate y asignando a un nuevo dataset

mutate(flights_new,
       time_gain = arr_delay - dep_delay,    #diff_t (min)
       air_time_hour = air_time/60,
       flight_speed = distance/air_time_hour, #v = s/t (km/h)
       time_gain_per_hour = time_gain / air_time_hour
       ) -> flights_new
     
View(flights_new)


#se crea un histograma quitendo los NA
flights_new %>%
  filter(!is.na(time_gain_per_hour)) %>%
  ggplot() + 
  geom_histogram(mapping = aes(x=time_gain_per_hour),
                 bins = 300)

#se crea un nuevo dataset con variables, pero pierde las variables anteriores

transmute(flights_new,
          time_gain = arr_delay - dep_delay,
          air_time_hour = air_time/60,
          flight_speed = distance / air_time_hour,
          time_gain_per_hour = time_gain / air_time_hour) -> data_from_flights



                       #### NOTAS #####

# * Operaciones aritméticas: +, -, *, /, ^  (hours + 60 * minutes)
# * Agregados de funciones: x/sum(x) : proporición sobre el total
#                           x - mean(x): distancia respecto de media
#                           (x - mean(x))/sd(x): tipificación
#                           (x - min(x))/(max(x) - min(x)): estandarizar entre [0,1]
# * Aritmética modular: %/%-> cociente de la división entera, %% -> resto de la división entera
#                       x == y * (x%/%y) + (x%%y) 


# se crean nuevas variables para hras en el aire y otra para minutos, usando aritmetica modular

transmute(flights, 
          air_time,
          hour_air = air_time %/% 60,
          minute_air = air_time %% 60
          )


# * Logaritmos: log() -> logaritmo en base e, log2(), log10()
# * Offsets: lead()->mueve hacia la izquierda, lag()->mueve hacia la derecha


df <- 1:12
df
lag(df,4)
lead(df)


# * Funcions acumulativas: cumsum(), cumprod(), cummin(), cummax(), cummean()
df
cumsum(df)
cumprod(df)
cummin(df)
cummax(df)
cummean(df)


# * Comparaciones lógicas: >, >=, <, <=, ==, !=

# se crea una varible logica para ver si el vuelo ha sido atrasado
transmute(flights, 
          dep_delay,
          has_been_delayed = (dep_delay >0)
          )


# Definen rangos de las observaciones

# * Rakings:min_rank()
df <- c(7,1,2,5,3,3,8,NA,3,4,-2)
df
min_rank(df)

df
min_rank(desc(df))

row_number(df)

dense_rank(df)

percent_rank(df)

cume_dist(df)

ntile(df, n = 4)


#crea una varible para ver en que percentil se encuentra
transmute(flights, 
          dep_delay,
          percentil= ntile(dep_delay, n = 100))


#Ejercicio 1
transmute(flights, 
          dep_time, sched_dep_time,
          new_dep_time = 60*dep_time %/% 100 + dep_time %% 100 , 
          new_sched_dep_time = 60*sched_dep_time %/% 100 + sched_dep_time %% 100
          )

#Ejercicio 2
transmute(flights,
          air_time, 
          new_dep_time = 60*dep_time %/% 100 + dep_time %% 100 , 
          new_arr_time = 60*arr_time %/% 100 + arr_time %% 100,
          new_air_time = new_arr_time - new_dep_time)


#Ejercicio 3
transmute(flights,
          new_dep_time = 60*dep_time %/% 100 + dep_time %% 100 , 
          new_sched_dep_time = 60*sched_dep_time %/% 100 + sched_dep_time %% 100,
          new_delay = new_dep_time - new_sched_dep_time,
          dep_delay,
          new_delay==dep_delay)

#Ejercicio 4  
#esto calcula el ranking de vuelos mas demorados, los ordena en ascendente, para posteriormente mostrar el rankin de los primeros 10 vuelos
View(arrange(mutate(flights,
          r_delay = min_rank(dep_delay)),
         r_delay
        )[1:10,])


# Ejercicio 5
1:6 + 1:20




                                        ### SUMMARISE


summarise(flights, delay = mean(dep_delay, na.rm = T)) #calcula el promedio de dep_delay, quitando NA

flights %>%
  group_by(year, month)%>%
  summarise(delay = mean(dep_delay, na.rm = T)) #agruapa por año y mes, para despues sacar promedio

flights %>%
  group_by(year, month, day) %>%
  summarise(
          delay = mean(dep_delay, na.rm = T),
          median = median(dep_delay, na.rm = T),
          min = min(dep_delay, na.rm = T)
          )                             #agrupa por año, mes y dia y calcula media mediana y el minimo

flights %>%
  group_by(carrier) %>%
  summarise(
    delay = mean(dep_delay, na.rm = T),
    num = n()
    )                #agrupa por compañia, calcula la media, asi como el numero de vuelos

mutate(summarise(group_by(flights, carrier),
          delay = mean(dep_delay, na.rm = T)),
          sorted = min_rank(delay)
          ) #agrupa por compañia, calcula la media y despues ordena del menor a mayor, para asi crear la variable sorted




                                             ### PIPES



group_by_dest <- group_by(flights, dest) #agrupa por destino y crea un nuevo dataset


#Del dataset se crea uno nuevo calculando el nuemro de destinos, la media de la distancia y la media de la demora en llegada
delay <- summarise(group_by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = T),
                   delay = mean(arr_delay, na.rm = T)
                   )
#Del dataset delay se filtra por aquellos que el numero de destinos es mayor a 100 y se elimina HNL
delay <- filter(delay, count>100, dest != "HNL")


#Se crea un grafico usando delay y ggplot2
ggplot(data = delay, mapping = aes(x=dist, y = delay)) +
  geom_point(aes(size = count), alpha = 0.2) +
  geom_smooth(se = F) +
  geom_text(aes(label = dest), alpha = 0.3)


#SE REALIZA LO MISMO PERO SIMPLIFICANDO USANDO PIPES

delays <- flights %>%
  group_by(dest) %>%
  summarise(
    count = n(),
    dist = mean(distance, na.rm = T),
    delay = mean(arr_delay, na.rm = T)
  ) %>%
  filter(count > 100, dest!="HNL")


                                 ### NOTAS ###

# x %>% f(y) <-> f(x,y)
# x %>% f(y) %>% g(z) <-> g(f(x,y),z)
# x %>% f(y) %>% g(z) %>% h(t) <-> .............h(g(f(x,y),z),t)

##ggvis <-> ggplot2 




#Del dataset principal se agrupa por año, mes, dia, se calcula media, sd y se cuentan el nuemro de observaciones sin considerar NA

flights %>% 
  group_by(year, month, day) %>%
  summarise(mean = mean(dep_delay, na.rm  = T),
            median = median(dep_delay, na.rm = T),
            sd = sd(dep_delay, na.rm = T),
            count = n()
            )



#se calcula los vuelos no cancelados para ello se eliminan los NA, filtrando desde el tibble principal
#ademas se agrupan y se calculan estadisticos sin contar NA asociados a la variable en cuestion
flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay)) %>% 
  group_by(year, month, day) %>%
  summarise(mean = mean(dep_delay, na.rm  = T),
            median = median(dep_delay, na.rm = T),
            sd = sd(dep_delay, na.rm = T),
            count = n()
            ) 
#se calcula los vuelos no cancelados para ello se eliminan los NA, filtrando desde el t
not_cancelled <- flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay))

#Agrupa por numero de cola y calcula el promedio de demoras en la llegada de acuerdo al numtail
delay_numtail <- not_cancelled %>%
  group_by(tailnum) %>%
  summarise(delay = mean(arr_delay))

#se crea un grafico de lineas continuas
ggplot(data = delay_numtail, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 5)

#se crea un grafico de histograma
ggplot(data = delay_numtail, mapping = aes(x = delay)) + 
  geom_histogram(binwidth = 5)

#Agrupa por numero de cola y calcula el promedio de demoras en la llegada de acuerdo al numtail ademas se cuentan el nuemro de llegadas

delay_numtail <- not_cancelled %>%
  group_by(tailnum) %>%
  summarise(delay = mean(arr_delay),
            count = n()
            )
#se crea un grafico de dispercion entre el numero de vuelos de los aviones y las demoras
#entre mas veces haya volado un avion el tiempo de demora se estabiliza (ley de los grandes numeros, mas muestras mas tiende a estabilizarse)
ggplot(data = delay_numtail, mapping = aes(x = count, y = delay)) + 
  geom_point(alpha = 0.2)

#Del tibble se filtran los aviones que hay volado mas de 20 veces y se crea nuevamente el grafico de dispercion
delay_numtail %>% 
  filter(count>20) %>%
  ggplot(mapping = aes(x=count, y = delay)) +
    geom_point(alpha = 0.2)


                            #### BASEBALL
View(Lahman::Batting)
?Lahman::Batting
batting <- as_tibble(Lahman::Batting) #El dataset se convierte en tibble

#Se agrupa por playerid y se calculan estadisticos
batters <- batting %>%
  group_by(playerID) %>%
  summarise(hits = sum(H, na.rm = T),
            bats = sum(AB, na.rm = T),
            bat.average = hits / bats
            )

#se filtra por aquellos jugadores que batearon mas de 100 veces y se cre un grafico
batters %>%
  filter(bats > 100) %>%
  ggplot(mapping = aes(x = bats, y = bat.average))+
   geom_point(alpha = 0.2) +
   geom_smooth(se = F)
  
#se filtra por aquellos que batearon mas de 100 y se ordena en descendente de acuerdo al promedio de bateo  
batters %>%
  filter(bats > 100) %>%
  arrange(desc(bat.average))


                        #### ESTADISTICOS QUE SE PUEDEN CALCULAR


# * Medidas de Centralización

not_cancelled %>%
  group_by(carrier) %>%
  summarise(
    mean = mean(arr_delay),
    mean2 = mean(arr_delay[arr_delay>0]), #solo donde arr_delay es positivo
    median = median(arr_delay)
  )


# * Medidas de dispersión
not_cancelled %>%
  group_by(carrier) %>%
  summarise(
    sd = sd(arr_delay),
    iqr = IQR(arr_delay),
    mad = mad(arr_delay)
  ) %>%
  arrange(desc(sd))

?mad

# Medidas de orden
not_cancelled %>%
  group_by(carrier) %>%
  summarise(
    first = min(arr_delay),
    q1 = quantile(arr_delay, 0.25),
    median = quantile(arr_delay, 0.5),## median()
    q3 = quantile(arr_delay, 0.75),
    last = max(arr_delay)
    )

# Medida de posición 
not_cancelled %>%
  group_by(carrier) %>%
  arrange(dep_time) %>%
  summarise(
    first_dep = first(dep_time),
    second_dep = nth(dep_time, 2),
    third_dep = nth(dep_time, 3),
    last_dep = last(dep_time)
  )

#de los no cancelados se crea agrupa por compañia, se crea una variable de ranking en orden ascendente
#se filtra de acuerdo al ranking en ascendente
not_cancelled %>%
  group_by(carrier) %>%
  mutate(rank = min_rank(dep_time)) %>%
  filter(rank %in% range(rank)) -> temp

View(temp)

# Funciones de conteo
flights %>%
  group_by(dest) %>%
  summarise(
    count = n(),
    carriers = n_distinct(carrier), #cuenta los valores unicos, en este caso cuenta cuantos vuelos de las compañias llegan a cada uno de los destinos
    arrivals = sum(!is.na(arr_delay)), #cuenta cuantos no han sido cancelados
    cancelled = count - arrivals
  ) %>%
  arrange(desc(carriers)) #cuenta cual es el destino mas visitado


not_cancelled %>% count(dest)  #cuanta cuantos vuelos no ham sido cancelados es decir cuantos llegan

not_cancelled %>% group_by(dest) %>%   #equivalente a lo anterios
  summarise(cuantos=n())



#cuanta cuanto distancia ha recorrido en milla, se pondera por la distancia. Si no se pondera solo contaria cuantas veces ha volado
not_cancelled %>% count(tailnum, wt = distance) 


## sum /mean de valores lógicos 
#cuantos vuelos salen antes de las 5 
not_cancelled %>%
  group_by(year, month, day) %>%
  summarise(n_prior_5 = sum(dep_time < 500))

#la proporcion de vuelos que se retrasan mas de 1 hrs, y se ordena en descendente de acuerdo a cada compañia
not_cancelled %>%
  group_by(carrier) %>%
  summarise(more_than_hour_delay = mean(arr_delay>60)) %>%
  arrange(desc(more_than_hour_delay))





                           ## Agrupaciones múltiples



daily <- group_by(flights, year, month, day) #agrupa por año mes y dia
(per_day <- summarise(daily, n_fl = n())) #cuenta los vuelos por dia
(per_month <- summarise(per_day, n_fl = sum(n_fl)))  #cuenta los vuelos por mes
(per_year <- summarise(per_month, n_fl = sum(n_fl))) #cuenta los vuelos por año

business <- group_by(flights, carrier, dest, origin) #agrupa por compañia, destino y origen
summarise(business, n_fl = n()) %>% #cuenta el numero de vuelos por 0rigen
  summarise(n_fl = sum(n_fl)) %>% #cuenta el numero de vuelos por destino
  summarise(n_fl = sum(n_fl))  #cuenta el numero de vuelos por compañia


#Desagrupa

daily %>%
  ungroup() %>%
  summarise(n_fl = n())

business %>%
  ungroup() %>%
  summarise(n_fl = n())



#Del tibble agrupacion diaria, filtrar en un rango por orden desc y quedar con los retardos menor de 10
#muestra los peores de cada dia
flights %>%
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay))<10) -> temp
View(temp)


#muestra los destinos populares (que tienen mas de 365 vuelos destinos al año)
popular_dest <- flights %>%
  group_by(dest) %>%
  filter(n()>365)
View(popular_dest)


#filtra los que tiene retrasos, se crea la proporcion del retrazo global y selecciona que variables se muestran en el tibble 
popular_dest %>%
  filter(arr_delay >0) %>%
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>%
  select (year:day, dest, arr_delay, prop_delay)


