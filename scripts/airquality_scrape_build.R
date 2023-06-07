library(leaflet)
library(leaflet.providers)
library(sf)
library(htmlwidgets)

# Latest Air Quality geofile from AirNow via federal government
try(download.file("https://services.arcgis.com/cJ9YHowT8TU7DUyn/arcgis/rest/services/AirNowLatestContoursCombined/FeatureServer/0/query?where=0%3D0&objectIds=&time=&geometry=&geometryType=esriGeometryEnvelope&inSR=&spatialRel=esriSpatialRelIntersects&resultType=none&distance=0.0&units=esriSRUnit_Meter&returnGeodetic=false&outFields=*&returnGeometry=true&returnCentroid=false&featureEncoding=esriDefault&multipatchOption=xyFootprint&maxAllowableOffset=&geometryPrecision=&outSR=&datumTransformation=&applyVCSProjection=false&returnIdsOnly=false&returnUniqueIdsOnly=false&returnCountOnly=false&returnExtentOnly=false&returnQueryGeometry=false&returnDistinctValues=false&cacheHint=false&orderByFields=&groupByFieldsForStatistics=&outStatistics=&having=&resultOffset=&resultRecordCount=&returnZ=false&returnM=false&returnExceededLimitFeatures=true&quantizationParameters=&sqlFormat=none&f=pgeojson",
              "data/airnow_aq.geojson"))

air_quality <- st_read("data/airnow_aq.geojson")

# Create color palette for air quality
airpal <- colorFactor(palette = c("#b1dbad", 
                                  "#ffffb8", 
                                  "#ffcc80",
                                  "#ff8280",
                                  "#957aa3",
                                  "#a18f7f"),
                      levels = c("1", "2", "3", "4","5","6"), 
                      na.color = "#ff8280")

# Temporary replacement for existing Cali-only
# air quality maps for all three CA stations

# SAN FRANCISCO
airquality_map_SF <- leaflet() %>%
  setView(-122.4194, 37.77, zoom = 9) %>% 
  addProviderTiles(provider = "Stamen.Toner") %>%
  addPolygons(data = air_quality, 
              color = ~airpal(gridcode),
              weight = 0,
              fillOpacity = 0.6) %>%
  addLegend(values = values(air_quality$gridcode), title = "<small>Air Quality Index<br><a href='https://www.airnow.gov/aqi/aqi-basics/' target='blank'>What AQI ratings mean</a>", 
            group = "Air Quality", 
            colors = c("#b1dbad", "#ffffb8", "#ffcc80","#ff8280","#957aa3","#a18f7f","#dde4f0"),
            labels=c("<small>Good", "Moderate", "Unhealthy for<br>Sensitive Groups", "Unhealthy", "Very Unhealthy", "Hazardous","No AQ Data"),
            position = 'topright')

# FRESNO
airquality_map_Fresno <- leaflet() %>%
  setView(-119.7871, 36.73, zoom = 9) %>% 
  addProviderTiles(provider = "Stamen.Toner") %>%
  addPolygons(data = air_quality, 
              color = ~airpal(gridcode),
              weight = 0,
              fillOpacity = 0.6) %>%
  addLegend(values = values(air_quality$gridcode), title = "<small>Air Quality Index<br><a href='https://www.airnow.gov/aqi/aqi-basics/' target='blank'>What AQI ratings mean</a>", 
            group = "Air Quality", 
            colors = c("#b1dbad", "#ffffb8", "#ffcc80","#ff8280","#957aa3","#a18f7f","#dde4f0"),
            labels=c("<small>Good", "Moderate", "Unhealthy for<br>Sensitive Groups", "Unhealthy", "Very Unhealthy", "Hazardous","No AQ Data"),
            position = 'topright')

# LOS ANGELES
airquality_map_LA <- leaflet() %>%
  setView(-118.161229, 33.957379, zoom = 8) %>% 
  addProviderTiles(provider = "Stamen.Toner") %>%
  addPolygons(data = air_quality, 
              color = ~airpal(gridcode),
              weight = 0,
              fillOpacity = 0.6) %>%
  addLegend(values = values(air_quality$gridcode), title = "<small>Air Quality Index<br><a href='https://www.airnow.gov/aqi/aqi-basics/' target='blank'>What AQI ratings mean</a>", 
            group = "Air Quality", 
            colors = c("#b1dbad", "#ffffb8", "#ffcc80","#ff8280","#957aa3","#a18f7f","#dde4f0"),
            labels=c("<small>Good", "Moderate", "Unhealthy for<br>Sensitive Groups", "Unhealthy", "Very Unhealthy", "Hazardous","No AQ Data"),
            position = 'topright')

