module ServicesFuelStation
  require "./utils/endpoints"
  include Endpoints
  SERVICES={
    des:"des",tie:"tie",hie:"hie",maq:"maq",com:"com",tel:"tel",tal:"tal",
    aut:"aut",ban:"ban",int:"int",far:"far",hot:"hot",reg:"reg",lav:"lav",men:"men"
  }

  LABELS={
    des:"area_descanso",tie:"tienda",hie:"hielo",maq:"maquina_expendedora",com:"comida",tel:"telefono",tal:"taller",aut:"auto_lavado",
    ban:"banco",int:"internet",far:"farmacia",hot:"hotel",reg:"regaderas",lav:"lavanderia",men:"mensajeria"
  }

  LIST_SERVICES=[
    :des,:tie,:hie,:maq,:com,:tel,:tal,
    :aut,:ban,:int,:far,:hot,:reg,:lav,:men
  ]
  LIST_TYPE_FUEL=[:d,:m,:p]

  TYPE_FUEL={d:"d",m:"m",p:"p"}

  def get_url type_fuel, service, state_name
    filter_page_station TYPE_FUEL[type_fuel], SERVICES[service], state_name.to_sym    
  end
end
