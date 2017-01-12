require "rubygems"
require "json"
require 'net/http'
require 'uri'
require "./utils/scrapper_detail_station"
class ScrapperGuiaPemex
  require "./utils/services_fuelstation"
  include ServicesFuelStation
  def open(url)
    value_return=nil
    begin
      value_return=Net::HTTP.get(URI.parse(url))
    rescue Exception
      puts "La url que arrojo un error #{url}"
    end
    value_return
  end

  def initialize list_types_fuel: ServicesFuelStation::LIST_TYPE_FUEL, list_services: ServicesFuelStation::LIST_SERVICES, list_states:ServicesFuelStation::STATES
    @list_types_fuel=list_types_fuel
    @list_states=list_states
    @list_stations=[]
    @list_id=[]
    @threshold=15000
  end


  def convert_hash_to_json hash_param
    hash_param.to_json
  end

  def write_to_file name_file,content
    page_content=convert_hash_to_json content
    File.open(name_file, 'w') { |file| file.write(page_content) }
  end


  def get_stations_from_json content
    list_fuel_station=JSON.parse content
    list_fuel_station.each do |station|
      next if @list_id.include?(station["id"])
      station_ob=ScrapperDetailStation.new(station["id"])
      @list_stations.push  station_ob.to_hash
      @list_id.push station["id"]
    end
  end


  def run
    @list_states.each do |state_name|
      break if @list_stations.size>@threshold
      @list_types_fuel.each do |type_fuel|
          page_content=open(get_url(type_fuel, "",state_name))
          if page_content!=nil
            get_stations_from_json page_content
          end
      end
    end
    convert_to_json_all_station_with_services
  end
  def convert_to_json_all_station_with_services
    write_to_file "./output/stations_with_services.json",@list_stations
    puts "Total stations #{@list_stations.size}"
  end

end
