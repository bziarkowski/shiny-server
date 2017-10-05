library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotly)
library(shinyjs)
library(scales)
dat = readRDS('data/data.RDS')
dat2 = readRDS('data/sim.RDS')

teams = sort(as.character(unique(dat[[2]]$Drużyna)))

server = function(input, output, session) {
  
  addClass(selector = "body", class = "sidebar-collapse")
  
  get_team_name = reactive({
  df = data.frame(long = c('Anwil Włocławek', 'MKS Dąbrowa Górnicza', 'GTK Gliwice', 'AZS Koszalin',
                           'Legia Warszawa', 'Miasto Szkła Krosno', 'Asseco Gdynia', 'Polpharma Starogard Gd.',
                           'Rosa Radom', 'King Szczecin', 'Czarni Słupsk', 'BM Slam Stal Ostrów Wlkp.',
                           'Polski Cukier Toruń', 'Trefl Sopot', 'PGE Turów Zgorzelec', 'TBV Start Lublin',
                           'Stelmet BC Zielona Góra'),
                  short = sort(as.character(unique(dat[[2]]$Drużyna))))
  selected = df$short[df$long == input$druzyna]
  return(selected)
})
  
  
  output$win_dist = renderPlot({
    dat1 = dat[[1]]
    dat1 = dat1[dat1$Drużyna == get_team_name(),]
    dat1$labs = paste(dat1$Prawdopodobieństwo, '%', sep = '')
    dat1$labs[dat1$labs=='0%'] = ''
    dat1$Prawdopodobieństwo = dat1$Prawdopodobieństwo/100
    
    plot = ggplot(dat1, aes(x = Zwycięstwa, y = Prawdopodobieństwo, fill = Prawdopodobieństwo)) +
      geom_bar(stat = 'identity') +
      geom_text(aes(label = labs), alpha = 0.7, vjust = -0.25, size = 4.5) +
      guides(fill = FALSE) +
      theme_minimal() +
      theme(axis.title.y = element_text(margin = margin(r = 10), size = 15),
            axis.title.x = element_text(size = 15),
            axis.text.x = element_text(size = 12),
            axis.text.y = element_text(size = 10)) +
      scale_y_continuous(labels = percent_format()) 
    
    print(plot)
  })
  
  output$rank_dist = renderPlot({
    dat1 = dat[[2]]
    dat1 = dat1[dat1$Drużyna == get_team_name(),]
    dat1$labs = paste(dat1$Prawdopodobieństwo, '%', sep = '')
    dat1$labs[dat1$labs=='0%'] = ''
    dat1$Prawdopodobieństwo = dat1$Prawdopodobieństwo/100
    
    plot = ggplot(dat1, aes(x = `Miejsce w tabeli`, y = Prawdopodobieństwo, fill = Prawdopodobieństwo)) +
      geom_bar(stat = 'identity') +
      geom_text(aes(label = labs), alpha = 0.7, vjust = -0.25, size = 4.5) +
      guides(fill = FALSE) +
      theme_minimal() +
      theme(axis.title.y = element_text(margin = margin(r = 10), size = 15),
            axis.title.x = element_text(size = 15),
            axis.text.x = element_text(size = 12),
            axis.text.y = element_text(size = 10)) +
      scale_y_continuous(labels = percent_format()) 
    print(plot)
  })
  
  output$Mediana_zw = renderValueBox({
    wins = dat[[3]]$median_wins[dat[[3]]$team == get_team_name()]
    infoBox(
       'Mediana zwycięstw', paste(wins),icon = icon('trophy'),
      color = 'blue', fill = TRUE
    )
  })
  
  output$po_szanse = renderValueBox({
    po_prob = dat[[3]]$playoffs_prob[dat[[3]]$team == get_team_name()]
    infoBox(
      'Playoffy', paste(po_prob, '%', sep = ''),icon = icon('thumbs-up'),
      color = 'green', fill = TRUE
    )
  })
  
  output$spadek_szanse = renderValueBox({
    last_prob = dat[[3]]$last_prob[dat[[3]]$team == get_team_name()]
    infoBox(
      'Spadek', paste(last_prob, '%', sep = ''),icon = icon('thumbs-down'),
      color = 'red', fill = TRUE
    )
  })
  
  
  
  
}