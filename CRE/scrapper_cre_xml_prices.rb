require "rubygems"
require "json"
require 'net/http'
require 'uri'
require 'nokigiri'

#forXML and JSON parsing
require 'crack'


class ScrapperCRE
  # TODO: see if this require is actually needed
  require "./utils/services_fuelstation"
  include ServicesFuelStation
  def open(url)
    Nokogiri::XML(open(URI.parse(url)))
  end

  def initialize list_types_fuel: ServicesFuelStation::LIST_TYPE_FUEL, list_services: ServicesFuelStation::LIST_SERVICES
    @list_types_fuel=list_types_fuel
    @list_services=list_services
    @list_hash_station=Hash.new
    @list_info_station=Hash.new
    @list_station_id=[]
  end

  #TODO: hast_to_xml?
  def convert_hash_to_json hash_param
    hash_param.to_json
  end

  def write_to_file name_file,content
    page_content=convert_hash_to_json content
    File.open(name_file, 'w') { |file| file.write(page_content) }
  end


  def get_prices_from_xml content, service
    list_fuel_station=JSON.parse content
    list_fuel_station.each do |station|
      if !@list_hash_station.key?(station["id"])
        @list_hash_station[station["id"]]=Hash.new
        @list_hash_station[station["id"]]["services"]=Array.new
        @list_hash_station[station["id"]]["services"].push service
        ob=ScrapperDetailStation.new station["id"]
        @list_info_station[station["id"]]=ob
        @list_station_id.push station["id"]
      else
        @list_hash_station[station["id"]]["services"].push service
      end
    end
  end

  def get_last_stations_json
    fileObj = File.new("./output/gasolineras_servicios.json", "r")
    content_gasolineras_servicios=""
    while (line = fileObj.gets)
      content_gasolineras_servicios<<line
    end
    fileObj.close
    if content_gasolineras_servicios.length>0
      @hash_gasolineras=JSON.parse content_gasolineras_servicios
    end
  end

  #TODO: def get_xml_file

  def run
    @list_types_fuel.each do |type_fuel|
      @list_services.each do |service|
        page_content=open("http://www.feedurl.com")
        #File.open("./output/listagasolineras_#{ServicesFuelStation::LABELS[service]}_#{ServicesFuelStation::TYPE_FUEL[type_fuel]}.json", 'w') { |file| file.write(page_content) } #Permite guardar los jsons de cada servicio
        get_prices_from_xml page_content, ServicesFuelStation::LABELS[service]
      end
    end
  end

end
