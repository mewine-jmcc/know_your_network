## Read in shape file


#read in 
library(sf)
library(tidyverse)
library(leaflet)


## read in data
srn <- st_read("./Data/network.shp")


#filter by cities
manchester_srn<- srn %>% filter(AUTHO_NAME == "Manchester")
birmingham_srn<- srn %>% filter(AUTHO_NAME == "Birmingham")
birmingham_srn_wider<- srn %>% filter(AUTHO_NAME %in% c("Birmingham","Coventy", "Dudley",
                                             "Sandwell", "Solihull", "Staffordshire",
                                             "Walsall", "Warwickshire"))



plot(manchester_srn)
plot(birmingham_srn)

#transform data
birmingham_srn<- st_transform(birmingham_srn, crs = "+init=epsg:4326")


#transfomr srn
srn<- st_transform(srn, crs = "+init=epsg:4326")

#tranform Birmingham srn_wider
birmingham_srn_wider<- st_transform(birmingham_srn_wider, crs = "+init=epsg:4326")


#add series of dates


birmingham_srn <- birmingham_srn %>% mutate(Jan_01 = 
                            sample(x = c("Y", "N"), size = nrow(birmingham_srn), 
                                          replace = TRUE, prob = c(0.05, 0.95)),
                          Jan_02 =
                            sample(x = c("Y", "N"), size = nrow(birmingham_srn), 
                                   replace = TRUE, prob = c(0.05, 0.95)),
                          Jan_03 =
                            sample(x = c("Y", "N"), size = nrow(birmingham_srn), 
                                   replace = TRUE, prob = c(0.05, 0.95)),
                          Jan_04 =
                            sample(x = c("Y", "N"), size = nrow(birmingham_srn), 
                                   replace = TRUE, prob = c(0.05, 0.95)))

#write out as sspacial objects
write_sf(birmingham_srn, "./Outputs/birmingham_srn.shp")
write_sf(birmingham_srn_wider, "./Outputs/birmingham_srn_wider.shp")


##build leaflet map ----

srn_pop <- paste0("Road Number: ",
                  birmingham_srn$ROA_NUMBER,
                  "<br>",
                  "Location: ",
                  birmingham_srn$LOCATION)

birmingham_srn_col<- colorFactor(c("red", "green"), as.factor(birmingham_srn$Jan_01))

#leflet map for polygons with fill
leaflet(birmingham_srn) %>%
  addProviderTiles(providers$CartoDB.Positron)%>%
  addPolygons(stroke = TRUE, fillOpacity = 0.6, weight = 0.6, color = "black",
              fillColor = ~birmingham_srn_col(birmingham_srn$Jan_01),
              popup = ~srn_pop) 

#leaflet map just using outline
leaflet(birmingham_srn) %>%
  addProviderTiles(providers$CartoDB.Positron)%>%
  addPolygons(stroke = TRUE, fillOpacity = 0, weight = 1,
              color = ~birmingham_srn_col(birmingham_srn$Jan_01),
              popup = ~srn_pop) 

leaflet(srn) %>%
  addProviderTiles(providers$CartoDB.Positron)%>%
  addPolygons(stroke = TRUE, fillOpacity = 0, weight = 1,
              color = "blue") 


#

#write.csv(game_team, "./Data/game_team.csv")
#write.csv(games, "./Data/games.csv")
