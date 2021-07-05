SELECT * FROM fifa.fifa_table;

-- Pregunta 2
-- 1. Calcular la edad actual (2021) y construir el a˜no de nacimiento, con respecto a la edad
-- actual (2021). Asuma que la edad que aparece es la edad que cumpli´o o cumplir´ıa el
-- a˜no 2018. Muestre una muestra de 5 jugadores.
SELECT fifa_table.name, fifa_table.age as edad_2018,  fifa_table.age + 3 as edad_actual_2021
FROM fifa.fifa_table
order by rand()
limit 5;

-- 2. Pasar a pesos chilenos la clausula de salida, el salario y el valor del jugador. Muestre 5 jugadores.

-- Value,  WAGE y Release_Clause // quitamos las cadenas de los campos alfanumericos y se trasnforman las variables a valores en euros 
-- de acuerdo a su unidad (K) 1000 y (M) a 1000000, segun correspona. Para aislar  el valor numerico se usa substring y la informacion 
-- se vuelve a actualizar ahora en formato numerico en la variable original. 

UPDATE fifa.fifa_table SET 
fifa_table.Value= SUBSTRING(fifa_table.Value,2,length(fifa_table.Value)-4)*1000
WHERE fifa_table.Value LIKE '%k';
UPDATE fifa.fifa_table SET 
fifa_table.Value= SUBSTRING(fifa_table.Value,2,length(fifa_table.Value)-4)*1000000
WHERE fifa_table.Value LIKE '%M';
												
UPDATE fifa.fifa_table SET 
fifa_table.Wage= SUBSTRING(fifa_table.Wage,2,length(fifa_table.Wage)-4)*1000
WHERE fifa_table.Wage LIKE '%k';
UPDATE fifa.fifa_table SET 
fifa_table.Wage= SUBSTRING(fifa_table.Wage,2,length(fifa_table.Wage)-4)*1000000
WHERE fifa_table.Wage LIKE '%M';

UPDATE fifa.fifa_table SET 
fifa_table.Release_Clause= SUBSTRING(fifa_table.Release_Clause,2,length(fifa_table.Release_Clause)-4)*1000
WHERE fifa_table.Release_Clause LIKE '%k';
UPDATE fifa.fifa_table SET 
fifa_table.Release_Clause= SUBSTRING(fifa_table.Release_Clause,2,length(fifa_table.Release_Clause)-4)*1000000
WHERE fifa_table.Release_Clause LIKE '%M';                   

-- se seja los datos como 0 si son igual a '€ 0'
UPDATE fifa.fifa_table SET 
fifa_table.Release_Clause= 0
WHERE fifa_table.Release_Clause = '€ 0'; 
UPDATE fifa.fifa_table SET
fifa_table.Value= 0
WHERE fifa_table.Value= '€ 0';
UPDATE fifa.fifa_table SET
fifa_table.Wage= 0
WHERE fifa_table.Wage= '€ 0';
 
 -- Ahora las tres variables se pueden multiplicar por 858,12 para convertir euro a peso Chileno
SELECT fifa_table.name, fifa_table.Value * 858.12 as  Valor_jugador,
                         fifa_table.Wage * 858.12 as Salario, 
                         fifa_table.Release_Clause * 858.12 as Clausula_salida  
                         FROM fifa.fifa_table
                         limit 5;
				
-- 3. Calcule el salario medio de los jugadores de edad entre 25 y 30 a˜nos. Muestre 5 jugadores.
-- Promedio por cada grupo
SELECT fifa_table.age, AVG(fifa_table.wage) as salario_prom
FROM fifa.fifa_table
WHERE fifa_table.age>=25 and fifa_table.age<=30
group by fifa_table.age ;

-- Promedio total de entre 25 y 30
SELECT AVG(fifa_table.wage) as salario_prom_total
FROM fifa.fifa_table
WHERE fifa_table.age>=25 and fifa_table.age<=30 ;

-- 5 Jugadores al azar de entre 25 y 30
SELECT fifa_table.name, fifa_table.age, fifa_table.wage as salario
FROM fifa.fifa_table
WHERE fifa_table.age>=25 and fifa_table.age<=30
order by rand()
limit 5;

-- 4. Defina la cantidad de jugadores que se quedan sin contrato el a˜no 2020 y 2019.
SELECT COUNT(fifa_table.ID) as num_sincontrato
FROM fifa.fifa_table
WHERE fifa_table.Contract_Valid_Until=2020 or fifa_table.Contract_Valid_Until=2019;

-- 5. Calcule el m´aximo, m´ınimo y la media de la puntuaci´on general de los jugadores, por
-- Nacionalidad. Muestre 5 jugadores de nacionalidad Argentina

-- Min y Max por nacionalidad
SELECT fifa_table.Nationality, min(fifa_table.Overall) as Min, max(fifa_table.Overall) as Max
FROM fifa.fifa_table
group  by fifa_table.Nationality;

-- Promedio con 5 Jugadores argentinos
SELECT  fifa_table.Nationality, min(fifa_table.Overall) as Min, max(fifa_table.Overall) as Max
FROM fifa.fifa_table
WHERE fifa_table.Nationality='Argentina'
order by rand()
limit 5;

--  5 Jugadores argentinos
SELECT fifa_table.Name, fifa_table.Nationality, fifa_table.Overall as Puntaje
FROM fifa.fifa_table
WHERE fifa_table.Nationality='Argentina'
order by rand()
limit 5;

-- 6. Calcule el tiempo, en d´ıas, que lleva el jugador en su equipo. Muestre 5 observaciones
-- de jugadores de nacionalidad Chilena.

-- Se uso fecha_join la cual se creo en base a la informacion Joined, pero con el formato adecuado para operaciones con fechas.
-- Esta  se creo  en R antes de la migracion de informacion  a  MySQL
   
   SELECT fifa_table.Name, DATE(fifa_table.fecha_join) as Fecha_inicio, curdate() as Fecha_hoy, datediff(curdate(), fifa_table.fecha_join) as Dias_en_equipo
   FROM fifa.fifa_table;
   
   -- 5 Jugadores Chilenos
   SELECT fifa_table.Name, DATE(fifa_table.fecha_join) as Fecha_inicio, curdate() as Fecha_hoy, datediff(curdate(), fifa_table.fecha_join) as Dias_en_equipo
   FROM fifa.fifa_table
   WHERE fifa_table.Nationality='Chile'
   order by rand()
   limit 5;
   
