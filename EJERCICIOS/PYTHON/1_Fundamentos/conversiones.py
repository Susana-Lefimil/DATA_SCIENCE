

##a Sol peruano: 0.0046
##a Peso Argentino: 0.093
##a Dolar Americano: 0.00013
import sys
  
sol=float(sys.argv[1])
arg=float(sys.argv[2])
dol=float(sys.argv[3])

#print("Argument List:", str(sys.argv))

valor = int(input("Ingrese Pesos chilenos: "))

sol=valor*sol
arg=valor*arg
dol=valor*dol

print("Los ", valor, "pesos equivalen a: ", round(sol,3),"Soles")
print("Los ", valor, "pesos equivalen a: ", round(arg,3), "Pesos Argentinos")
print("Los ", valor, "pesos equivalen a: ", round(dol, 3), "Dolares")