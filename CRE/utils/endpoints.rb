module Endpoints
  PAGES=[
  ]
#TODO: change URL
  def filter_page_station product, service
    "http://pronosticodemanda.pemex.com/WS_GP_2/Pemex.Servicios.svc/web/get_Est_Reg?latne=36.72017291454478&lonne=-74.53125006250002&latsw=12.488872636970148&lonsw=-134.56054693750002&z=5&category=3&prod=#{product}&serv=#{service}"
  end
end
