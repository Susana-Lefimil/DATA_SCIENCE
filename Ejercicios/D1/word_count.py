

with open("C:/Users/Susana/Desktop/DL/Fundamentos Python/lorem_ipsum.txt", "r") as file:
    texto=file.read()
print(texto)

caract=set(texto)
spalab=texto.split(" ")
print(spalab)
palabras= set(spalab)
print("Numero de caracteres: ", len(caract))
print("Numero de palabras: ", len(palabras))