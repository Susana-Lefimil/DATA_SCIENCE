ciclo=True
valor1 = str(input("Responde a estimulos? (Si/No): ")).lower()
if valor1=="si":
    print("Valorar la necesidad de llevarlo al hospital mas cercano")
    print("Fin")
elif valor1 =='no':
    print("Abrir la vía aerea")
    valor2 = str(input("Respira? (Si/No): ")).lower()
    if valor2 == 'si' :
        print("Permitirle posicion de suficiente ventilacion")
        print("Fin")
    elif valor2 =='no':
        print("Administrar 5 ventilaciones y llamar a ambulancia")
        while ciclo==True:
            valor3 = str(input("Signos de vida? (Si/No): ")).lower()
            if valor3=='si':
                print("Reevaluar la espera de la ambulancia")
                valor4 = str(input("Llego la ambulancia? (Si/No): ")).lower()
                if valor4 =='si':
                    print("Fin") 
                    break
            elif valor3 =='no':
                print("Administrar compresiones toraxicas hasta que llegue la ambulancia")
                valor4 = str(input("Llego la ambulancia? (Si/No): ")).lower()
                if valor4 =='si': 
                    print("Fin")
                    break
    