import requests
from bs4 import BeautifulSoup
import pandas as pd


def state_data(state):
    headers_data = {'Accept-Encoding': 'gzip, deflate' ,
                                 'Accept-Language': 'es-ES,es;q=0.8,en;q=0.6' ,
                                 'Upgrade-Insecure-Requests': '1' ,
                                 'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 Safari/537.36' ,
                                 'Content-Type': 'application/x-www-form-urlencoded' ,
                                 'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' ,
                                 'Cache-Control': 'no-cache' ,
                                 'Referer': 'http://200.53.148.113/qqg/?page_id=13' ,
                                 'Cookie': 'gsScrollPos=; _ga=GA1.1.1696495404.1483817531; _gali=btnBuscar' ,
                                 'Connection': 'keep-alive'}
    r = requests.post('http://200.53.148.113/qqg/?page_id=13',
                      data ='page_id=13&estado='+state+'&razon=&numero=&btnBuscar=1',
                      headers = headers_data)
    soup = BeautifulSoup(r.content)
    table = soup.find("div", {"class":"table-responsive"})
    hidden_divs = soup.findAll("div",{"style":"border:solid; display:none; position:fixed; top:25%; left:35%; height:70%; width:55%; background-color:#DDDDDD;"})
    return table, hidden_divs


def extract_header(table):
    header_row = []
    header_html = table.find("thead")
    for row in header_html.find("tr").findAll("th"):
        header_row.append(row.text)
    return header_row

def state_value_get():
    headers_data = {'Accept-Encoding': 'gzip, deflate' ,
                                 'Accept-Language': 'es-ES,es;q=0.8,en;q=0.6' ,
                                 'Upgrade-Insecure-Requests': '1' ,
                                 'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 Safari/537.36' ,
                                 'Content-Type': 'application/x-www-form-urlencoded' ,
                                 'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' ,
                                 'Cache-Control': 'no-cache' ,
                                 'Referer': 'http://200.53.148.113/qqg/?page_id=13' ,
                                 'Cookie': 'gsScrollPos=; _ga=GA1.1.1696495404.1483817531; _gali=btnBuscar' ,
                                 'Connection': 'keep-alive'}
    r = requests.post('http://200.53.148.113/qqg/?page_id=13',
                      data ='page_id=13&estado=Aguascalientes&razon=&numero=&btnBuscar=1',
                      headers = headers_data)
    soup = BeautifulSoup(r.content)
    state_values = []
    select = soup.find("select",{"class":"qqp"})
    for option in select.findAll("option"):
        state_values.append(option["value"])
    return state_values

def scrape_hidden_div(hidden_div):
    row_html = hidden_div.findAll("tr")
    local_data = []
    for row in row_html[1:5]:
        local_data.append(row.findAll("td")[1].text)
    local_data.append(hidden_div.findAll("div")[1].text.replace("Instrumentos verificados: ",""))
    local_data.append(hidden_div.findAll("div")[3].text.replace("Instrumentos inmovilizados: ",""))
    subtable = []
    if len(row_html)>7:

        for subtable_row in row_html[7:]:
            local_row = []
            for value in subtable_row.findAll("td"):
                local_row.append(value.text)
            subtable= subtable + local_row
    return local_data, subtable

def main():
    full_table = []
    hidden_values = []
    verification_table = []
    state_values = state_value_get().pop(0)
    for state in state_values:

        #Extract table values
        print(state)
        table, hidden_divs = state_data(state)
        for row in table.findAll("tr"):
            row_data = []
            for value in row.findAll("td"):
                row_data.append(value.text.replace("'",'').replace('"',"").replace(",",""))
            if len(row_data)> 0:
                if "Estado" not in row_data or "Detalle" not in row_data:
                full_table = full_table+[row_data]

        for hidden_div in hidden_divs:
            extra_info, verification_data = scrape_hidden_div(hidden_div)
            hidden_values = hidden_values + [extra_info]
            if len(verification_data) > 0:
                verification_table = verification_table + [verification_data]


    full_table = [["Estado","Municipio","Razón social","Número de estación","Fecha de verificación","Mangueras verificadas","Verificadas volumetricamente","Mangueras inmovilizadas","Detalle"]] + full_table
    hidden_values = [["Razón Social","Dirección","Número de Estación", "Fecha de Verificación","Instrumentos Verificados","Instrumentos Movilizados"]]+ hidden_values
    verification_table = [["ID","CAUSA","DEFINICIÓN","INMOV"]]+ verification_table

    table_df = pd.DataFrame(full_table)
    hidden_df = pd.DataFrame(hidden_values)
    verification_df =pd.DataFrame(verification_table)

    table_df.to_csv("sample_data/gasolina/reporte.csv")
    hidden_df.to_csv("sample_data/gasolina/extra_info.csv")
    verification_df.to_csv("sample_data/gasolina/verificacion.csv")

    return None


if __name__ == '__main__':
   main()
