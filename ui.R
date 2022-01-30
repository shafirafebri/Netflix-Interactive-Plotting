# Design header
header <- dashboardHeader(title = "Netflix Analysis")

# Design sidebar
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem(text = "Home", icon = icon("home"), tabName = "home"), # menu 1
    menuItem(text = "Top Country", icon = icon("flag"), tabName = "top"), # menu 2
    menuItem(text = "Analysis", icon = icon("chart-area"), tabName = "content"),# menu 3
    menuItem(text = "Data Source", icon = icon("table"), tabName = "data") # menu 4
  )
)

# untuk design body dashboard
body <- dashboardBody(
  #home
  tabItems(
    tabItem(
      tabName = "home",
      fluidRow(
        # Welcome box
        box(
          title = "",
          status = "danger",
          width = 12,
          img(
            src = "netflix.png",
            height = 50,
            width = 50
          ),
          h2("Capstone Project Interactive Plotting"),
          h4("Dynamic Web-based Analytics about Netflix Content"),
          br(),
          h4(
            "This project is one of my progress of learning data science in 2022.",
            "It was build on top of R for Netflix content data analytics.",
            "Thank you for stopping by!"
          ),
          h4("To get started, select one of the sidepanel."),
          br(),
          h4(
            HTML('&copy'),
            'January 2022 By Shafira R. Febriyanti '
          )
        ),
        
        # Projects, companies, and facilities value boxes
        uiOutput("total"),
        uiOutput("movie"),
        uiOutput("tvshow")
      )
    ),
    # menu tab 2
    tabItem(tabName = "top",
              
              fluidRow(
                box(width = 3, title = "Choose content",
                    status = "danger",
                    pickerInput(inputId = "type_input", 
                                label = "Type of content:", 
                                choices = levels(netflix_clean$type),
                                selected = c("Movie","TV Show"),
                                multiple = TRUE)
                    ),
                
                fluidRow(
                  box(width = 3, title = "Choose year",
                      status = "danger",
                      selectInput(inputId = "year_data", 
                                  label = "Year list:", 
                                  choices = levels(netflix_clean$release_year),
                                  selected = "2021")),
                  
                ),
                column(width = 9,
                       plotlyOutput(outputId = "plot1")),

                
                  
                ),
            br(),
            fluidRow(
              uiOutput("top1"),
              uiOutput("top2"),
                  
                ),
            
          
    ),
    # menu tab 3
    tabItem(tabName = "content",
            tabsetPanel(
              tabPanel("Month Distribution",
                       fluidRow(
                         
                         column(width = 9,
                                plotlyOutput(outputId = "plot4"))
                       )),
              tabPanel("Content Development",
                       fluidRow(
                         box(width = 3, title = "Choose starting year",
                             status = "danger",
                             selectInput(
                               inputId =  "date_from", 
                               label = "Year list:", 
                               choices = 2008:2020
                             )),
                         column(width = 9,
                                plotlyOutput(outputId = "plot3"))
                       )),
              
              tabPanel("Rating Distribution",
                       fluidRow(
                         box(width = 3, title = "Choose year",
                             status = "danger",
                             selectInput(inputId = "year_data2", 
                                         label = "Year List:", 
                                         choices = levels(netflix_clean$release_year),
                                         selected = "2021")),
                         column(width = 9,
                                plotlyOutput(outputId = "plot2"))
                         ))
              
              )
           
            
    ),
    
    # menu tab 4
    tabItem(tabName = "data",
            fluidRow(box(width = 12, title = "Overview Netflix Content Data",
                         status = "danger",
                         dataTableOutput(outputId = "netflix_data")),
      
            )
    )
  )
)

# untuk menggabungkan header, sidebar, dan body dalam 1 page dashboard
dashboardPage(header = header, sidebar = sidebar, body = body, skin = "red")