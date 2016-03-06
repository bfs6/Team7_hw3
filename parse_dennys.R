library(rvest)
library(magrittr)

xml_list=list.files("data/dennys")


dennys = data.frame()

makedf=function(location){
  data <- read_html(paste0("data/dennys/", location))
  address=data %>% html_nodes("address1")%>%html_text(trim=TRUE)
  city=data %>% html_nodes("city")%>%html_text(trim=TRUE)
  state=data %>% html_nodes("state")%>%html_text(trim=TRUE)
  country=data %>% html_nodes("country")%>%html_text(trim=TRUE)
  latitude=data %>% html_nodes("latitude")%>%html_text(trim=TRUE)
  latitude=as.numeric(latitude)
  longitude=data %>% html_nodes("longitude")%>%html_text(trim=TRUE)
  longitude=as.numeric(longitude)
  uid=data %>% html_nodes("uid")%>%html_text(trim=TRUE)
  postalcode=data %>% html_nodes("postalcode")%>%html_text(trim=TRUE)
  df=data.frame()
  df=data.frame(address, city, state,postalcode, country, latitude, longitude, uid, stringsAsFactors = FALSE)
  return(df)
}


for(i in xml_list){
  a=makedf(i)
  dennys=rbind(dennys, a)
}

#remove things that aren't american
dennys=dennys[which(dennys$country=='US'),]

#remove things that are not unique

dennys=dennys[!duplicated(dennys$uid),]



save(dennys, file="data/dennys.Rdata")

