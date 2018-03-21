

fluidPage(
  useShinyjs(),
  conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                   tags$img(src = 'temas/Cargando.gif', class="loadmessage")),
  tags$head(
    tags$link(rel="stylesheet", type="text/css", href="styles.css"),
     includeScript("js/iframeSizer.contentWindow.min.js"),
     includeScript("js/funcJs.js")
   ),
 # div(class = 'container',
  div(class = 'row',
      div(class = 'col-md-3 styCont',
      div(class = 'contLat',
      uiOutput('idbase'),
      div(class="containerButtons", id="styleScroll",
          uiOutput('Menu'),
          uiOutput('aver')
       ),
      uiOutput('SelCiudad'),
      div( class = 'butAl',
      uiOutput('salida'))
      )),
      div(class = 'col-md-9',
          #verbatimTextOutput('blabla'),
          div(class = 'contTab', id = 'styleScrollx',
          dataTableOutput('printData')),
      conditionalPanel('input.basechoose != "ips"',
       uiOutput('downFiltros')
      )
      )
     )
    #)
)