def choose_level(n_pregunta, p_level):
    if n_pregunta <= p_level:
        level= 'basicas'
    elif n_pregunta <=p_level*2:
        level= 'intermedias'
    else:
        level= 'avanzada'
   
    
    return level

if __name__ == '__main__':
    # verificar resultados
    print(choose_level(2, 2)) # básicas
    print(choose_level(3, 2)) # intermedias
    print(choose_level(7, 3)) # avanzadas
    print(choose_level(4, 3)) # intermedias