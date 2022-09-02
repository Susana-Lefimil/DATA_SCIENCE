
def factorial (n):
    arr=[]
    while n>0:
        arr.append(n)
        n-=1
        #print(arr)
    f=1
    for i in arr:
        f*=i
        #print(f)
    return f
#factorial(5)


def productoria(arg):
    p=1
    for i in arg:
        p*=i
        #print(p)
    return p
#productoria(4,6,7,4,3)

def calcular(fact_1 = 5, prod_1 = [4, 6, 7, 4, 3], fact_2 = 6):
    f1=factorial(fact_1)
    p1=productoria(prod_1)
    f2=factorial(fact_2)

    print(f'El factorial de ' + str(fact_1) + ' es ' + str(f1))
    print(f'La productoria de ' + str (prod_1)+ ' es ' + str(p1))
    print(f'El factorial de ' + str(fact_2) + ' es ' + str(f2))

calcular()



