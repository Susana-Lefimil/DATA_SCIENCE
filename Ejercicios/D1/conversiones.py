##a Sol peruano: 0.0046
##a Peso Argentino: 0.093
##a Dolar Americano: 0.00013


valor = int(input("Ingrese Pesos chilenos: "))

sol=valor*0.0046
arg=valor*0.093
dol=valor*0.0013

print("Los ", valor, "pesos equivalen a: ", round(sol,3),"Soles")
print("Los ", valor, "pesos equivalen a: ", round(arg,3), "Pesos Argentinos")
print("Los ", valor, "pesos equivalen a: ", round(dol, 3), "Dolares")