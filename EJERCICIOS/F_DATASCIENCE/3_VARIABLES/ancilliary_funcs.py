
def retorna_valores(df):
    variables_continuas = df.select_dtypes(include=['float64'])
    print("Medidas desctiptivas de variables continuas")
    print(display(variables_continuas.describe()))
    variables_discretas = df.select_dtypes(include=['int64'])
    print("Freecuencia de variables discretas")
    for i in variables_discretas.columns:
        print(display(df[i].value_counts()))

def obs_perdidas(dataframe, var, print_list=False, semilla=0):
    casos_perdidos = dataframe[var].isna()
    if True in casos_perdidos.values:
        cantidad_casos_perdidos = casos_perdidos.value_counts()[True]
        porcentaje_casos_perdidos = dataframe[var].isna().value_counts('%')[True]
    else:
        cantidad_casos_perdidos = 0
        porcentaje_casos_perdidos = 0
    if print_list:
        return dataframe[casos_perdidos]
    else:
        return {"casos perdidos": cantidad_casos_perdidos, "porcentaje": round(porcentaje_casos_perdidos,3)} 
def grafica_histograma(sample_df, full_df, var, sample_mean=False, true_mean=False):
    sample_df = sample_df[var].dropna()
    
    plt.hist(sample_df, density=False)
    
    #aplicamos las condiciones del desafío
    if sample_mean:
        plt.axvline(sample_df.mean(), color='tomato', label="Sample mean")
    if true_mean:
        plt.axvline(full_df[var].dropna().mean(), color='yellow', label="True mean")
    plt.title(f"Histograma de la variable {var}")
    plt.xlabel(var)
    plt.legend()

def grafica_dotplot(sample_df, full_df, plot_var, plot_by, global_stats=False, static='mean'):
    plt.title(f"{plot_var} - {plot_by}")
    plt.xlabel(plot_var)
    plt.ylabel(plot_by)
    
    if global_stats:
        df_dropna = full_df[full_df[plot_var].notna()]
    else:
        df_dropna = sample_df[sample_df[plot_var].notna()]
        
    if static == 'mean':
        group_mean = df_dropna.groupby(plot_by)[plot_var].mean()
        plt.axvline(df_dropna[plot_var].mean(), color='tomato', label='mean')
        plt.legend()  
        return plt.plot(group_mean.values, group_mean.index, 'o')
    else:
        group_median = df_dropna.groupby(plot_by)[plot_var].median()
        plt.axvline(df_dropna[plot_var].median(), color='yellow', label='median')
        plt.legend()
        return plt.plot(group_median.values, group_median.index, 'o')
