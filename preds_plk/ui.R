library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotly)
library(shinyjs)
library(scales)
dat = readRDS('data/data.RDS')

mydashboardHeader <- function(..., title = 'Przewidywania PLK', disable = FALSE,title.navbar=NULL, .list = NULL) {
  items <- c(list(...), .list)
  #lapply(items, tagAssert, type = "li", class = "dropdown")
  tags$header(class = "main-header",
              style = if (disable) "display: none;",
              span(class = "logo", title),
              tags$nav(class = "navbar navbar-static-top", role = "navigation",
                       # Embed hidden icon so that we get the font-awesome dependency
                       span(shiny::icon("bars"), style = "display:none;"),
                       # Sidebar toggle button
                       #                        a(href="#", class="sidebar-toggle", `data-toggle`="offcanvas",
                       #                          role="button",
                       #                          span(class="sr-only", "Toggle navigation")
                       #                        ),
                       
                       title.navbar,
                       div(class = "navbar-custom-menu",
                           tags$ul(class = "nav navbar-nav",
                                   items
                           )
                       )
              )
  )
}

teams = c('Anwil Włocławek', 'MKS Dąbrowa Górnicza', 'GTK Gliwice', 'AZS Koszalin',
           'Legia Warszawa', 'Miasto Szkła Krosno', 'Asseco Gdynia', 'Polpharma Starogard Gd.',
           'Rosa Radom', 'King Szczecin', 'Czarni Słupsk', 'BM Slam Stal Ostrów Wlkp.',
           'Polski Cukier Toruń', 'Trefl Sopot', 'PGE Turów Zgorzelec', 'TBV Start Lublin',
           'Stelmet BC Zielona Góra')


dashboardPage(
  mydashboardHeader(
    tags$li(class = "dropdown",
                            tags$a(href="http://twitter.com/bziarkowski", target="_blank", 
                                   tags$img(height = "20px", alt="twitter Logo", src="https://directsoftwareoutlet.com/wp-content/uploads/2016/04/twitterLogo-white.png")
                            )),
                    tags$li(class = "dropdown",
                            tags$a(href='http://www.pulsbasketu.pl/author/bziarkowski/', target="_blank", 
                                   tags$img(height = "25px", alt="web Logo", src="http://static.wixstatic.com/media/51092d_1055480a0fe2402dba63bb799c019757.png")
                            )),
                    tags$li(class = "dropdown",
                            tags$a(href='mailto:bziarkowski1@gmail.com', target="_blank", 
                                   tags$img(height = "25px", alt="mail Logo", src="http://3g28wn33sno63ljjq514qr87.wpengine.netdna-cdn.com/wp-content/themes/maginess/img/social/email.gif")
                            ))),
  dashboardSidebar(
  ),
  dashboardBody(
    useShinyjs(),
    
    fluidRow(
      h2('',style='margin-top:10px;margin-bottom:30px;')
    ),
    
    fluidRow(style = 'margin-left:30%;margin-right:30%',align = 'center',
      selectInput('druzyna', 'Drużyna', choices = sort(teams), selected = teams[1])
    ),

    
    fluidRow(
      h2('',style='margin-top:50px;margin-bottom:50px;')
    ),
    
    fluidRow(style = 'margin-left:10%;margin-right:10%',
      valueBoxOutput('Mediana_zw'),
      valueBoxOutput('po_szanse'),
      valueBoxOutput('spadek_szanse')),
    
    fluidRow(
      h2('',style='margin-top:30px;margin-bottom:30px;')
    ),
    
    fluidRow(style = 'margin-left:9.1%;margin-right:9.1%',
      column(12, 
             box(width = 12, solidHeader = TRUE, status = 'primary',
               title = 'Rozkład prawdopodobieństwa dla zwycięstw',
               plotOutput('win_dist')
             )
             )
    ),
    
    fluidRow(
      h2('',style='margin-top:30px;margin-bottom:30px;')
    ),
    
    fluidRow(style = 'margin-left:9.1%;margin-right:9.1%',
      column(12,
             box(width = 12, solidHeader = TRUE, status = 'primary',
                 title = 'Rozkład prawdopodobieństwa dla miejsca w tabeli',
                 plotOutput('rank_dist')
                 )
             )
    ),
    
    fluidRow(
      h2('',style='margin-top:30px;margin-bottom:30px;')
    ),
    
    fluidRow(align = 'center',
      h5('Autor: Bartosz Ziarkowski'),
      h5('pulsbasketu.pl')
    ),
    
    fluidRow(
      h2('',style='margin-bottom:10px')
    )
    
    
  )
)