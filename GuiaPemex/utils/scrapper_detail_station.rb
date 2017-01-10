require 'rubygems'
require 'nokogiri'
require 'rest-client'
class ScrapperDetailStation
  #[{"premium": "$17.93", "name": "E01099 \u00b7 Servicios Villalobos, S.A.", "diesel": "$17.23", "long": -102.28978, "magna": "$16.16", "lat": 21.834805, "adress": "Km 526 Carretera Panamericana, Col. ., C.P. 20000, Aguascalientes, Aguascalientes", "id": "E01099"},

  def initialize id
    @id=id
    scrapping
  end

  def scrapping
    page = Nokogiri::HTML(RestClient.get("http://guiapemex.pemex.com/Paginas/DetalleGas.aspx?val=#{@id}&GetFrag=1"))
    #@id=id
    @name=page.css("div.body-content div.data.hide")[0]["data-place_name"]
    @magna=page.css('div#magna p.price')[0].text   # => Nokogiri::HTML::Document
    @premium=page.css('div#premium p.price')[0].text
    @diesel=page.css('div#diesel p.price')[0].text
    @address=page.css("div#info p.address")[0].text
    @lat=page.css("div.body-content div.data.hide")[0]["data-place_latitude"]
    @lng=page.css("div.body-content div.data.hide")[0]["data-place_longitude"]
  end

  def add_services services
    @services=services
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

# page.css('div#magna')[0]
#ob=CrawlerWeb.new "http://guiapemex.pemex.com/Paginas/DetalleGas.aspx?val=E03159&GetFrag=1"
#ob=CrawlerWeb.new "http://guiapemex.pemex.com/Paginas/DetalleGas.aspx?val=E03159&GetFrag=1","E03159"
#puts ob.inspect
