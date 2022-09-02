
from string import ascii_lowercase
#print(ascii_lowercase)


pas = str(input("Ingrese la contraseña:"))
pas = pas.lower()

cont= 0
i = 0
j = 0

#print(len(pas))
c= len(pas)
g= len(ascii_lowercase)
#print(len(ascii_lowercase))

while i< c and j<g:
    
    if pas[i] != ascii_lowercase[j]:
            cont +=1
            j +=1
            #print ("pass", i)
    elif pas[i] == ascii_lowercase[j]:
             cont +=1
             i +=1
             j =0
             #print ("dicci", j)
    
    
print("La contraseña fue forzada en ",  cont, "intentos")



            
      

       
                 





    
         

       






