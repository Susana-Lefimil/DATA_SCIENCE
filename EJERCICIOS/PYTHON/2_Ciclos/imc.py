import sys

peso = float(sys.argv[1])
talla = float(sys.argv[2])

#print (peso)
#print (talla)

imc = peso/(talla/100)**2
d_imc = round(imc,2)
#print(d_imc)
#print (imc)


if d_imc <= 18.50:
    print("Su IMC es: ", d_imc)
    print("La clasificación OMS es Bajo peso")
elif d_imc>= 18.5 and d_imc<=25.00:
    print("Su IMC es: ", d_imc)
    print("La clasificación OMS es Adecuado")
elif d_imc>= 25.00 and d_imc<=30.00:
    print("Su IMC es: ", d_imc)
    print("La clasificación OMS es Sobrepeso")
elif d_imc>= 30.00 and d_imc<=35.00:
    print("Su IMC es: ", d_imc)
    print("La clasificación OMS es Obesidad grado 1")
elif d_imc>= 35.00 and d_imc<=40.00:
    print("Su IMC es: ", d_imc)
    print("La clasificación OMS es Obesidad grado 2")
elif d_imc>= 40.00:
    print("Su IMC es: ", d_imc)
    print("La clasificación OMS es Obesidad grado 3")
