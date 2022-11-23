
def variables_insp(df):
    """Devuelve frecuencias de las variables de un dataframe """
    v_categoricas = []
    for n, i in enumerate(df):
        if df[i].dtypes =="object":
            #print(df[i].dtypes)
            #print(df[i])
            v_categoricas.append(i)
    for i in v_categoricas:
        print("\n",i)
        print(df[i].value_counts())

def retorna_valores(df):
    """Imprime variables discretas (números enteros) de un dataframe """
    variables_discretas = df.select_dtypes(include=['int64'])
    print("Freecuencia de variables discretas")
    for i in variables_discretas.columns:
        print(display(df[i].value_counts()))      
        
def var_categoricas(df):
    """Imprime variables categóricas de un dataframe  """
    v_cat = []
    for n, i in enumerate(df):
        if df[i].dtypes =="object":
            #print(df[i].dtypes)
            #print(df[i])
            v_cat.append(i)
    return v_cat


       
      
        
