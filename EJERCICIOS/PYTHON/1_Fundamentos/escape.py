import math

r = float(input("Ingrese el radio en Kilómetros: "))

g = float(input("Ingrese la constante g: "))


v=round(math.sqrt(2*g*(r*1000)),2)


print(f"La velocidad de Escape es {v} [m/s]")
