
# Define UI for application that draws a histogram
shinyUI(
    
    dashboardPage(
        
        dashboardHeader(title = "COVID-19 Tracker"),
        
        dashboardSidebar(
            
            sidebarMenu(
                menuItem(text = "Trend", icon = icon("chart-line"), tabName = "trend"),
                menuItem(text = "Map", icon = icon("map-marked-alt"), tabName = "map"),
                menuItem(text = "Statistics", icon = icon("info-circle"), tabName = "stat"),
                menuItem(text = "Data", icon = icon("table"), tabName = "data")
            )

        ),
        
        dashboardBody(
            
            shinyDashboardThemes("flat_red"),
            
            # Trend
            tabItems(
                
                tabItem(tabName = "trend", align = "center", 
                    
                    h2("COVID-19 Trend Over Time"),
                    
                    h4("Coronavirus disease (COVID-19) is an infectious disease caused by a newly discovered coronavirus."),
                    h4("Most people who fall sick with COVID-19 will experience mild to moderate symptoms and recover without special treatment."),
                    
                    selectInput(inputId = "trend_country", label = "Select Country", 
                                choices = unique(covid$Country), 
                                selected = c("Indonesia", "India"), 
                                multiple = T),
                    
                    plotlyOutput("trend_line", height = "500px")
                ),
                
                # Map
                tabItem(tabName = "map", align = "center",
                        
                        h2(paste("Global Cases per", covid_update$Date[1])),
                        
                        fluidRow(
                            
                            column(width = 4, 
                                   valueBox(subtitle = "Number of Cases", 
                                            color = "red",
                                           value = number(sum(covid_update$Case, na.rm = T), accuracy = 1, big.mark = ","),
                                           icon = icon("virus"), 
                                           width = 12)
                            ),  
                            column(width = 4, 
                                   valueBox(subtitle = "Number of Death", 
                                            color = "black",
                                           value = number(sum(covid_update$Death, na.rm = T), accuracy = 1, big.mark = ","),
                                           icon = icon("book-dead"),
                                           width = 12)
                                   ),  
                            column(width = 4, 
                                   valueBox(subtitle = "Number of Recovery", 
                                            color = "green",
                                           value = number(sum(covid_update$Recover, na.rm = T), accuracy = 1, big.mark = ","),
                                           icon = icon("plus-square"),
                                           width = 12
                                           )
                                   )  
                            
                        ),
                        
                        leafletOutput("map_leaflet", height = "600px")
                        
                        ),
                
                # Statistics
                
                tabItem(tabName = "stat", align = "center",
                    
                    h2("Covid-19 Comparative Case"),
                    
                    dateInput("date", label = "Select Date", value = max(covid$Date)),
                    
                    fluidRow(
                        column(6, plotlyOutput("stat_death")),
                        column(6, plotlyOutput("stat_recover"))
                    )
                    
                ),
                
                # Data
                tabItem(tabName = "data", 
                        
                        h2("COVID-19 Data"),
                        
                        br(),
                        
                        downloadButton(outputId = "download", label = "Download Data"),
                        
                        br(), 
                        
                        DT::dataTableOutput("data_table"),
                        
                        h4("Source: Center for Systems Science and Engineering (CSSE) at Johns Hopkins University")
                        )
            )
        )
    )
    
    )
