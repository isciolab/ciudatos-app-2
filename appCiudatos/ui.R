#function(request) {
fluidPage(
  tags$head(
    tags$link(rel="stylesheet", type="text/css", href="style.css"),
    includeScript("js/iframeSizer.contentWindow.min.js"),
    includeScript("js/tableau-2.2.2.min.js"), 
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
                            uiOutput('SelectorVarSubjetivos'),
                            uiOutput('textDesSbj'),
                       uiOutput('botDataSub')
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
              #uiOutput('VizSubj'),
              div(id = 'VizSubj',style='width: 100%; min-height:400px; height:auto'),
              div(class = 'botMapSub',
              uiOutput('anioSubj')
          )
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
                                              uiOutput('SelectorVarObjetivos'),
                                              uiOutput('textDesObj'),
                                              uiOutput('botDataObj')
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
                   #uiOutput('VizObjCif')
                      div(class="col-xs-12 col-md-9",  id = "VizObjCif", style="text-align: center;min-height:400px; height:auto")
                   
                   )
                   #verbatimTextOutput('salida')
                 )
             )
    ),
    tabPanel(value = 'cruces',
      HTML("<img src='img/menu/cruces.png' class = 'imgTab'> Cruces"),
     tabsetPanel(id = 'selCruces', type = 'tabs',
                 tabPanel(
                   'GENERAL',
                   uiOutput('ciudadPcom'),
                   div(class = 'row',
                       div(class = 'col-md-6 col-lg-6', style = 'text-align: -webkit-center;',
                           uiOutput('fselCruc'),
                 highchartOutput('grafCrucesD', height = 311),
                 uiOutput('grafCrucesDHidden', style = 'display:block'),
                 uiOutput('tabSelCom1')),
                 div(class = 'col-md-6 col-lg-6', style = 'text-align: -webkit-center;',
                   uiOutput('TselCruc'),
                   highchartOutput('grafCrucesDS', height = 311),
                   uiOutput('grafCrucesDSHidden', style = 'display:hidden'),
                   uiOutput('tabSelCom2'))
                 )),
                 tabPanel(
                   'TEMAS',
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
                           highchartOutput('grafSubC', height = 311)),
                       div(class = 'col-md-6 col-lg-6',
                           uiOutput('oficCruces'), style = 'margin-top: -23px; text-align: -webkit-center;',
                           highchartOutput('grafObjC', height = 311)))
                 )
                 )
      
              #)
             #verbatimTextOutput('tabla')
                 ),
    tabPanel(value = 'indices',
      HTML("<img src='img/menu/indice.png' class = 'imgTab'> Índices"),
         
      tabsetPanel(id = 'MenuIndices', type = 'tabs',
                
  tabPanel(
    'Índice de Progreso Social',
  
         div( class = 'row',
              div( class = 'col-md-3',
    div(class = 'contIPSMenu',
    uiOutput('radIps'),
    uiOutput('anioIPS'),
    uiOutput('texDespIPS'),
    uiOutput('botDataIps')
    
    )),
    div(class = 'col-md-9', style = 'margin-top: 6px;text-align: -webkit-center;',
        uiOutput('legMap'),
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
    'Objetivos de Desarrollo Sostenible',
    #div( class = 'container',
         div( class = 'row',
              div( class = 'col-md-3',
                   div(class = 'contIPSMenu',
                       div(class="contOSDMenu", id="styleScrollODS",
                uiOutput('botonesODS')),
                uiOutput('textDesODS'),
                uiOutput('botDataOds'))
                
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
    'Índice de ciudades universitarias',
    div( class = 'row',
         div( class = 'col-md-3',
              div(class="tab-content", id = "cajaDivCU",  
    uiOutput('selCiudUn'),
    uiOutput('texDesCU'),
    uiOutput('botDataIcu'))),
    
    div( class = 'col-md-9', style="text-align: center;",
         uiOutput('grafIcu'),
    div(class = 'grafICU',
    uiOutput('vizElgICU', width = 750)
    ))
  )),
  tabPanel(
    'Educación Técnica y Tecnológica',
    div( class = 'row',
         div( class = 'col-md-3',
              div(class="tab-content", id = "cajaDivCU", 
    uiOutput('selindeot'),
    uiOutput('textEOTdes'),
    uiOutput('botDataEot'))),
    div( class = 'col-md-9',
    div(class = 'grafICU',
    highchartOutput('vizlinEot', width = 750))))#,
    
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

