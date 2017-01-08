## Scrapping GuiaPemex

Este es el script que permite obtener las gasolineras desde GuiaPemex.
El script genera un archivo json el cual contiene, un listado de las gasolineras encontradas, con su respectivo conjunto de servicios dentro de cada gasolinera.
Se hizo con Ruby.

## Requerimientos

Para el uso del script se usaron las siguientes gemas:
**Nokogiri**
**Rest-client**
**Json**


## Instalación

Usando rubygems, la instalación de cada una de las dependencias respectivamente, es la siguiente:
gem install nokogiri
gem install rest-client
gem install json

## Uso

El script arranca desde el archivo principal **main.rb**, este contiene una linea de código, la cual es la siguiente:
script=ScrapperGuiaPemex.new
script.run

ScrappgerGuiaPemex recibe 2 parámetros (* indica Opcional):
  list_type_fuel: Un arreglo de símbolos, los tipos de gasolina interesados a obtener *
  list_services: Un arreglo de símbolos, los servicios de interés a filtrar *

Ejemplo de parámetros:

script=ScrapperGuiaPemex.new list_type_fuel:[:d], list_services:[:des]
script.run

**¿Porque opcionales?**
Si no se le indican ya sea, el listado de tipos de gasolina, o el listado de servicios, cualquiera de los dos parámetros que sea nulo,
se usara el listado respectivo de GuiaPemex (ambas estructuras están en el modulo dentro de la carpeta utils, ServicesFuelStation)

LIST_SERVICES=[
    :des,:tie,:hie,:maq,:com,:tel,:tal,
    :aut,:ban,:int,:far,:hot,:reg,:lav,:men
  ]
LIST_TYPE_FUEL=[:d,:m,:p]

## Posibles correcciones
## Posibles correcciones

Observe que GuiaPemex carga las gasolineras del mapa, conforme al valor de Z, mientras mas cercas, puede que que carguen mas gasolineras.

Las rutas a partir de donde se extrae la información es igual a esta:
http://pronosticodemanda.pemex.com/WS_GP_2/Pemex.Servicios.svc/web/get_Est_Reg?latne=36.72017291454478&lonne=-74.53125006250002&latsw=12.488872636970148&lonsw=-134.56054693750002&z=5&category=3&prod=d&serv=des

Parámetros relevantes:
	latne = Latitud Noroeste
	lonne = Longitud Noroeste
	latsw =Latitud suroeste
	lonsw= Longitud suroeste

Una posible solución, es encontrar estos 4 valores, por cada estado, y estar iterando sobre cada cuadrante (los estados con sus coordenadas militantes)
