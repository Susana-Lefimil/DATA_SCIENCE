print("Ingresaro solo valores numéricos para el buen funcionamiento del programa")
P = float(input("Ingrese precio de suscripción: "))
U = float(input("Ingrese número de usuarios: "))
GT = float(input("Ingrese  gasto total: "))

utilidades = P * U - GT

pas=float(input("Ingrese Utilidades anteriores: "))

razon=utilidades/pas

print ("Utilidad actual : ", utilidades)
print ("Utilidad pasada : ", pas)
print ("Razon entre utilidades (actual/pasada): " , round(razon,2))