# NEW YORK
airquality_map_NYC <- leaflet() %>%
  setView(-73.9, 40.712, zoom = 10) %>% 
  addProviderTiles(provider = "Stamen.Toner") %>%
  addPolygons(data = air_quality, 
              color = ~airpal(gridcode),
              weight = 0,
              fillOpacity = 0.6) %>%
  addLegend(values = values(air_quality$gridcode), title = "<small>Air Quality Index<br><a href='https://www.airnow.gov/aqi/aqi-basics/' target='blank'>What AQI ratings mean</a>", 
            group = "Air Quality", 
            colors = c("#b1dbad", "#ffffb8", "#ffcc80","#ff8280","#957aa3","#a18f7f","#dde4f0"),
            labels=c("<small>Good", "Moderate", "Unhealthy for<br>Sensitive Groups", "Unhealthy", "Very Unhealthy", "Hazardous","No AQ Data"),
            position = 'topright')

# CHICAGO
airquality_map_Chicago <- leaflet() %>%
  setView(-87.6298, 41.8781, zoom = 10) %>% 
  addProviderTiles(provider = "Stamen.Toner") %>%
  addPolygons(data = air_quality, 
              color = ~airpal(gridcode),
              weight = 0,
              fillOpacity = 0.6) %>%
  addLegend(values = values(air_quality$gridcode), title = "<small>Air Quality Index<br><a href='https://www.airnow.gov/aqi/aqi-basics/' target='blank'>What AQI ratings mean</a>", 
            group = "Air Quality", 
            colors = c("#b1dbad", "#ffffb8", "#ffcc80","#ff8280","#957aa3","#a18f7f","#dde4f0"),
            labels=c("<small>Good", "Moderate", "Unhealthy for<br>Sensitive Groups", "Unhealthy", "Very Unhealthy", "Hazardous","No AQ Data"),
            position = 'topright')

# PHILLY
airquality_map_Philadelphia <- leaflet() %>%
  setView(-75.162, 39.9526, zoom = 10) %>% 
  addProviderTiles(provider = "Stamen.Toner") %>%
  addPolygons(data = air_quality, 
              color = ~airpal(gridcode),
              weight = 0,
              fillOpacity = 0.6) %>%
  addLegend(values = values(air_quality$gridcode), title = "<small>Air Quality Index<br><a href='https://www.airnow.gov/aqi/aqi-basics/' target='blank'>What AQI ratings mean</a>", 
            group = "Air Quality", 
            colors = c("#b1dbad", "#ffffb8", "#ffcc80","#ff8280","#957aa3","#a18f7f","#dde4f0"),
            labels=c("<small>Good", "Moderate", "Unhealthy for<br>Sensitive Groups", "Unhealthy", "Very Unhealthy", "Hazardous","No AQ Data"),
            position = 'topright')

# HOUSTON
airquality_map_Houston <- leaflet() %>%
  setView(-95.5, 29.75, zoom = 9) %>% 
  addProviderTiles(provider = "Stamen.Toner") %>%
  addPolygons(data = air_quality, 
              color = ~airpal(gridcode),
              weight = 0,
              fillOpacity = 0.6) %>%
  addLegend(values = values(air_quality$gridcode), title = "<small>Air Quality Index<br><a href='https://www.airnow.gov/aqi/aqi-basics/' target='blank'>What AQI ratings mean</a>", 
            group = "Air Quality", 
            colors = c("#b1dbad", "#ffffb8", "#ffcc80","#ff8280","#957aa3","#a18f7f","#dde4f0"),
            labels=c("<small>Good", "Moderate", "Unhealthy for<br>Sensitive Groups", "Unhealthy", "Very Unhealthy", "Hazardous","No AQ Data"),
            position = 'topright')

