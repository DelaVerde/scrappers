require "rubygems"
require "json"
require 'net/http'
require 'uri'
require "./utils/scrapper_detail_station"
class ScrapperGuiaPemex
  require "./utils/services_fuelstation"
  include ServicesFuelStation
  def open(url)
    Net::HTTP.get(URI.parse(url))
  end

  def initialize list_types_fuel: ServicesFuelStation::LIST_TYPE_FUEL, list_services: ServicesFuelStation::LIST_SERVICES
    @list_types_fuel=list_types_fuel
    @list_services=list_services
    @list_hash_station=Hash.new
    @list_info_station=Hash.new
    @list_station_id=[]
  end


  def convert_hash_to_json hash_param
    hash_param.to_json
  end

  def write_to_file name_file,content
    page_content=convert_hash_to_json content
    File.open(name_file, 'w') { |file| file.write(page_content) }
  end


  def get_stations_from_json content, service
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

  def run
    @list_types_fuel.each do |type_fuel|
      @list_services.each do |service|
        page_content=open(get_url(type_fuel, service))
        #File.open("./output/listagasolineras_#{ServicesFuelStation::LABELS[service]}_#{ServicesFuelStation::TYPE_FUEL[type_fuel]}.json", 'w') { |file| file.write(page_content) } #Permite guardar los jsons de cada servicio
        get_stations_from_json page_content, ServicesFuelStation::LABELS[service]
      end
    end
    convert_to_json_all_station_with_prices
  end
  def convert_to_json_all_station_with_prices
    list_of_objects=[]
    @list_station_id.each do |station_id|
      @list_info_station[station_id].add_services @list_hash_station[station_id]["services"]
      list_of_objects.push @list_info_station[station_id].to_hash
    end
    write_to_file "./output/gasolineras_con_servicios.json",list_of_objects
    puts "Total de estaciones #{list_of_objects.size}"
  end
end
