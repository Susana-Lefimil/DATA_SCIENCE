#SCRIPT CLUSTERING
setwd("C:/Users/Susana/Desktop/Data Science/CLASES/14_Clustering")
getwd()
datos<-read.csv("C:/Users/Susana/Desktop/Data Science/CLASES/14_Clustering/credit_card_datasets.csv")

###Análisis exploratorio:
str(datos)
##variables de interés

str(datos$PURCHASES_TRX)
ID=datos$CUST_ID
BALANCE=datos$BALANCE
CASH_ADVANCE=datos$CASH_ADVANCE
CASHADVANCEFREQUENCY=datos$CASH_ADVANCE_FREQUENCY
PURCHASES_TRX=datos$PURCHASES_TRX
PAYMENTS=datos$PAYMENTS
CREDITLIMIT=datos$CREDIT_LIMIT
PURCHASES=datos$PURCHASES


#base con variables de interés
library(dplyr)
subdatos<-data.frame(ID, BALANCE, CASH_ADVANCE, PURCHASES, CASHADVANCEFREQUENCY, PURCHASES_TRX, PAYMENTS, CREDITLIMIT)


###Evaluación de datos faltantes
#deteccion de NA
sum(is.na(BALANCE))
sum(is.na(CASH_ADVANCE))
sum(is.na(PURCHASES_TRX))
sum(is.na(PAYMENTS))
sum(is.na(CREDITLIMIT))
sum(is.na(PURCHASES))
sum(is.na(CASHADVANCEFREQUENCY))

#Un NA en CREDITLIMIT

#se eliminan fila con NA y se trabaja con subdatos
subdatos <- na.omit(subdatos)

# tabla con las variables de interes 6 valores
head(subdatos)

#Resumen de la base
summary(subdatos)
par(mfrow=c(2,3))



###Implementación de técnica de clustering:
# Calculamos una muestra para observar mejor los graficos y dendogramas
muestra<-sample(1:dim(subdatos)[1],100)
#aca setearemos la fila de donde traemos esos elementos
Muestra<-subdatos[muestra,]


# Normalizacion de las variables
library(tidyverse)
# No estan en la misma escala, vamos a estandarizar para llevarlos a la misma escala
#y al llevarlos a las misma escala vamos a definir que las variables son comparables.
#Se escalan los datos de dos formas y se comparan si tenemos los mismos resultados

#Primera forma
subdatos2 <- scale(Muestra[,-c(1)])
subdatos2 %>% summary

#Segunda forma
#Hago la funcion
norm <- function(x) {
  (x - mean(x)) / sd(x) 
}

# Estandarizamos el Z los datos
datos_standard <- data.frame(scale(Muestra[,-c(1)], scale = T, center = T))
head(datos_standard)
head(subdatos2)
#Los mismos resultados, sique el analisis con datos_standard


###Evaluación de datos atípicos
#Outlier
#se consideraran outlier observaciones mayor a 3 desviaciones estandar del promedio
#Indica posicion
which(abs(datos_standard$BALANCE)>3)
which(abs(datos_standard$CASH_ADVANCE)>3)
which(abs(datos_standard$PURCHASES)>3)
which(abs(datos_standard$CASHADVANCEFREQUENCY)>3)
which(abs(datos_standard$PURCHASES_TRX)>3)
which(abs(datos_standard$PAYMENTS)>3)
which(abs(datos_standard$CREDITLIMIT)>3)
#Indica valor (SOLO ALGUNOS para observar)
datos_standard$CASH_ADVANCE[which(datos_standard$CASH_ADVANCE>3)]
datos_standard$PURCHASES_TRX[which(datos_standard$PURCHASES_TRX>3)]
#Se sacan outlier
datos_standard<-filter(datos_standard, BALANCE<3 & CASH_ADVANCE<3 & PURCHASES<3 & CASHADVANCEFREQUENCY<3 & PURCHASES_TRX<3 & PAYMENTS<3 & CREDITLIMIT<3)
head(datos_standard)


