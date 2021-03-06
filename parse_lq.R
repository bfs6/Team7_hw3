#install.packages("xml2")
library(rvest)
library(stringr)

location_name<-address<-state<-city<-phone_number<-fax_number<-latitude<-longitude<-
  floors<-rooms<-suites<-check_in_time<-check_out_time<-
  indoor_swimming_pool <- fitness_center<-outdoor_swimming_pool <- bright_side_market <- business_center <- express_check_out <-
  meeting_facilities <- spa <- gr_microwaves_all <- gr_fridge_all <- gr_samsung_flat_panel <- gr_plug_and_play <-
  gr_whirlpool_select_rooms<- nearby_sports_and_recreation <- nearby_restaurants <- entertainment_and_shopping <-
  area_attractions_and_landmarks <- area_companies_and_businesses <- rep(NA,length(dir("data/lq")))

for (i in 1:length(dir("data/lq"))){
  p<-read_html(paste0("data/lq/",dir("data/lq")[i]))
  
  #location name
  x1<-p %>%
    html_nodes("h1") %>%
    html_text(trim=TRUE)
  
  #address, phone, fax
  x2 <- p %>%
    html_nodes(".hotelDetailsBasicInfoTitle p") %>%
    html_text(trim=TRUE) %>%
    strsplit("\\n") %>%
    lapply(function(x) gsub("^\\s+|\\s+$", "", x)) %>%
    unlist()
  x2 <- unique(x2[x2!=""])
  
  #latitude, longitude
  x3 <- p %>%
    html_nodes(".minimap") %>%
    toString() %>%
    strsplit(split="") %>%
    unlist()
  a<-x3[which(x3=="|")+1:length(x3)]
  b<-a[1:which(a=="&")-1]
  c<-paste0(b,collapse = "") %>% strsplit(split=",") %>%unlist()
  
  #amenities and details
  x4 <- p %>%
    html_nodes(".section:nth-child(1) .pptab_contentL") %>%
    html_text(trim=TRUE) %>%
    strsplit("\\n\t") %>%
    lapply(function(x) gsub("^\\t+ | \\s+$","",x))
  amen <- unlist(x4[[1]])
  amen <- unique(amen[amen!="" & amen != "\t\t"]) %>% paste0(collapse="")
  guest_room_amen <-unlist(x4[[2]])
  guest_room_amen <-unique(guest_room_amen[guest_room_amen != "" & guest_room_amen != "\t\t"]) %>% paste0(collapse="")
  
  #hotel details
  x5 <- p %>%
    html_nodes(".hotelFeatureList ul") %>%
    html_text(trim=TRUE) %>%
    strsplit("\r\n") %>%
    lapply(function(x) gsub("^\\s+ | \\s+$","",x)) %>%
    lapply(function(x) gsub("\r","",x))%>%
    unlist()
  x5 <- unique(x5[x5!=""]) %>%
    strsplit(split=": ") 
  d1<-sapply(x5,function(x) x[[1]])
  d2<-sapply(x5,function(x) x[[2]])
  names(d2) = d1
  
  location_name[i] <- x1
  address[i] <- paste(x2[1:2], collapse=" ")
  temp1<-unlist(strsplit(address[i],", "))
  city[i] <- temp1[length(temp1)-1]
  temp2<-unlist(strsplit(temp1[length(temp1)]," "))
  state[i] <- temp2[1]
  phone_number[i] <- strsplit(x2[3],": ")[[1]][2]
  fax_number[i] <- strsplit(x2[4],": ")[[1]][2]
  latitude[i]<-as.numeric(c[1])
  longitude[i]<-as.numeric(c[2])
  
  if ("Floors" %in% names(d2)){
    floors[i] = d2["Floors"]
  }else{
    floors[i]=NA
  }
  
  if ("Rooms" %in% names(d2)){
    rooms[i] = d2["Rooms"]
  }else{
    rooms[i] = NA
  }
  
  if ("Suites" %in% names(d2)){
    suites[i] = d2["Suites"]
  }else{
    suites[i] = NA
  }
  
  if ("Check-In Time" %in% names(d2)){
    check_in_time[i] = d2["Check-In Time"]
  }else{
    check_in_time[i] = NA
  }
  
  if("Check-Out Time" %in% names(d2)){
    check_out_time[i] = d2["Check-Out Time"]
  }else{
    check_out_time[i] = NA
  }
  
  indoor_swimming_pool[i] <- as.numeric(grepl("Indoor Swimming Pool",amen))
  fitness_center[i] <- as.numeric(grepl("Fitness Center", amen))
  outdoor_swimming_pool[i] <- as.numeric(grepl("Outdoor Swimming Pool" , amen))
  bright_side_market[i] <- as.numeric(grepl("Bright Side Market",amen))
  business_center[i] <- as.numeric(grepl("Business Center", amen))
  express_check_out[i] <- as.numeric(grepl("Express Checkout ",amen))
  meeting_facilities[i] <- as.numeric(grepl("Meeting Facilities",amen))
  spa[i] <- as.numeric(grepl("Spa",amen))
  
  gr_microwaves_all[i] <- as.numeric(grepl("Microwave in all rooms",guest_room_amen))
  gr_fridge_all[i] <-as.numeric(grepl("Refrigerator in all rooms",guest_room_amen))
  gr_samsung_flat_panel[i] <- as.numeric(grepl("Samsung",guest_room_amen))
  gr_plug_and_play[i] <- as.numeric(grepl("Plug-and-Play",guest_room_amen))
  gr_whirlpool_select_rooms[i] <- as.numeric(grepl("Whirlpool",guest_room_amen))
}


#t<-lapply(test,function(x) length(unlist(strsplit(x[3],split=" "))))

c=logical(length = 0)
for(i in seq_along(address)){
  a <- str_detect(state[i], state.abb)
  if(!TRUE %in% a){
    c=c(c, FALSE)
  }
  else{c=c(c, TRUE)
  
  }
}
lq = data.frame(location_name, address, city, state, phone_number, fax_number, latitude,longitude,
                floors, rooms, suites,check_in_time,check_out_time,
                indoor_swimming_pool , fitness_center,outdoor_swimming_pool , bright_side_market , business_center , express_check_out ,meeting_facilities , spa , 
                gr_microwaves_all , gr_fridge_all , gr_samsung_flat_panel , gr_plug_and_play ,gr_whirlpool_select_rooms, c,
                stringsAsFactors = FALSE)


lq=lq[which(lq$c==TRUE),]

lq$c=NULL

save(lq, file="data/lq.Rdata")