import requests, json
from string import Template
url = "https://aves.ninjas.cl/api/birds"

payload={}
headers = {'Content-Type': 'application/json'}

response = requests.request("GET", url, headers=headers, data=payload)
result=json.loads(response.text)
#print(result)

var=0
lista=[]
for i in result:
    if var<26:
        var+=1
        lista.append(i['name']['spanish'])
        lista.append(i['name']['english'])
        lista.append(i['images']['main'])

f = 25
c = 3
matriz = [lista[c*i : c*(i+1)] for i in range(f)]



def bird(matriz):
    
    i_template =Template('<h2>$esp\n$ing</h2>\n<img src="$url1">')

    h_template=Template('''<html>
    <head>
    <title>25 Pajaros</title>
    <style type="text/css" media="screen">
     *{
        margin:0;
        padding:0;
      }
      img{
        border: 1px solid #ddd;
        border-radius: 8px;
        padding: 10px;
        width: 220px;
     } 
    </style>
    </head>
    $body


    </body>
    </html>'
    ''')


    ### Se sustituyen los valores
    texto =''
    for i in matriz:
        print(i)
        #i_template = Template('<h2>$esp\n$in</h2>\n<img src="$url1">')
        texto+=i_template.substitute(esp=i[0], ing=i[1], url1=i[2]) + '\n'
        
    
    #print(texto)

    ### Se sustituye el body
    html=h_template.substitute(body=texto)
    print(html)

    ### Se guarda
    with open('pajaros.html','w') as f:
        f.write(html)
    return
    
bird(matriz)
       