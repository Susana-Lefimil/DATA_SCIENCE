import requests, json
from string import Template
url = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key=....."

payload = {}
headers= {'Content-Type': 'application/json'}

response = requests.request("GET", url, headers=headers, data = payload)
result =json.loads(response.text)
#print(response.text.encode('utf8'))

### Filtrar 25 primeras imagenes
var=0
img=[]
for i in result['photos']:
    if var<25:
        #print(i['img_src'])
        var=var+1
        img.append(i['img_src'])
#print(img)

### Funcion que crea pagina web
def build_web_page(img):

    i_template = Template('<img src="$url">')
    
    h_template=Template('''<html>
    <head>
    <title>25 Fotos de la Nasa</title>
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

    ### Se sustituye la imagen en la url
    texto =''
    for url in img:
        texto+=i_template.substitute(url=url)+ '\n'
    #print(texto)

    ### Se sustituye el body
    html=h_template.substitute(body=texto)
    print(html)

    ### Se guarda
    with open('FotosNasa.html','w') as f:
        f.write(html)
    return
    
build_web_page(img)
