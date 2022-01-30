function(input, output){
  options(scipen = 999)
  # total
  output$total <- renderUI({
    valueBox(
      total,
      "Total Content in Database",
      icon = icon("database"),
      color = "red"
    )
  })
  
  # movie
  output$movie <- renderUI({
    valueBox(
      movie,
      "Movies",
      icon = icon("film"),
      color = "blue")
  })
  
  # tvshow
  output$tvshow <- renderUI({
    valueBox(
      tvshow,
      "TV Shows",
      icon = icon("tv"),
      color = "yellow")
  })
  
  # Calculate the number of unique companies, projects, and facilities in database
  
  movie <- head(netflix_type$n_type,1)
  tvshow <- tail(netflix_type$n_type,1)
  total <- movie + tvshow
  
  output$plot1 <- renderPlotly({
    # data untuk plot_case1
    case1 <- netflix_clean %>%
      filter(release_year == input$year_data, type == input$type_input) %>% 
      select(first_country, title,type) %>% 
      group_by(first_country,type) %>% 
      summarise(n = n()) %>% 
      arrange(desc(n)) 
    
    # visualisasi untuk plot1
    plot1 <- ggplot(data = head(case1,10), mapping = aes(x = n, y = reorder(first_country, n), text = glue("first_country: {n}"))) +
      geom_col(mapping = aes(fill = type))+
      labs(y = NULL, x = "Total Konten", title = "Top Countries with Most Content", 
           subtitle = "")+
      scale_fill_manual(values=mycolors)
    
    ggplotly(plot1, tooltip = "text")
    
  })
  # top1
  output$top1 <- renderUI({
    valueBox(
      top1,
      "Top 1",
      icon = icon("star"),
      color = "red"
    )
  })
  
  # movie
  output$top2 <- renderUI({
    valueBox(
      top2,
      "Top 2",
      icon = icon("star"),
      color = "blue")
  })
  

  
  # Top Countries Object
  
  top1 <- case1$first_country[1]
  top2 <- case1$first_country[2]

  
  output$plot2 <- renderPlotly({
    # data untuk plot_case2
    case2 <- netflix_clean %>% 
      filter(release_year == input$year_data2) %>%
      select(rating,type) %>% 
      group_by(rating,type) %>% 
      summarise(n = n(), .groups = 'drop') %>%
      ungroup()
    
    # visualisasi plot2
    plot2 <- ggplot(data = case2, mapping = aes(x = n, y = reorder(rating, n),
                                                text = glue("rating: {n}"))) +
      geom_col(mapping = aes(fill = type))+
      labs(y = NULL, x = "Total Konten", title = "Netflix Content Rating Distirbution", 
           subtitle = "")+
      scale_fill_manual(values=mycolors)
    
    ggplotly(plot2, tooltip = "text")
    
  })
  
  output$plot3 <- renderPlotly({
    # data untuk plot_case3
    case3 <- netflix_clean %>%
      
      filter(year_added >= input$date_from) %>% 
      select(year_added,type) %>%
      drop_na(year_added) %>%
      group_by(year_added,type) %>% 
      summarise(n = n(), .groups = 'drop') %>%
      ungroup()
    
    # visualisasi plot3
    plot3 <- ggplot(data=case3, aes(x=year_added, 
                                    y=n,
                                    text = glue("n: {type}"),
                                    fill = type)) +
      geom_area()+
      labs(y = NULL, x = NULL, title = "Growth in Content over the Years", 
           subtitle = "")+
      scale_fill_manual(values=mycolors)
      
    
    ggplotly(plot3, tooltip = "text")
    
  })
  
  output$plot4 <- renderPlotly({
    # data untuk plot_case4
    case4 <- netflix_clean %>%
      filter(year_added > 2008) %>%
      group_by(year_added,month_added) %>%
      summarise(jumlah_konten = n(), .groups = 'drop') %>%
      ungroup() %>%
      arrange(desc(jumlah_konten))

    # visualisasi plot4
    plot4 <- ggplot(data=case4, aes(x=year_added, fill = jumlah_konten, y=month_added)) +
      geom_tile()+
      scale_fill_gradient(low="#E50914",high="#141414") +
      labs(title = "Netflix Content Monthly Update",
           x =  NULL,
           y =  NULL,
           fill = "Jumlah Konten")
    ggplotly(plot4)

  })

  # Data Table
  output$netflix_data<- renderDataTable({
    DT::datatable(data = netflix_clean, 
                  options = list(scrollX = TRUE, scrollY = TRUE))
  })
  
  
  
}