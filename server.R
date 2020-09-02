
# Define server logic required to draw a histogram
shinyServer(function(input, output) {

 # Trend Line
 output$trend_line <- renderPlotly({
     
     p1 <- covid %>% 
         filter(Country %in% input$trend_country) %>% 
         ggplot(aes(Date, Case, color = Country, group = Country,
                    
                    text = glue("Country : {paste0(Country, ',', State)}
                     Date : {Date}
                     Case : {number(Case, big.mark = ',')}
                     Recovery : {number(Recover, big.mark = ',')}
                     Death : {number(Death, big.mark = ',')}")
         )) +
         scale_y_continuous(labels = number_format(big.mark = ",")) +
         scale_x_date(date_breaks = "1 month",
                      labels = date_format(format = "%b")
         ) +
         geom_line() +
         labs(title = "COVID-19 Case by Country",
              x = NULL,
              y = "Number of Cases",
              color = "Country"
         ) +
         theme_algo
     
     ggplotly(p1, tooltip = "text")  
 })
    
 
 # MAP
 output$map_leaflet <- renderLeaflet({
     
     content_popup <- paste(sep = " ",
                            "Region :", covid_update$Country, ",", covid_update$State, "<br>",
                            "Cases :", number(covid_update$Case, big.mark = ",", accuracy = 1), "<br>",
                            "Death :", number(covid_update$Death, big.mark = ",", accuracy = 1), "<br>",
                            "Recovery :", number(covid_update$Recover, big.mark = ",", accuracy = 1), "<br>", 
                            "CFR :", percent(covid_update$cfr, accuracy = 0.01) 
     )
     
     leaflet() %>% 
         addTiles() %>% 
         addMarkers(data = covid_update,
                    lng = ~Long, lat = ~Lat, 
                    popup = content_popup,
                    clusterOptions = markerClusterOptions()
         )
 })
 
 # Bar Chart
 output$stat_death <- renderPlotly({
     
     p1 <- covid %>% 
         filter(Date == (input$date)) %>% 
         drop_na(Case, Recover, Death) %>% 
         group_by(Country) %>% 
         summarise(Death = sum(Death)) %>% 
         arrange(desc(Death)) %>% 
         slice(1:10) %>% 
         ggplot(aes(Death, reorder(Country, Death), fill = Death,
                    
                    text = glue("Country : {Country}
                         Death : {number(Death, big.mark = ',')}")
         )) +
         geom_col(color = "firebrick") +
         theme_minimal() +
         labs(x = "Number of Death",
              y = NULL,
              title = "Top Countries Based on Number of Death"
         ) +
         scale_fill_gradient(low = "lightyellow", high = "firebrick") +
         scale_x_continuous(labels = number_format(big.mark = ",")) +
         theme(legend.position = "none")
     
     ggplotly(p1, tooltip = "text")
 })
     
     output$stat_recover <- renderPlotly({
         
         p1 <- covid %>% 
             filter(Date == (input$date)) %>% 
             drop_na(Case, Recover, Death) %>%
             group_by(Country) %>% 
             summarise(Recover = sum(Recover)) %>% 
             arrange(desc(Recover)) %>% 
             slice(1:10) %>% 
             ggplot(aes(Recover, reorder(Country, Recover), fill = Recover,
                                   
                                   text = glue("Country : {Country}
                                               Recover : {number(Recover, big.mark = ',')}")
                        )) +
             geom_col(color = "#3bac01") +
             theme_minimal() +
             labs(x = "Number of Recovery",
                  y = NULL,
                  title = "Top Countries Based on Number of Recovery"
                        ) +
             scale_fill_gradient(low = "lightyellow", high = "#3bac01") +
             scale_x_continuous(labels = number_format(big.mark = ",")) +
             theme(legend.position = "none")
                    
             ggplotly(p1, tooltip = "text")
     })
 
 # Full Data
 output$data_table <- DT::renderDataTable({
     
     DT::datatable(covid, 
                   options = list(scrollX = T))
 })
 
 # Download
 output$download <- downloadHandler( 
     filename = function() {paste("data-", Sys.Date(), ".csv", sep="")},
     content = function(file) {
         write.csv(covid, file, row.names = F)
     })
    
})
