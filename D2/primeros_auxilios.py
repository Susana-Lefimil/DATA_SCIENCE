
valor1 = str(input("Responde a estimulos? (Si/No): "))
#print(valor1)

if valor1 == 'Si' or valor1 == 'SI' or valor1 == 'si':
   print("Valorar la necesidad de llevarlo al hospital mas cercano")
   print("Fin")
elif valor1== 'No' or valor1 == 'NO' or valor1 == 'no':
   print("Abrir la vía aerea")
   valor2 = str(input("Respira? (Si/No): "))
   if valor2 == 'Si' or valor2 == 'SI' or valor2 == 'si':
        print("Permitirle posicion de suficiente ventilacion")
        print("Fin")
   elif valor2== 'No' or valor2 == 'NO' or valor2 == 'no':
        print("Administrar 5 ventilaciones y llamar a ambulancia")
        valor3 = str(input("Signos de vida? (Si/No): "))
        while valor3 != "":
            if valor3 == 'Si' or valor3 == 'SI' or valor3 == 'si':
                print("Reevaluar la espera de la ambulancia")
                valor4 = str(input("Llego la ambulancia? (Si/No): "))
                if valor4 == 'No' or valor4 == 'NO' or valor4 == 'no':
                    valor3 = str(input("Signos de vida? (Si/No): "))
                elif valor4 == 'Si' or valor4 == 'SI' or valor4 == 'si':
                    valor3=''
                    print("Fin")
            elif valor3 == 'No' or valor3 == 'NO' or valor3 == 'no':
                print("Administrar compresiones toraxicas hasta que llegue la ambulancia")
                valor5 = str(input("Llego la ambulancia? (Si/No): "))
                if valor5 == 'No' or valor5 == 'NO' or valor5 == 'no':
                    valor3 = str(input("Signos de vida? (Si/No): "))

                elif valor5 == 'Si' or valor5 == 'SI' or valor5 == 'si': 
                    valor3=''
                    print("Fin")


            