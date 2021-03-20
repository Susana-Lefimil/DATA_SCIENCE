getwd()
setwd("C:/Users/Susana/Desktop/Data Science/CLASES/4_SECCION")
d <- read.csv(file = "Taller Base.csv")
d

library(dplyr)


dat<- select(d, IMC )
dat


## DESCRIPCION
summary(d)
summary(d$IMC)
hist(d$IMC)
#es relativamente simetrico

#install.packages("pastecs")
library(pastecs)
stat.desc(dat)
#install.packages("psych")
library(psych)
describe(dat)

#test de normalidad
qqnorm(d$IMC)
qqline(d$IMC, col='red')

#shapiro wik
#n<50
shapiro.test(d$IMC)
#el valor de p value es mayor a 0.05, no rechazams¿os h0, la dsitribucion es normal

############################################
##Datos normales Bootstrap NO parametrico

#indagar con t.test
tt<-t.test(d$IMC)#Test de media cero e intervalos de confianza
tt

# nos quedamos con el promedio estimado:3.441562

n<-length(d$IMC)
n

B<-1000
Xboot<-matrix(0,n,B)
for(i in 1:B){Xboot[,i]<-sample(d$IMC,replace = T)}
#Hacemos B muestras 

m<-colMeans(Xboot)
#calculamos los B promedios
#m

hist(m)
sortm<-sort(m)
print(sortm[(B*0.025)])
print(sortm[(B*0.975)])


sesgo=mean(m)-mean(d$IMC)
sesgo
#se puede evaluar el sesgo en el sentido que mean(X)-E(X) es "imitado" por mean(m)-mean(datos$IMC)

est.dev=sd(m)
est.dev

#################################

library(boot)

#para que funcione el paquete boots necesitamos en primer lugar una funcion wrap 
#debemos dar instrucciones a la funciones boots linea 45. generar la muestra bootstarp
getmean <- function(data, index){   # trabajamos con un vector
  datos<-data[index] # promedio de ese vector
  e<-mean(datos)
  return(e)
}
#Se debe escribir una funcción R con la estadistica que queremos calcular las replicas bootstrap
#vamos hacer bootstrap de x (muestra original) segun instrucciones de esa funcion getmean con 1000 rep
b=boot(d$IMC, getmean, R=1000) 
b
# tenemos el resultado muestra original
#t1* promedio de: 3.441562,  sesgo del estimador: 0.000624375 8 (podemos decir que es =0),   desviacion estandar:  0.08570563
#la desviacion estandar es calculado usando la desviacion est de la copias

c<-sort(b$t)
#Intervalo de confianza:
izquierda<-c[25]
derecha<-c[975]
izquierda
derecha



#Podemos hacer una prueba haciendo el bootstrap de la "estadistica de student" (pero quizas no sigue student si los datos no son normales):
# t studen: h0 la media=0, h1 la media es =1
get.t.test <- function(data, index){
  datos<-data[index]
  e<-t.test(datos)
  return(e$statistic) # aca retorna estadistica student
}
b=boot(d$IMC, get.t.test, R=1000)
b

#lo que podemos ver acá es si esa cantidad es probable que sea 0 o no, sacamos intervalos de confianza

c<-sort(b$t)
#Intervalo de confianza:
izquierda<-c[25]
derecha<-c[975]
#Si cero no está adentro del intervalo, rechazamos la hipotesis que la media sea cero.
izquierda
derecha

hist(b$t)
