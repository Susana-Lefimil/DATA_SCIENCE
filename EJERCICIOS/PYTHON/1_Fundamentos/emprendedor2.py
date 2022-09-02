print("Ingresaro solo valores numéricos para el buen funcionamiento del programa")

P = float(input("Ingrese precio de suscripción: "))
U_n = float(input("Ingrese número de usuarios normales: "))
U_p = float(input("Ingrese número de usuarios premium: "))
GT = float(input("Ingrese  gasto total: "))

utilidades = ((P * U_n) + ((P*1.5)*U_p)) - GT

print ("Utilidades : ", utilidades)