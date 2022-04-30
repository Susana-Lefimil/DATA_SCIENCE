from ast import Delete


recordatorios = [['2021-01-01', "11:00", "Levantarse y ejercitar"],
 ['2021-05-01', "15:00", "No trabajar"],
 ['2021-07-15', "13:00", "No hacer nada es feriado"],
 ['2021-09-18', "16:00", "Ramadas"],
 ['2021-12-24', "00:00", "Navidad"]]   

# Output
print(recordatorios)

#Agregue un evento el 2 de Febrero de 2021 a las 6 de la mañana para “Empezar el Año”.
emp=['2021-02-02',"06:00","Empezar el año"]
recordatorios.insert(1, emp)
print(recordatorios)

#Al revisar los eventos, nota un error, ya que el 15 de Julio no es feriado. Editar de tal manera que sea el 16 de Julio

print(recordatorios[3])
print(recordatorios[3][0])
recordatorios[3][0]='2021-07-16'
print(recordatorios[3])

# Lamentablemente le tocará trabajar el día del trabajo. Elimine el evento del día del trabajo
print(recordatorios[2])

recordatorios.pop(2)
print(recordatorios)

#Agregue una cena de Navidad y de Año Nuevo cuando corresponda. Ambas a las 22 hrs.
navidad=['25-12-2021',"22:00","Cena Navidad"]
nuevo=['30-12-2021',"22:00","Cena Año Nuevo"]

recordatorios.insert(4,navidad)
print(recordatorios)
recordatorios.append(nuevo)

print(recordatorios)