# RALEIGH
airquality_map_Raleigh <- leaflet() %>%
  setView(-78.64, 35.77, zoom = 9) %>% 
  addProviderTiles(provider = "Stamen.Toner") %>%
  addPolygons(data = air_quality, 
              color = ~airpal(gridcode),
              weight = 0,
              fillOpacity = 0.6) %>%
  addLegend(values = values(air_quality$gridcode), title = "<small>Air Quality Index<br><a href='https://www.airnow.gov/aqi/aqi-basics/' target='blank'>What AQI ratings mean</a>", 
            group = "Air Quality", 
            colors = c("#b1dbad", "#ffffb8", "#ffcc80","#ff8280","#957aa3","#a18f7f","#dde4f0"),
            labels=c("<small>Good", "Moderate", "Unhealthy for<br>Sensitive Groups", "Unhealthy", "Very Unhealthy", "Hazardous","No AQ Data"),
            position = 'topright')

# NATIONAL - ZOOMED TO HIGHEST RISK LEVEL AREAS
airquality_map_National <- leaflet() %>%
  setView(-75.162, 39.9526, zoom = 6) %>% 
  addProviderTiles(provider = "Stamen.Toner") %>%
  addPolygons(data = air_quality, 
              color = ~airpal(gridcode),
              weight = 0,
              fillOpacity = 0.6) %>%
  addLegend(values = values(air_quality$gridcode), title = "<small><small>Air Quality Index<br><a href='https://www.airnow.gov/aqi/aqi-basics/' target='blank'>What AQI ratings mean</a>", 
            group = "Air Quality", 
            colors = c("#b1dbad", "#ffffb8", "#ffcc80","#ff8280","#957aa3","#a18f7f","#dde4f0"),
            labels=c("<small>Good", "Moderate", "Unhealthy for<br>Sensitive Groups", "Unhealthy", "Very Unhealthy", "Hazardous","No AQ Data"),
            position = 'topright')

# NATIONWIDE
airquality_map_Nationwide <- leaflet() %>%
  setView(-98.35, 39.5, zoom = 5) %>% 
  addProviderTiles(provider = "Stamen.Toner") %>%
  addPolygons(data = air_quality, 
              color = ~airpal(gridcode),
              weight = 0,
              fillOpacity = 0.6) %>%
  addLegend(values = values(air_quality$gridcode), title = "<small><small>Air Quality Index<br><a href='https://www.airnow.gov/aqi/aqi-basics/' target='blank'>What AQI ratings mean</a>", 
            group = "Air Quality", 
            colors = c("#b1dbad", "#ffffb8", "#ffcc80","#ff8280","#957aa3","#a18f7f","#dde4f0"),
            labels=c("<small>Good", "Moderate", "Unhealthy for<br>Sensitive Groups", "Unhealthy", "Very Unhealthy", "Hazardous","No AQ Data"),
            position = 'topright')

# Export as HTML file
# saveWidget(california_map, 'docs/map_california.html', title = "ABC Owned Television Stations Wildfire Tracker", selfcontained = TRUE)
saveWidget(airquality_map_SF, 'docs/map_AQ_SF.html', title = "ABC Owned Television Stations ABC7 Air Quality Tracker", selfcontained = TRUE)
saveWidget(airquality_map_LA, 'docs/map_AQ_LA.html', title = "ABC Owned Television Stations ABC7 Air Quality Tracker", selfcontained = TRUE)
saveWidget(airquality_map_Fresno, 'docs/map_AQ_Fresno.html', title = "ABC30 Air Quality Tracker", selfcontained = TRUE)
saveWidget(airquality_map_Philadelphia, 'docs/map_AQ_Philadelphia.html', title = "6ABC Air Quality Tracker", selfcontained = TRUE)
saveWidget(airquality_map_Chicago, 'docs/map_AQ_Chicago.html', title = "ABC7 Air Quality Tracker", selfcontained = TRUE)
saveWidget(airquality_map_Houston, 'docs/map_AQ_Houston.html', title = "ABC13 Air Quality Tracker", selfcontained = TRUE)
saveWidget(airquality_map_Raleigh, 'docs/map_AQ_Raleigh.html', title = "ABC11 Air Quality Tracker", selfcontained = TRUE)
saveWidget(airquality_map_NYC, 'docs/map_AQ_NYC.html', title = "ABC7 Air Quality Tracker", selfcontained = TRUE)
saveWidget(airquality_map_National, 'docs/map_AQ_National.html', title = "ABC Owned Television Stations Air Quality Tracker", selfcontained = TRUE)
saveWidget(airquality_map_Nationwide, 'docs/map_AQ_Nationwide.html', title = "ABC Owned Television Stations Air Quality Tracker", selfcontained = TRUE)

