#function(request) {
fluidPage(
  tags$head(
    tags$link(rel="stylesheet", type="text/css", href="style.css"),
    includeScript("js/iframeSizer.contentWindow.min.js"),
    includeScript("js/fuctInter.js")
  ),
  tabsetPanel(id = 'menuSup',
    tabPanel(value = 'percepcion',
      HTML("<img src='img/menu/datospercepcion.png' class = 'imgTab'> 
           <span> Datos de percepción</span>"),
      
      div(class="col-xs-12 col-md-3",
          div(class="sidNav",
             tabsetPanel(type="pills", id = 'theTabs',
                 tabPanel('Por tema',  value = 'tabTema' ,
                      div(class="tab-content", id = "cajaDiv",  
                       div(class="containerButtons", id="styleScroll",
                            uiOutput('botonesSubjetivos')
                          ),
                            uiOutput('SelectorVarSubjetivos')
                          )  
                          ),
                 tabPanel('Por ciudad', value = 'tabCiud',
                                           
                                       div(class = 'contTema',
                                           div(class="tab-content", id = "cajaDivCiudad",
                                           uiOutput('CiudSubj'),
                                           
                                            div(class="containerButtonsCiudad", id="styleScroll",
                                             uiOutput('BotCiudadSubj')
                                           ),
                                           uiOutput('varCiudadSubj')
                                       )
                                   
                          )
                 )   
              )
          )
      ),
      div(class="col-xs-12 col-md-9", 
          conditionalPanel(
          condition = "input.theTabs== 'tabTema'",
          div(class = 'container',
              div(class = 'row',
                  div(class="col-xs-12 col-md-9", style="text-align: center;",
                      
          uiOutput('grafSubj')))),
          div(class = 'contViz',
          uiOutput('VizSubj'),
          uiOutput('anioSubj')
             )
         ),
         conditionalPanel(
           condition = "input.theTabs== 'tabCiud'", 
           div(class = 'container',
               div(class = 'row',
                   div(class="col-xs-12 col-md-9", style="text-align: center;",
          uiOutput('grafSubjCiud')))),
          div(class = 'contVizCiud',
           uiOutput('VizSubjCity')
          )
         )
      )
    ),
    tabPanel(value = 'oficiales',
HTML("<img src='img/menu/datosoficiales.png' class = 'imgTab'> 
        <span> Datos oficiales</span>"),
             div(class="col-xs-12 col-md-3",
                 div(class="sidNav",
                     tabsetPanel(type="pills", id = 'theTabsObj',
                                 tabPanel('Por tema',  value = 'tabTemaObj' ,
                                          div(class="tab-content", id = "cajaDiv",  
                                              div(class="containerButtons", id="styleScroll",
                                                  uiOutput('botonesObjetivos')
                                              ),
                                              uiOutput('SelectorVarObjetivos')
                                          )  
                                 ),
                                 tabPanel('Por ciudad', value = 'tabCiudObj',
                                          
                                          div(class = 'contTema',
                                              div(class="tab-content", id = "cajaDivCiudad",
                                                  uiOutput('CiudObj'),
                                                  div(class="containerButtonsCiudad", id="styleScroll",
                                                  uiOutput('BotCiudadObj')
                                                  ),
                                                  uiOutput('varCiudadObj')
                                              )
                                              
                                          )
                                 )   
                     )
                 )
             ),
             div(class="col-xs-12 col-md-9", 
                 conditionalPanel(
                   condition = "input.theTabsObj == 'tabTemaObj'",
                   div(class = 'container',
                       div(class = 'row',
                           div(class="col-xs-12 col-md-9", style="text-align: center;",  
                 uiOutput('grafObj')))),
                 div(class = 'contViz',
                 uiOutput('VizObj'),
                 uiOutput('anioObj')
                 )
                 ),
                 conditionalPanel(
                   condition = "input.theTabsObj == 'tabCiudObj'",
                   div(class = 'container',
                       div(class = 'row',
                           div(class="col-xs-12 col-md-9", style="text-align: center;",
                   uiOutput('grafObjCiudades')))),
                   div(class = 'contVizCiud',
                   #    verbatimTextOutput('baks')
                   uiOutput('VizObjCif')
                   
                   )
                   #verbatimTextOutput('salida')
                 )
             )
    ),
    tabPanel(value = 'cruces',
      HTML("<img src='img/menu/cruces.png' class = 'imgTab'> Cruces"),
             
            # div(class = 'container',
                 div(class = 'row',
                     div(class = 'col-md-9', style = 'float:right;',
                         div (class = 'blabla',
                         uiOutput('botonesCruces'))),
                     div(class = 'col-md-3',  style = 'float:left;',
                         uiOutput('CiudadCruce')
                        # )
             )),
         # div(class = 'container',
              div(class = 'row',
                  div(class = 'col-md-6 col-lg-6', style = 'margin-top: -23px; text-align: -webkit-center;',
                      uiOutput('percCruces'),
                      #verbatimTextOutput('gahsgs')),
                      highchartOutput('grafSubC')),
                  div(class = 'col-md-6 col-lg-6',
                      uiOutput('oficCruces'), style = 'margin-top: -23px; text-align: -webkit-center;',
                      highchartOutput('grafObjC')))
              #)
             #verbatimTextOutput('tabla')
                 ),
    tabPanel(value = 'indices',
      HTML("<img src='img/menu/indice.png' class = 'imgTab'> Índices"),
         
      tabsetPanel(id = 'MenuIndices', type = 'tabs',
                
  tabPanel(
    'IPS',
  
         div( class = 'row',
              div( class = 'col-md-3',
    div(class = 'contIPSMenu',
    uiOutput('radIps'),
    uiOutput('anioIPS'),
    uiOutput('legMap')
    )),
    div(class = 'col-md-9', style = 'margin-top: 6px;text-align: -webkit-center;',
        conditionalPanel(
          condition = "input.claseIPS == 'Departamentos'",
          div(class = 'contViz',
          highchartOutput('mapDepto', width = 550, height = 450))
        ),
        conditionalPanel(
          condition = "input.claseIPS == 'Ciudades'",
          div(class = 'contViz',
          highchartOutput('mapCiudad', width = 550, height = 450))
        ),
        conditionalPanel(
          condition = "input.claseIPS == 'Bogotá'",
          div(class = 'contViz',
          leafletOutput('mapLocalidad'))
        )
        #leafletOutput('mapLocalidad')
        #highchartOutput('mapCiudad')
        #verbatimTextOutput('tablaIPS')
        )
    )#)
    #uiOutput('butMenuIps')
  ),
  tabPanel(
    'ODS',
    #div( class = 'container',
         div( class = 'row',
              div( class = 'col-md-3',
                   div(class = 'contIPSMenu',
                uiOutput('botonesODS'))
                ),
  div( class = 'col-md-9',
  div( class = 'row',
      div( class = 'col-md-6', style = 'margin-top: -4px; margin-left: -15px;',
  uiOutput('selods')),
  div( class = 'col-md-6', style= 'display: flex;
    margin-left: -28px;
    margin-top: 15px;',
  uiOutput('textOds')
  #)
  ),
  div(class = 'contVizOds',
                 highchartOutput('vizOds')
  )
              )
              ))
  ),
  tabPanel(
    'ICU',
    uiOutput('selCiudUn'),
    div(class = 'grafICU',
    highchartOutput('vizCU', width = 750)
    )
  ),
  tabPanel(
    'EOT',
    uiOutput('selindeot'),
    div(class = 'grafICU',
    highchartOutput('vizlinEot', width = 750))#,
    
  )
                  )
      )
             
  )#,
#bookmarkButton(label = 'Compartir', title = '')


#verbatimTextOutput("clientdataText"),
#verbatimTextOutput('skd')#,
#uiOutput("link")
#   verbatimTextOutput('kds'),
# verbatimTextOutput("urlText"),
# 
# h3("Parsed query string"),
# verbatimTextOutput("queryText"),
# verbatimTextOutput("clientdataText")
  
)#}

