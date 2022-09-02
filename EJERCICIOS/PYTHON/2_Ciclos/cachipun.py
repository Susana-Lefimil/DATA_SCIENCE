 
import random
import sys

mylist = ["tijera", "piedra", "papel"]

compu = random.choice(mylist)
user = sys.argv[1]


user = user.lower()


if compu == user:
    print ("Tu jugaste ", user, "\nComputador jugó ", compu)
    print ("Empate")
elif compu =='tijera' and user =='papel':
    print ("Tu jugaste ", user, "\ncomputador jugó ", compu)
    print ("Perdiste!!")
elif compu =='tijera' and user =='piedra':
    print ("Tu jugaste ", user, "\nComputador jugó ", compu)
    print ("Ganaste!!")
elif compu =='papel' and user =='piedra':
    print ("Tu jugaste ", user, "\nComputador jugó ", compu)
    print ("Perdiste")
elif compu =='papel' and user =='tijera':
    print ("Tu jugaste ", user, "\nComputador jugó ", compu)
    print ("Ganaste!!")
elif compu =='piedra' and user =='tijera':
    print ("Tu jugaste ", user, "\nComputador jugó ", compu)
    print ("Perdiste!!")
elif compu =='piedra' and user =='papel':
    print ("Tu jugaste ", user, "\nComputador jugó ", compu)
    print ("Ganaste!!")
else:
    print ("Argumento inválido: Debe ser piedra, papel o tijera.")

