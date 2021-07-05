library(caret)
library(rpart)
library(rpart.plot)
library(ggplot2)
library(tidyverse)
library(ResourceSelection)
library(ROCR)
library(e1071)
# Seteo
setwd("C:/Users/Susana/Desktop/Data Science/CLASES/15_Modelos supervisados")
# lectura del archivo
data<-read.table("credit_scoring.txt",header=T)

# resumen con estadistica descriptiva
data%>%summary
data%>%str
# es un conjunto de datos que busca registrar los default_payment_next_months mensuales del año 2005 de un listado de clientes
# Las variables que componen esta base son toda Integer. Si analizamos más de cerca, las variables
#, SEX, EDUCATION, MARRIAGE, default_payment_next_month podrian ser categoricas.
#Se verifica esto a continuacion

subdatos<-data %>%select(SEX, EDUCATION, MARRIAGE, default_payment_next_month,PAY_0,PAY_2, PAY_3, PAY_4, PAY_5, PAY_6 )


summary(subdatos)

#Ver cuantos niveles tienen estas variables
n_distinct(data$SEX)
n_distinct(data$EDUCATION)
n_distinct(data$MARRIAGE)
n_distinct(data$default_payment_next_month)
n_distinct(data$PAY_0)
n_distinct(data$PAY_2)
n_distinct(data$PAY_3)
n_distinct(data$PAY_4)
n_distinct(data$PAY_5)
n_distinct(data$PAY_6)

#Las transformamremos a factor
data <- data %>% mutate(SEX = as.factor(SEX),
                        EDUCATION = as.factor(EDUCATION),
                        MARRIAGE = as.factor(MARRIAGE),
                        default_payment_next_month = as.factor(default_payment_next_month),
                        PAY_0= as.factor(PAY_0),
                        PAY_2= as.factor(PAY_2),
                        PAY_3= as.factor(PAY_3),
                        PAY_4= as.factor(PAY_4),
                        PAY_5= as.factor(PAY_5),
                        PAY_6= as.factor(PAY_6),
  )
        
#para visualizar mejor las variables se transforman en factores
data%>%summary
data%>%str

#REGRESION LOGISTICA

#como es regresion logistica 

ccdata<-data
ccdata%>%str()

# REVISIN DE DATOS FALTANTES
nombres <- names(ccdata)
sum_name <- NULL
name <- NULL
for (i in 1:length(nombres)){
  name[i] = nombres[i]
  sum_name[i] = sum(is.na(ccdata[,nombres[i]]))
}
nulls <- data.frame(name,sum_name)
colnames(nulls) <- c("nombre_columna","cantidad_nulos")

#Sin datos nulos

#Oulier valores numericos

summary(ccdata)

#Outlier
data_num <- data %>% select(LIMIT_BAL,	AGE,	BILL_AMT1,	BILL_AMT2,	BILL_AMT3,	BILL_AMT4,	BILL_AMT5,	BILL_AMT6,
                                PAY_AMT1,	PAY_AMT2,	PAY_AMT3,	PAY_AMT4,	PAY_AMT5,	PAY_AMT6)
summary(data_num)

#REGRESION LOGISTICA
# ESTANDARIZAMOS LAS VARIABLES NUMERICAS
#mutate if sirve para escalar variables si cumplen con un criterio (is.numeric)
data_std <- mutate_if(ccdata, is.numeric, scale)
#otra forma
#select_if(data_std , is.numeric)%>% cor

# REVISAMOS CORRELACIONES
data_std %>%
  select(LIMIT_BAL,	AGE,	BILL_AMT1,	BILL_AMT2,	BILL_AMT3,	BILL_AMT4,	BILL_AMT5,	BILL_AMT6,
         PAY_AMT1,	PAY_AMT2,	PAY_AMT3,	PAY_AMT4,	PAY_AMT5,	PAY_AMT6) %>%
  cor()


#quitamos las variable BILL_AMT ya que estan altamente correlacionada entre ellas y tambien con AGE, dejarmos solo BILL_AMT6
data_std <- data_std %>% select(-BILL_AMT2,-BILL_AMT3,-BILL_AMT1,-BILL_AMT4,-BILL_AMT5)

#Se verifican nuevamente las correlaciones
data_std %>%
  select(LIMIT_BAL,	AGE,		BILL_AMT6,
         PAY_AMT1,	PAY_AMT2,	PAY_AMT3,	PAY_AMT4,	PAY_AMT5,	PAY_AMT6) %>%
  cor()


data_std%>%dim
#tenemos 3000 datos y 19 columnas.
#donde una de las columnas es nuestra variable de respuesta.
data_std%>%summarise(default_payment_next_month)
#antes de separara vamos a agrupar. 
data_std%>%group_by(default_payment_next_month)%>% summarise(conteo=n())
#esta muestra esta relativamente balanceada
23364/(23364+6636)
#tenemos 0.77 % de la base targ

