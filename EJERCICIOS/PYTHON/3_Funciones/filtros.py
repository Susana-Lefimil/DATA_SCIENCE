import sys
precios = {'Notebook': 700000,
'Teclado': 25000,
'Mouse': 12000,
'Monitor': 250000,
'Escritorio': 135000,
'Tarjeta de Video': 1500000}

umbral=float(sys.argv[1])
#val="mayor"
#val=str(sys.argv[2])
try:
        val=str(sys.argv[2]).lower()
except IndexError:     
        val="mayor"

def filtra (u, v):
    salida=""
    if v!="menor" and v!="mayor":
        print("Lo sentimos, no es una operación válida")

    else:
        for clave, valor in precios.items():
            if valor>u and v=="mayor":
                #print(clave)
                salida +=  str(clave) + ", "
            
            elif valor<u and v=="menor":
                salida +=  str(clave) + ", "
        salida=salida[:-2]
        print(f'Los productos mayores al umbral son: ' + salida)
    

filtra(umbral, val)