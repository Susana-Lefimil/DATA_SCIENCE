
#Se carga base de datos datos_fifa2019
test.csv <- data.table::fread("C:/Users/Susana/Desktop/Data Science/CLASES/12_IntroSQL/data_fifa19.csv", nrows = 1000000)

head(test.csv)
View(test.csv)



#Conexion de r a workbench

if(!"RMariaDB" %in% (.packages())){require(RMariaDB)}
database <- dbConnect(MariaDB(), user = "root", password = ("MYSQL_PASSWORD"), dbname = "fifa", host = "localhost")
dbListTables(database)
#Detalle de variables
str(test.csv)
#listado de nombres de variables para crear la tabla en Workbench (MySQL)
names (test.csv)

#mysql no acepta espacios en los nombres de columnas, se agrega guiones en los espacios de nombres de variables

colnames(test.csv) <- gsub('\\s', '_', colnames(test.csv))
test.csv
colnames(test.csv)



#Cambio Formato Fecha Joinded
dat <- test.csv$Joined
dat
dat1 <-substr(dat, 1, 3)
dat1
dat2 <-substr(dat, 4, 6)
dat2
dat2 <- as.character(gsub(",", "", dat2))
dat2
dat3 <-(substr(dat, 8,12))
dat3

library(tidyr)
fecha_j <- paste(dat2, dat1, dat3)
fecha_j

fecha_j <-as.Date(fecha_j, "%d %b %Y") ## formato
class(fecha_j)
fecha_join<- as.Date(fecha_j)

class(fecha_join)
test.csv <-cbind(test.csv,fecha_join) 

#Creamos la tabla en MySQL con la variables de la base de datos y el tipo de variable (Tabla=fifa_table)

query<-"CREATE TABLE fifa_table (
  ID                      		INT,
 Name                    		TEXT,
 Age                     		INT,
 Photo                   		TEXT,
 Nationality             		TEXT,
 Flag                    		TEXT,
 Overall                 		INT,
 Potential               		INT,
 Club                    		TEXT,
 Club_Logo               		TEXT,
 Value                   		VARCHAR(50),
 Wage                    		VARCHAR(50),
 Special                 		INT,
 Preferred_Foot          		TEXT,
 International_Reputation		INT,
 Weak_Foot               		INT,
 Skill_Moves             		INT,
 Work_Rate               		TEXT,
 Body_Type               		TEXT,
 Real_Face               		TEXT,
 Position                		TEXT,
 Jersey_Number           		INT,
 Joined                  		TEXT,
 Loaned_From             		TEXT,
 Contract_Valid_Until    		TEXT,
 Height                  		TEXT,
 Weight                  		TEXT,
 LS                      		TEXT,
 ST                      		TEXT,
 RS                      		TEXT,
 LW                      		TEXT,
 LF                      		TEXT,
 CF                      		TEXT,
 RF                      		TEXT,
 RW                      		TEXT,
 LAM                     		TEXT,
 CAM                     		TEXT,
 RAM                     		TEXT,
 LM                      		TEXT,
 LCM                     		TEXT,
 CM                      		TEXT,
 RCM                     		TEXT,
 RM                      		TEXT,
 LWB                     		TEXT,
 LDM                     		TEXT,
 CDM                     		TEXT,
 RDM                     		TEXT,
 RWB                     		TEXT,
 LB                      		TEXT,
 LCB                     		TEXT,
 CB                      		TEXT,
 RCB                     		TEXT,
 RB                      		TEXT,
 Crossing                		INT,
 Finishing               		INT,
 HeadingAccuracy         		INT,
 ShortPassing            		INT,
 Volleys                 		INT,
 Dribbling               		INT,
 Curve                   		INT,
 FKAccuracy              		INT,
 LongPassing             		INT,
 BallControl             		INT,
 Acceleration            		INT,
 SprintSpeed             		INT,
 Agility                 		INT,
 Reactions               		INT,
 Balance                 		INT,
 ShotPower               		INT,
 Jumping                 		INT,
 Stamina                 		INT,
 Strength                		INT,
 LongShots               		INT,
 Aggression              		INT,
 Interceptions           		INT,
 Positioning             		INT,
 Vision                  		INT,
 Penalties               		INT,
 Composure               		INT,
 Marking                 		INT,
 StandingTackle          		INT,
 SlidingTackle           		INT,
 GKDiving                		INT,
 GKHandling              		INT,
 GKKicking               		INT,
 GKPositioning           		INT,
 GKReflexes              		INT,
 Release_Clause          		TEXT,
 fecha_join                DATE
);"

