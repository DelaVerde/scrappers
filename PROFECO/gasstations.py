import requests
from bs4 import BeautifulSoup
import csv

output_file = "sample_data/reportegaseras.csv"

state_values = ['AGUASCALIENTES', 'BAJA CALIFORNIA', 'BAJA CALIFORNIA SUR', 'CAMPECHE', 'CHIAPAS', 'CHIHUAHUA', 'CIUDAD DE MEXICO', 'COAHUILA DE ZARAGOZA', 'COLIMA', 'DISTRITO FEDERAL', 'DURANGO', 'GUANAJUATO', 'GUERRERO', 'HIDALGO', 'JALISCO', 'MEXICO', 'MICHOACAN DE OCAMPO', 'MORELIA', 'MORELOS', 'NAYARIT', 'NUEVO LEON', 'OAXACA DE JUAREZ', 'PUEBLA', 'QUERETARO DE ARTEAGA', 'QUINTANA ROO', 'SAN LUIS POTOSI', 'SINALOA', 'SONORA', 'TABASCO', 'TAMAULIPAS', 'TLAXCALA', 'VERACRUZ', 'VERACRUZ DE IGNACIO DE LA LLAVE', 'YUCATAN', 'ZACATECAS']

def state_data(state):
    headers_data = {'Pragma':'no-cache',
                                    'Origin':'http://200.53.148.113',
                                    'Accept-Encoding':'gzip,deflate',
                                    'Accept-Language':'es-ES,es;q=0.8,en;q=0.6',
                                    'Upgrade-Insecure-Requests':'1',
                                    'User-Agent':'Mozilla/5.0(Macintosh;IntelMacOSX10_12_3)AppleWebKit/537.36(KHTML,likeGecko)Chrome/55.0.2883.95Safari/537.36',
                                    'Content-Type':'application/x-www-form-urlencoded',
                                    'Accept':'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
                                    'Cache-Control':'no-cache',
                                    'Referer':'http://200.53.148.113/qqg/?page_id=423',
                                    'Cookie':'gsScrollPos=;_ga=GA1.1.1696495404.1483817531;_gali=btnBuscaGas',
                                    'Connection':'keep-alive'}
    r = requests.post('http://200.53.148.113/qqg/?page_id=423',
                      data ='page_id=423&estado='+state+'&municipio=&razon=&btnBuscaGas=1',
                      headers = headers_data)
    soup = BeautifulSoup(r.content)
    table = soup.find("div", {"class":"table-responsive"})
    return table


def extract_header(table):
    header_row = []
    header_html = table.find("thead")
    for row in header_html.find("tr").findAll("th"):
        header_row.append(row.text)
    return header_row


def main():
    full_table = []
    count = 0
    for state in state_values:
        print(state)
        table = state_data(state)
        for row in table.findAll("tr"):
            row_data = []
            for value in row.findAll("td"):
                row_data.append(value.text)
            if len(row_data)> 0:
                if len(row_data)>13:
                    row_data[1] = str(row_data[1]) + " "+ str(row_data[2])
                    row_data.pop(2)  #Algunas rows tienen errores en el nombre. Eliminamos los nombres de más. Esperando poderlo limpiar.
                full_table = full_table+[row_data]
        if count == len(state_values)-1:
            header = [extract_header(table)]
            full_table = header + full_table
        count = count +1


    with open(output_file, "w") as f:
    writer = csv.writer(f)
    writer.writerows(full_table)

    return None

if __name__ == '__main__':
   main()
