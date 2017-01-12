require "json"
require 'net/http'
require 'uri'

def readfile file
  hash_gasolineras=nil
  fileObj = File.new(file, "r")
  content_gasolineras_servicios=""
  while (line = fileObj.gets)
    content_gasolineras_servicios<<line
  end
  fileObj.close
  if content_gasolineras_servicios.length>0
    hash_gasolineras=JSON.parse content_gasolineras_servicios
  end
  hash_gasolineras
end

z9=readfile "gasolineras_con_servicios_z9.json"
z7=readfile "gasolineras_con_servicios_z7.json"
z6=readfile "gasolineras_con_servicios_z6.json"
z11=readfile "gasolineras_con_servicios_z11.json"
z6_sin=readfile "gasolineras_sin_servicios_z6.json"
z11_sin=readfile "gasolineras_sin_servicios_z11.json"
primeras=readfile "gasolineras_primeras.json"
hans=readfile "gasolineras.json"
totales=z9+z7+z11+z6_sin+z11_sin