# graficamos los datos originales, los estandarizados y mediante Z para comparar, usaremos las variables 
#PURCHASE Y PAYMENT
g <- ggplot() +
  ggtitle("Comparacion") +
  labs(x = "PURCHASES",y = "PAYMENTS") +
  geom_point(data = Muestra, 
             aes(x = PURCHASES, 
                 y = PAYMENTS,
                 color = "original"),
             size = 3)  +
  geom_point(data = datos_standard, 
             aes(x = PURCHASES, 
                 y = PAYMENTS,
                 color = "Z"),
             size = 3) 
print(g)

#PURCHASES VS PAYMENTS (Normalizados)

g <- ggplot() +
  ggtitle("PURCHASES VS PAYMENTS") +
  labs(x = "PURCHASES",y = "PAYMENTS") +
  geom_point(data = datos_standard, 
             aes(x = PURCHASES, 
                 y = PAYMENTS,
                 color = "Z"),
             size = 3) 
print(g)

##Clustering Jerarquico
#Dendograma
library(factoextra)
#Se comparan los cuatro tipos de distancia y se escoge el metodo ward.D, ya que es el menos
#sensible a outlier

#se usa datos_standard que ya esta escalado

par(mfrow=c(2,4))
dist.usa1<-dist(x = datos_standard, method = "manhattan")
hc_m_completo <- hclust(d =dist.usa1 ,method = "ward.D")
plot(hc_m_completo, main="Distancia manhhatan")
dist.usa2<-dist(x = datos_standard, method = "euclidean")
hc_e_completo <- hclust(d =dist.usa2 ,method = "ward.D")
plot(hc_e_completo, main="Distancia euclidean")
dist.usa3<-dist(x = datos_standard, method = "maximum")
hc_max_completo <- hclust(d =dist.usa3 ,method = "ward.D")
plot(hc_max_completo, main="Distancia maximum")

dist.usa<-dist(x = datos_standard, method = "canberra")
hc_c_completo <- hclust(d =dist.usa ,method = "ward.D")
plot(hc_c_completo, main="Distancia canberra")

#Se escoge manhattan

#Visualmente Se observan 4 grupos si cortamos en el 22. Entonces se establecen 4 cluster.
# graficamos el dendograma en base a 4 cluster y definimos una linea horizontal en el intercepto 22
dev.off()
fviz_dend(x = hc_m_completo, k = 4, cex = 0.6) +
  geom_hline(yintercept = 22, linetype = "dashed") +
  labs(title = "Herarchical clustering",
       subtitle = "Distancia Manhattan, K=4")


#Kmeans
library(ggplot2)
library(tidyverse)
library(ggpubr)


#Vamos a aplicar k means en datos_standard, en el paso anterior determinamos 4 centroides
km_clusters<-kmeans(datos_standard%>%select(-1), centers =4, iter.max =30 , nstart = 50)
#con mayor iteracion mayor precision en el numero de los centros. 
km_clusters
#se puede normalizar las variables para tener mas normalizado el conjunto de datos, pero la forma no va a variar


# obtenemos los centroides del kmeans
#generamos una forma aleatoria cluster, una secuencia del 1 al 4
centroids <- data.frame(cluster = factor(seq(1:4)),
                        #y generamos las etiquetas x e y
                        x = km_clusters$centers[,"PURCHASES"],
                        y = km_clusters$centers[,"PAYMENTS"])
centroids #donde se ubican

#Generamos la funcion mutate y para crear la etiqueta
km<-datos_standard%>%mutate(cluster=as.factor(km_clusters$cluster))


ggplot(data = km, aes(x = PURCHASES, y = PAYMENTS, color = cluster)) +
  geom_point(size = 2.5) +
  
  geom_point(data = centroids,
             mapping = aes(x = x,
                           y = y,
                           color = cluster),
             size = 20,
             pch = 13) +
  
  theme_bw()


###Evaluar métricas de validación: 

#Minimo de cluster
min_nc=2
# Maximo de cluster
max_nc=10
#Matriz vacia
#Aca vamos a asignar cada uno de los valores dentro de este reporte de evaluacion que estamos construyendo
evaluacion <- array(0, c(max_nc-min_nc+1, 4))

