setwd("C:/Users/Susana/Desktop/Data Science/CLASES/3_ Correlacion y Regresion lineal")
getwd()

datos<-read.csv("C:/Users/Susana/Desktop/Data Science/CLASES/3_ Correlacion y Regresion lineal/BASE_Taller.csv")
datos
head(datos)
summary(datos)

y=datos$Colesterol.Total..mg.dl.
x1=datos$Actividad.Física
x2=datos$Peso..kg.
x3=datos$Edad
x4=datos$Triglicéridos..mg.dl.

# DIVIDIR LA HOJA DE GRÃFICOS
par(mfrow=c(2,3))
# COMPARAR GRAFICAMENTE
hist(datos$Colesterol.Total..mg.dl.)
boxplot(formula= datos$Colesterol.Total..mg.dl. ~ datos$Actividad.Física)

plot(x2,y,main="Colesterol vs Peso", xlab="Peso",ylab="Colesterol")


plot(x3,y,main="Colesterol vs Edad",xlab="Edad",ylab="Colesterol")

plot(x4,y,main="Colesterol vs Triglicéridos",xlab="Triglicéridos",ylab="Colesterol")


#Correlacion
library(datarium)
#install.packages("dplyr")
library(dplyr)


c.reg<- select(datos, Triglicéridos..mg.dl., Peso..kg., Edad, Colesterol.Total..mg.dl. )

cor(c.reg)
#test
datos
#edad colesterol
cor.test(datos[,3], datos[,6], )
cor.test(datos[,3], datos[,6], method="spearman")
cor.test(datos[,3], datos[,6], method="kendall" )



#peso colesterol
cor.test(datos[,5], datos[,6])

#peso Trigliceridos
cor.test(datos[,7], datos[,6])


#peso Trigliceridos
cor.test(datos[,7], datos[,6],method="spearman")
cor.test(datos[,7], datos[,6], method="kendall")
#peso colesterol
cor.test(datos[,5], datos[,6],method="spearman")
cor.test(datos[,5], datos[,6], method="kendall")

##MODELO
n<-nrow(datos)#numero de observaciones en el conjunto de datos
n.test<-round(n*0.20)#numero de observaciones en la muestra test, sacamos 20% de los datos
x<-seq(1,n,1) # vamos a muestrear ese 20% de los datos.
z<-sample(x, n.test, replace = FALSE, prob = NULL)#muestremos sin reemplazo

datos.train<-datos[-z,]#Muestra train: para construir el modelo
datos.test<-datos[z,]#Muestra test: para evaluar el modelo
fit1<-lm(Colesterol.Total..mg.dl.~ Peso..kg.+Triglicéridos..mg.dl.,data=datos.train)
summary(fit1)#Modelo lineal: 

fit2<-lm(Colesterol.Total..mg.dl.~ Peso..kg.*Triglicéridos..mg.dl.,data=datos.train) # aca considera interaccion *
summary(fit2)

#intervalos
confint(fit1,level=0.95)

confint(fit2,level=0.95)

p.test1<-predict(fit1, newdata=data.frame(datos.test), interval="prediction",level = 0.95)#Prediccion

plot(datos.test[,6],p.test1[,1])

plot(fit1$fitted.values,fit1$residuals)

MSE1<-mean((p.test1[,1]-datos.test[,6])^2)#Calculo del promedio de los errores cuadradas por el modelo 2
MSE1 

p.test2<-predict(fit2, newdata=data.frame(datos.test), interval="prediction",level = 0.95)#Prediccion

plot(datos.test[,6],p.test2[,1])
plot(fit2$fitted.values,fit2$residuals)
#Errores cuadrados

MSE2<-mean((p.test2[,1]-datos.test[,6])^2)#Calculo del promedio de los errores cuadradas por el modelo 2
MSE2 

#mejorar modelo ( no lo pondré)

datos.train2<-subset(datos.train, Colesterol.Total..mg.dl. > 150, select = c( "Triglicéridos..mg.dl.", "Peso..kg.", "Edad", "Colesterol.Total..mg.dl."))


datos.test2<-subset(datos.test, Colesterol.Total..mg.dl. > 150, select = c("Triglicéridos..mg.dl.", "Peso..kg.", "Edad", "Colesterol.Total..mg.dl."))

fit3<-lm(Colesterol.Total..mg.dl.~ Peso..kg.*Triglicéridos..mg.dl.,data=datos.train2)
summary(fit3)

p.test3<-predict(fit3, newdata=data.frame(datos.test2), interval="prediction",level = 0.95)

plot(datos.test2[,4],p.test3[,1])

plot(fit3$fitted.values,fit3$residuals)

MSE3<-mean((p.test3[,1]-datos.test2[,4])^2)
MSE3 # bajo aun mas este valor.

# final modelo

final<-lm(Colesterol.Total..mg.dl.~ Peso..kg.,data=datos.train)
summary(final)#Modelo lineal: 
confint(final,level=0.95)

p.testf<-predict(final, newdata=data.frame(datos.test), interval="prediction",level = 0.95)#Prediccion

plot(datos.test[,6],p.testf[,1])

plot(final$fitted.values,final$residuals)

MSEf<-mean((p.testf[,1]-datos.test[,6])^2)#Calculo del promedio de los errores cuadradas por el modelo 2
MSEf


##DETERMINAR MODELO CON VARIABLES DISPONIBLES.

library(MASS)
#vamos con un modelo vacio, podemos tener ningun apriori(modelo vacio y lo llenamos)
dit1<-lm(Colesterol.Total..mg.dl.~1,data=datos)

#podemos partir ya con el peso por ejemplo, no necesariamente vacio
#fit1<-lm(mpg~wt,data=mtcars)#si queremos partir de un modelo que no sea vacillo, por ejemplo si queremos qu si o si una variable sea en el modelo.

#vamos con el forward con el modelo stepAIC, en el cual debemos especificar el modelo de partida (modelo vacio)
# y vamos a buscar un modelo adentro de esas variables explicativas, y especificar que vamos adelante (forward)
forw<-stepAIC(dit1,scope=list(upper=~Peso..kg.+Triglicéridos..mg.dl.,lower=~1), direction="forward")

forw$anova
#Verifiquemos que los parametros son significativos
ajusteFAIC<-lm(Colesterol.Total..mg.dl. ~ Peso..kg.*Triglicéridos..mg.dl.,data=datos)

summary(ajusteFAIC)
#BIC

n<-dim(datos)[1]

forwBIC<-stepAIC(dit1,scope=list(upper=~Peso..kg.*Triglicéridos..mg.dl.,lower=~1),k=log(n), direction="forward")

forwBIC$anova#N

#Correlación parcial.

# generamos nuestro nuevo conjunto de datos sin las variables cualitativas.
s<-c(-1,-2,-4)
datos2<-datos[,s]

#install.packages("ppcor")
library(ppcor)

#comparar los dos "mpg" y "wt" de un lado, "mpg" y "cyl":
pcor(datos2, method = c("pearson", "kendall", "spearman"))
cor(datos2)








#Heteroscedasticidad y autocorrelacion
#Linear fitx


library(lmtest)
bptest(fit3)

#autocorrelacion
# Test Durbin Watson (paquete lmtest)
library(lmtest)
dwtest(fit3)

