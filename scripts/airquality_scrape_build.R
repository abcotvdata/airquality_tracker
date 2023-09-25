library(leaflet)
library(leaflet.providers)
library(htmltools)
library(sf)
library(htmlwidgets)

# Obtain the latest air quality geofile from AirNow via federal government
# This step is now automated in a yaml trigger by Github Actions; see workflows
# Left here in case it ever needs to be run manually
# try(download.file("https://services.arcgis.com/cJ9YHowT8TU7DUyn/arcgis/rest/services/AirNowLatestContoursCombined/FeatureServer/0/query?where=0%3D0&objectIds=&time=&geometry=&geometryType=esriGeometryEnvelope&inSR=&spatialRel=esriSpatialRelIntersects&resultType=none&distance=0.0&units=esriSRUnit_Meter&returnGeodetic=false&outFields=*&returnGeometry=true&returnCentroid=false&featureEncoding=esriDefault&multipatchOption=xyFootprint&maxAllowableOffset=&geometryPrecision=&outSR=&datumTransformation=&applyVCSProjection=false&returnIdsOnly=false&returnUniqueIdsOnly=false&returnCountOnly=false&returnExtentOnly=false&returnQueryGeometry=false&returnDistinctValues=false&cacheHint=false&orderByFields=&groupByFieldsForStatistics=&outStatistics=&having=&resultOffset=&resultRecordCount=&returnZ=false&returnM=false&returnExceededLimitFeatures=true&quantizationParameters=&sqlFormat=none&f=pgeojson","data/airnow_aq.geojson"))

# Read in the air quality .geojson file
# We're using the combined contour file, which
# combines ozone and PM25 which is the primary measure for AQI
air_quality <- st_read("data/airnow_aq.geojson")

# Creating a color palette for air quality levels to match AQI/AirNow's method
airpal <- colorFactor(palette = c("#b1dbad", 
                                  "#ffffb8", 
                                  "#ffcc80",
                                  "#ff8280",
                                  "#957aa3",
                                  "#a18f7f"),
                      levels = c("1", "2", "3", "4","5","6"), 
                      na.color = "#ff8280")

# Creating a unique title and subhead for SF map
# to satisfy a special request from the KGO digital team
tag.map.title <- tags$style(HTML("
  .leaflet-control.map-title {
    left: 0.5%;
    top: 0.8%;
    text-align: left;
    background-color: background:#0059F6;
    width: 50%;
    border-radius: 4px 4px 4px 4px;
  }
  .leaflet-control.map-title .headline{
    font-weight: bold;
    font-size: 28px;
    color: white;
    padding: 0px 5px;
    background-color: #F98C00;
    background:#0059F6;
    border-radius: 4px 4px 0px 0px;
  }
  .leaflet-control.map-title .subheadline {
    font-size: 14px;
    color: black;
    padding: 5px 30px 5px 10px;
    background: white;
    border-radius: 0px 0px 4px 4px;
  }
  .leaflet-control.map-title .subheadline a {
    color: #BE0000;
    font-weight: bold;
  }
  
  @media only screen and (max-width: 550px) {
    .leaflet-control.map-title .headline {
      font-size: 20px;
    border-radius: 4px 4px 0px 0px;
    }
    .leaflet-control.map-title .subheadline {
      font-size: 10px;
    border-radius: 0px 0px 4px 4px;
    }
  @media only screen and (max-width: 420px) {
    .leaflet-control.map-title .headline {
      font-size: 18px;
    border-radius: 4px 4px 0px 0px;
    }
    .leaflet-control.map-title .subheadline {
      font-size: 9px;
    border-radius: 0px 0px 4px 4px;
    }
"))

sfheaderhtml <- tags$div(
  tag.map.title, HTML(paste(sep="",
                            "<div class='headline'>Air Quality Tracker</div>
  <div class='subheadline'>See how wildfire smoke, smog and weather are impacting air quality across the Bay Area and statewide.<div>")
  )
)

# Creation of a series of leaflet maps, customized to zoom to each station's coverage area
# Note that the San Francisco version calls the above specialty header text
# The others are standard, but could be customized in a similar way

# SAN FRANCISCO
airquality_map_SF <- leaflet(options = leafletOptions(zoomControl = FALSE, hoverToWake=FALSE)) %>%
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
            position = 'topright') %>% 
      addControl(position = "topleft", html = sfheaderhtml, className="map-title") %>%  
      htmlwidgets::onRender("function(el, x) {
        L.control.zoom({ position: 'topleft'}).addTo(this)
    }") 

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
  addLegend(values = values(air_quality$gridcode), title = "<small>Air Quality Index updated hourly from EPA's AirNow system<br><a href='https://www.airnow.gov/aqi/aqi-basics/' target='blank'>See what AQI ratings mean</a>", 
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
  addLegend(values = values(air_quality$gridcode), title = "<small>Air Quality Index updated hourly<br>from EPA's AirNow system<br><a href='https://www.airnow.gov/aqi/aqi-basics/' target='blank'>See what AQI ratings mean</a>", 
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
  addLegend(values = values(air_quality$gridcode), title = "<small>Air Quality Index<br><a href='https://www.airnow.gov/aqi/aqi-basics/' target='blank'>What AQI ratings mean</a>", 
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
  addLegend(values = values(air_quality$gridcode), title = "<small>Air Quality Index<br><a href='https://www.airnow.gov/aqi/aqi-basics/' target='blank'>What AQI ratings mean</a>", 
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