# Ya filtramos las variables correlacionadas, ahora tenemos que buscar si existen atributos que sean
#indiferentes al modelo
#Se sacan todas las variables sobre el monto pagado y se deja solo el ultimo estado de pago PAY_0

data_std <- data_std %>% select( -PAY_AMT3, -PAY_AMT1,   -PAY_AMT5, -PAY_AMT6,	-PAY_AMT2,	-PAY_AMT4, -PAY_2, -PAY_3, -PAY_4, -PAY_5, -PAY_6)
#Resumen de la base
data_std%>%head()

#ahora vamos a partir por separar el conjunto de entrenamiento con el de test
# SEPARAMOS EL CONJUNTO DE ENTRENAMIENTO Y EL DE PRUEBA
#sample genera muestra aleatoria
sub <- sample(nrow(data_std), floor(nrow(data_std) * 0.7))
train<-data_std[sub, ]
test<-data_std[-sub, ]

nrow(data_std)
floor(nrow(data_std) * 0.7)

#los 30000 lo multiplicamos por 0.7 y nos quedamos con la parte entera (floor)
# es decir con 21000 datos para validar, entrenar el modelo.
#el resto para testear el modelo.

sample(nrow(data_std), floor(nrow(data_std) * 0.7))
# sample nos dira cuales son los indices que yo tengo que seleccionar que recayeron para entrenar el modelo

#explorando 
train%>%group_by(default_payment_next_month)%>% summarise(conteo=n())
4668/16332
#sigue la proporcion de 1:3, esta separado relativamente bien

test%>%group_by(default_payment_next_month)%>% summarise(conteo=n())

#lo que si o si debe estar balanceado es el conjunto de entrenamiento
#debemos validar que se cumpla una estandarizacion.

# SELECCIN DE VARIABLES
# MODELO NULO: MODELO SIN ATRIBUTOS
model_nulo = glm(default_payment_next_month~1,data= train,family=binomial)
model_nulo
# El modelo nulo nos va a decir como se comporta el AIC, el intercepto

# MODELO COMPLETO: MODELO CON TODOS LOS ATRIBUTOS
model_full = glm(default_payment_next_month~.,data= train,family=binomial)
model_full

#podemos ver el comportamiento de cada variable. 



# METODO FORWARD
step(model_nulo, scope=list(lower=model_nulo, upper=model_full),direction="forward")
#primero pasamos el modelo nulo, luego la lista de compraracion del modelo vacio con el modelo completo
#de como parte a como debe terminar


#estas  variables deberian definir mi modelo final
model_forward=glm(formula = default_payment_next_month ~ PAY_0 + LIMIT_BAL + 
                    EDUCATION + BILL_AMT6 + MARRIAGE + SEX, family = binomial, 
                  data = train)
#este es mi modelo de regresion logistica


# METODO BACKWARD aca pasamos el modelo completo
step(model_full, data=train, direction="backward")

model_backward= glm(formula = default_payment_next_month ~ LIMIT_BAL + SEX + 
                      EDUCATION + MARRIAGE + PAY_0 + BILL_AMT6, family = binomial, 
                    data = train)


#aca la diferencia cambia el orden de las variables, pero son las mismas variables 



# METODO STEPWISE
step(model_nulo, scope = list(upper=model_full), data= train,direction="both")

model_stepwise=  glm(formula = default_payment_next_month ~ PAY_0 + LIMIT_BAL + 
                       EDUCATION + BILL_AMT6 + MARRIAGE + SEX, family = binomial, 
                     data = train)

#Comparacion
model_forward
model_backward
model_stepwise


# Hosmer-Lemeshow test


###############le pasamos el modelo stepwise
# VERIFICAMOS EL TEST DE H-L
hoslem.test(model_stepwise$y,fitted(model_stepwise),g=10)

#no se rechaza h0, cumple el estandar de trabajar con estas variables.
# si se rechaza probablemente exista colinealidad o variables correlacionadas.


# OBTENEMOS LAS PREDICCIONES DEL MODELO DE REGRESIÃN LOGÃSTICA
#vamos a pasar el objeto del modelo model_stepwise
#pred = predict(model_stepwise, newdata=test, type="response")
pred = predict(model_stepwise, newdata=test%>%select(-default_payment_next_month), type="response")
pred