# Agregamos numeros correlativos del minimo a maximo de clusters en la la columna 1
evaluacion[,1] <- min_nc:max_nc
#El reporte de evaluacion es una matriz de 4 por 9, 4 porque vamos a definir tres metricas de validacion (indice de dan, de la siluatea y db)
#y otra que va de valores de 2 a 10 que va a tener el numero de cluster que vamos a definir

#Entonces queremos ver las metricas de evaluacion, con respecto a k=2, k=3 , etc


# Calculamos las metricas Dunn, Silhouette y Davies Bouldin para cada iteracion con la libreria clusterCrit y la funciion intCriteria
# nc - numero de clusters
library(clusterCrit)
library(ggplot2)
#formato matriz
sub_esc<-scale(subdatos[c(-1)])
#Va ir iteranod del 2 al 10 (cluster)
for (nc in min_nc:max_nc){
  cl2 <- kmeans(sub_esc,nc, iter.max = 30, nstart = 50) #aca estamos pasando el conjunto de datos y con nc el numero de cluster
  #cl2: es donde generamos la clase
  #sub_esc: conjunto de datos normalizados
  aux<-intCriteria(sub_esc,cl2$cluster,c("Dunn","Silhouette","Davies_Bouldin"))
  #cl2$cluster: etiqueta de cluster
  #c("Dunn","Silhouette","Davies_Bouldin")) lista de los indices que nosotros queremos que nos construya
  #Indice de Dunn a la columna 2
  evaluacion[nc-min_nc+1, 2] <- D <-aux$dunn
  #[nc-min_nc+1, 2] es la posicion fila columna
  # Indice de la Silhouette a la columna 3
  evaluacion[nc-min_nc+1, 3] <- S <-aux$silhouette
  # Indice de Davies Bouldin a la columna 4
  evaluacion[nc-min_nc+1, 4] <- DB <-aux$davies_bouldin
}

# Reemplazamos el nombre de columnas por el siguiente vector
#lo hacemos porque el reporte no tiene los nombres de columnas
colnames(evaluacion)<-c("k","Dunn","Silhouette","Davies_Bouldin")
print(evaluacion)

#¿cuando esta bien comprimido el cluster que definimos con el indice de dunn? cuando el valor es cercano a 0
#silueta cercano a 1 y que no sea negativo, entre mas cercano a 0 o negativo es que esta mal clasificado
#db a mayor numero de indice era mejor el cluster


# calculamos el rango de x e y
#entre que valores se mueve
xrange <- range(evaluacion[,1])
yrange <- range(evaluacion[,2:4])


plot(xrange, yrange, type="n", xlab="Numero de clusters",
     ylab="indices de validacion" )

colors <- c("red","blue","green")
linetype <- c(1:3)
plotchar <- seq(18,18+3,1)

# agregamos las lineas
for (i in 1:3) {
  lines(evaluacion[,1], evaluacion[,i+1], type="b", lwd=1.5,
        lty=linetype[i], col=colors[i], pch=plotchar[i])
}


title("Metricas de evaluacion")
# Agregamos la leyenda
legend(x = 7,y=0.95, c("D", "S","DB"), cex=0.65, col=colors,
       pch=plotchar, lty=linetype, title="Indices")


###Definir perfilamiento de los cluster

# Metodo del codo
codo <- scale(subdatos[c(-1)], center = TRUE, scale = TRUE)
# Calculo del metodo del k optimo en k desde el 2 hasta el 10
k.max <- 10
#Se calculara el tot.withinss que es el error dentro del cluster total
#Es la suma de todos los cluster que vamos a generar, en este caso el numero de cluster va a ir de
#del 2 al numero 10
wss <- sapply(2:k.max, function(k){kmeans(codo, k, 
                                          nstart=50,
                                          iter.max = 15 )$tot.withinss})

#para ver el error de cada uno de los nodos
wss 
# 46922.37 37711.80 33200.76 29377.81 26423.88 23909.36 22385.90 21136.90 20145.06

# graficamos el numero de cluster con su SSE correspondiente graficamos el error
plot(1:(k.max-1), wss,
     type="b", pch = 19, frame = FALSE, 
     xlab="numero de clusters",
     ylab="SST dentro de los grupos",
     main = "Metodo del codo")

# en la grafica se sugiere 4 cluster ya que ahí bajó considerablemente el error