results <- dbSendQuery(database, query)
dbClearResult(results)

dbReadTable(database,"fifa_table")

#Ya creada la tabla en MySQL seteamos una carpeta y guardamos las base test.csv como Prueba1.csv
#de esta última se poblará la informacion en Mysql a través de R

setwd("C:/Users/Susana/Desktop/Data Science/CLASES/12_IntroSQL")
write.csv(test.csv, file="Prueba1.csv")

#Creamos un index
index <- 0
chunkSize <- 100000

#Creamos un vector con el nombre de las columnas en orden del archivo

col_names <- c( "ID"       ,     "Name"  ,     "Age"    ,"Photo"   ,  "Nationality" ,   "Flag"  , "Overall"  ,  "Potential"  ,  "Club" , "Club_Logo"  ,   "Value" , "Wage" , "Special"  ,  "Preferred_Foot"  , "International_Reputation" , "Weak_Foot" ,   "Skill_Moves"   ,  "Work_Rate"       , "Body_Type"  ,  "Real_Face"  ,   "Position"  , "Jersey_Number"  ,  "Joined"    , "Loaned_From"  , "Contract_Valid_Until"  ,   "Height"   ,   "Weight"       , "LS"     ,    "ST"   ,    "RS" , "LW" ,  "LF"    ,   "CF"  , "RF"    ,  "RW"   , "LAM"    , "CAM" ,   "RAM"   ,   "LM" ,"LCM"  ,  "CM"   ,   "RCM"  ,"RM"  ,  "LWB"   , "LDM" , "CDM"   , "RDM"    ,  "RWB" ,"LB"    ,    "LCB"   ,  "CB" , "RCB"   ,   "RB"   ,   "Crossing"  , "Finishing" ,  "HeadingAccuracy" , "ShortPassing" , "Volleys" ,  "Dribbling" ,  "Curve"  , "FKAccuracy" ,  "LongPassing" ,  "BallControl", "Acceleration" , "SprintSpeed" ,  "Agility"  ,  "Reactions"  ,   "Balance"  , "ShotPower"  ,"Jumping"  ,   "Stamina"   ,  "Strength" , "LongShots" ,  "Aggression" ,  "Interceptions", "Positioning" , "Vision" , "Penalties"  , "Composure" , "Marking" ,  "StandingTackle" , "SlidingTackle" ,  "GKDiving" , "GKHandling" , "GKKicking" , "GKPositioning" , "GKReflexes" , "Release_Clause" , "fecha_join" )


#Abrimos la conexion del archivo
con <- file(description="C:/Users/Susana/Desktop/Data Science/CLASES/12_IntroSQL/Prueba1.csv",open="r")   

#Leemos la data
data_r <- read.table(con, nrows=chunkSize, header=F, fill=TRUE, sep=",", quote = '"', col.names = col_names)

#Poblamos la tabla en Mysql
dbWriteTable(database, value = data_r, row.names = FALSE, name = "fifa_table", append = TRUE)


#El procedimiento anterior se repite en un bucle para verificar que todo este cargado 
while (nrow(data_r) > 0) {
  index <- index + 1
  print(paste('Processing rows:', index * chunkSize))
  
  data_r <- read.table(con, nrows=chunkSize, skip=0, header=FALSE, fill = TRUE, sep=",", col.names = col_names)
  
  dbWriteTable(database, value = data_r, row.names = FALSE, name = "fifa_table", append = TRUE)
}

#Se cierra la conexion. 
close(con)








