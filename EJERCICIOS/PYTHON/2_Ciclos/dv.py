
from ast import Mod


rut = int(input ("Ingresa tu RUT sin puntos ni dígito verificador: "))


num = [int(a) for a in str(rut)]

#print(num)
num.reverse()
#print(num)
multi=2
suma=0

for n in num:
    #print (n)
    cont= n * multi
    multi +=1
    suma= suma +cont
    if multi>7:
        multi=2

        
#print (suma)

mod= suma % 11
#print (mod)
dig= 11-mod
#print (dig)

if dig == 10:
    print ("Su dígito verificador es K")
elif dig ==11:
    print ("Su dígito verificador es 0")
else:
     print ("Su dígito verificador es ", dig)
