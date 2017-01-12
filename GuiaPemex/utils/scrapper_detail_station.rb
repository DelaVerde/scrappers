require 'rubygems'
require 'nokogiri'
require 'rest-client'
class ScrapperDetailStation
  def initialize id
    @id=id
    @services_html=["li.ic_serv_areadescanso","li.ic_serv_banos","li.ic_serv_tienda","li.ic_serv_hielo_agua",
      "li.ic_serv_maquina","li.ic_serv_comida","li.ic_serv_telefono","li.ic_serv_tmecanico","li.ic_serv_autolavado","li.ic_serv_banco",
      "li.ic_serv_wifi","li.ic_serv_farmacia","li.ic_serv_hotel","li.ic_serv_regaderas","li.ic_serv_tintoreria","li.ic_serv_tintoreria"]
    @services_list=["Area_descanso","Baños","Tienda","Hielo","Maquina_expendedora","Comida","Telefono","Taller","Auto_lavado","Banco","Internet","Farmacia","Hotel","Regaderas","Lavanderia","Mensajeria"]
    @services=[]
    scrapping
  end

  def scrapping
    begin
      page = Nokogiri::HTML(RestClient.get("http://guiapemex.pemex.com/Paginas/DetalleGas.aspx?val=#{@id}&GetFrag=1"))
      @name=page.css("div.body-content div.data.hide")[0]["data-place_name"]
      @magna=page.css('div#magna p.price')[0].text
      @premium=page.css('div#premium p.price')[0].text
      @diesel=page.css('div#diesel p.price')[0].text
      @address=page.css("div#info p.address")[0].text
      @lat=page.css("div.body-content div.data.hide")[0]["data-place_latitude"]
      @lng=page.css("div.body-content div.data.hide")[0]["data-place_longitude"]
      parse_services page
    rescue Exception => e
      puts "Hubo un error en esta: #{e.message}"
      puts "http://guiapemex.pemex.com/Paginas/DetalleGas.aspx?val=#{@id}&GetFrag=1"
    end
  end

  def add_services services
    @services=services
  end

  def parse_services page
      @services_html.each_with_index do |service,index|
        if !page.css(service)[0].nil?
          @services.push(@services_list[index])
        end
      end
  end

  def to_hash
    {
      id: @id,
      place_name: @name,
      place_address:@address,
      place_latitude:@lat,
      place_longitude:@lng,
      services:@services,
      prices:{
        magna: @magna,
        premium:@premium,
        diesel:@diesel,
      }
    }
  end

end