# CONFIGURAMOS QUE TODAS LAS PROBABILIDADES MAYORES O IGUALES A 0.5 SE CLASIFICARÃN COMO 1
pred_test = ifelse(pred>=0.5,1,0)
#Matriz de confucion con respecto al 0.5
pred_test_table<-table(test%>% mutate(pred_default=pred_test)%>%select(default_payment_next_month,pred_default))
(pred_test_table[1]+pred_test_table[4])/sum(pred_test_table)
#esto sería un accuracy del 82% , la diagonal sobre el conjunto total de datos
#Precision del modelo es de  un 82 % 

# LA MATRIZ DE CONFUSIÃN (REQUIERE LIBRERIA CARET) otra forma
confusionMatrix(as.factor(pred_test), as.factor(test$default_payment_next_month))
(626)/(626 +  281)
# OBTENEMOS LAS CURVAS ROC
roc_pred = prediction(pred, test$default_payment_next_month)
roc_perf = performance(roc_pred, measure = "tpr", x.measure = "fpr")
test%>%count
#9000 puntos


# GRÃFICAMOS LA CURVA ROC
plot(roc_perf,
     colorize = TRUE,
     text.adj = c(-0.2,1.7),
     print.cutoffs.at = seq(0,1,0.1))
abline(a=0,b=1,col="brown")

#cuando la curva es similar a la diagonal el modelo es relativamente malo


# OBTENEMOS EL ÃREA BAJO LA CURVA 
auc = performance(roc_pred, measure = "auc")
auc = auc@y.values[[1]]
auc
#es una curva roc del 90%, bastante buena. nos valida en conjunto con el accuracy que el modelo es correcto

#graficando la precision y el recall
perf<-performance(roc_pred, "prec", "rec")
plot(perf,
     avg="threshold",
     colorize=TRUE,
     lwd=3,
     main="Precision and Recall")

#si movemos a la izquierda ganamos recall, a la derecha precision


#ARBOL DE DECISION 
library(caret)
library(rpart)
library(rpart.plot)
library(ggplot2)
library(tidyverse)
library(ROCR)
# Seteo
setwd("C:/Users/Susana/Desktop/Data Science/CLASES/15_Modelos supervisados")
# lectura del archivo
data<-read.table("credit_scoring.txt",header=T)
data <- data %>% mutate(SEX = as.factor(SEX),
                        EDUCATION = as.factor(EDUCATION),
                        MARRIAGE = as.factor(MARRIAGE),
                        default_payment_next_month = as.factor(default_payment_next_month),
                        PAY_0= as.factor(PAY_0),
                        PAY_2= as.factor(PAY_2),
                        PAY_3= as.factor(PAY_3),
                        PAY_4= as.factor(PAY_4),
                        PAY_5= as.factor(PAY_5),
                        PAY_6= as.factor(PAY_6),
)

# SEPARACIN DEL CONJUNTO DE ENTRENAMIENTO Y DE PRUEBA
set.seed(2020)
sub <- sample(1:dim(data)[1],round(dim(data)[1]*0.75))
train<-data[sub, ] 
test<-data[-sub, ]
names(train)
# VERIFICAMOS EL BALANCEO DE NUESTRA VARIABLE RESPUESTA
# train
train %>% group_by(default_payment_next_month) %>% summarise(conteo=n())
5004/17496
# test
test %>% group_by(default_payment_next_month) %>% summarise(conteo=n())

# Construccion del Arbol 1 metodo de clasificacion
model_1 <- rpart(default_payment_next_month ~ ., 
                 data=train ,
                 method = "class")
plot(model_1,uniform=T,margin=0.2)
text (model_1, use.n = T, pretty = TRUE)
title("Entrenamiento arbol 1")
# graficamos con la libreria rpart
rpart.plot(model_1,cex=0.7)
predictions <- predict(model_1, test, type="class")

table(predictions)
#no da lo mismo que el arbol

# obtenemos la matriz de confusion del modelo 3 (requiere libreria caret)
confusionMatrix(predictions,test$default_payment_next_month)
535/(245+535)
#Importancia de las variables
model_1$variable.importance

model_1_2<- rpart(default_payment_next_month~PAY_0,
                  data=train,
                  method="class")

predictions <- predict(model_1_2, test, type="class")
confusionMatrix(predictions,test$default_payment_next_month)


# OBTENEMOS LAS CURVAS ROC
roc_pred = prediction(as.numeric(predictions), test$default_payment_next_month)
roc_perf = performance(roc_pred, measure = "tpr", x.measure = "fpr")

# GRÃFICAMOS LA CURVA ROC
plot(roc_perf,
     colorize = TRUE,
     text.adj = c(-0.2,1.7),
     print.cutoffs.at = seq(0,1,0.1))
abline(a=0,b=1,col="brown")

# OBTENEMOS EL ÃREA BAJO LA CURVA 
auc = performance(roc_pred, measure = "auc")
auc = auc@y.values[[1]]
auc




