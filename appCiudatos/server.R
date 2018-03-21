#options(shiny.trace = TRUE)

shinyServer(function(input, output, session) {
  
 
# Subjetivos --------------------------------------------------------------

 output$botonesSubjetivos <- renderUI({

     BotonesGenerales(dicSbj, cscl = "buttonStyle")

 })
  
 output$SelectorVarSubjetivos <- renderUI({
   selectorVar(dicSbj, input$last_btn, 'VariablesSubjetivos')
 })
  
  
 output$anioSubj <- renderUI({
  # selectorAnio(subjDat, input$VariablesSubjetivos, 'anioSubjSel')
   data <- subjDat
   variable <-  input$VariablesSubjetivos
   df <- data %>% 
     select_('AÑO', variable) %>% 
     collect() %>% 
     drop_na_(variable) 
   anios <- sort(as.numeric(unique(df$AÑO)))
   #sliderInput(id_selector, 'Tiempo', min = min(anios), max = max(anios), value = anios[length(anios)] )
   selectizeInput(inputId = 'anioSubjSel', label = 'Tiempo', choices = anios, selected = max(anios))
 })

 

 
 output$grafSubj <- renderUI({
   print(shiny:::hasCurrentRestoreContext())
   BotonesGraficas(c('barras', 'mapa'))
 })  
 
 output$salida <- renderUI({
   input$lastGraph
 }) 
 
  output$vizStack <- renderHighchart({
  
  if(is.null(input$VariablesSubjetivos)) return()
  
  idElg <- input$VariablesSubjetivos
  data <- BaseGeneral(idElg, subjDat, input$anioSubjSel)
  stackGraph(data, dicSbj$label[dicSbj$id == idElg])
  })
  

  
  output$vizMap <- renderLeaflet({
    dataS <- BaseGeneral(input$VariablesSubjetivos, subjDat, input$anioSubjSel)
    nl <- length(unique(dataS$c))
    mapaSubj(dataS, paleta[1:nl])
  })
  
  
  output$VizSubj <- renderUI({
    idG <- if (is.null(input$lastGraph)){
     'barras'
    } else {
      input$lastGraph
    }
    
 
    if (idG == 'mapa') 
      g <- leafletOutput('vizMap')
    if (idG == 'barras') 
      g <- highchartOutput('vizStack')
      
    g
  })
  
  output$CiudSubj <- renderUI({
     variables <- subjDat %>% select(CIUDAD) %>% collect() %>% .$CIUDAD
     variables <- unique(variables)
     selectizeInput('ciudadSubj', 
                   'Selección de ciudad',
                    variables)
  })
  
  output$BotCiudadSubj <- renderUI({
    id_c <- input$ciudadSubj
    dic <- dicCiudad(id_c, subjDat, dicSbj)
    BotonesGenerales(dic, cscl = 'buttonStyleCity')
  })
  
  output$varCiudadSubj <- renderUI({
    id_c <- input$ciudadSubj
    dicS <- dicCiudad(id_c, subjDat, dicSbj)
    selectorVar(dicS, input$last_btnCity, 'varCiudadSubjSel')
  })
  
  output$grafSubjCiud <- renderUI({
    BotonesGraficas(c('linea', 'barras', 'treemap'), 'buttonStyleGraphCity')
  })
  

  
  baseCiud <- reactive({
    BaseGeneralCiudad(idElg = input$varCiudadSubjSel, subjDat) %>% 
      filter(a == input$ciudadSubj) %>% mutate(percentage = e*100)
  })

  output$salida <- renderPrint({
    baseCiud()
  })
  
  output$vizLine <- renderHighchart({
    idElg<- input$varCiudadSubjSel
    vizLineCiudad(baseCiud(),  dicSbj$label[dicSbj$id == idElg])
  })
  
  output$vizStackCiudad<- renderHighchart({
    idElg<- input$varCiudadSubjSel
    vizStackCiudad(baseCiud(),  dicSbj$label[dicSbj$id == idElg])
  })
  
  output$anioCiudad <- renderUI({
    dataC <-  baseCiud()

    df <-  dataC %>%
            select(b) %>%
             drop_na()
    anios <- as.numeric(unique(df$b))

    #sliderInput('anoSelctCiudad', 'Tiempo', min = min(anios), max = max(anios), value = anios[length(anios)] )
    selectInput('anoSelctCiudad', 'Tiempo', anios, selected = max(anios))
  })
  

  
  output$CityTree <- renderHighchart({
    idElg <- input$varCiudadSubjSel
    data <- baseCiud() %>% filter(b == input$anoSelctCiudad)
    vizTreeCiudad(data, dicSbj$label[dicSbj$id == idElg], minColor = '#cb4c55', maxColor = '#26327e')
  })
  

  output$VizSubjCity <- renderUI({
    idG <- if (is.null(input$lastGraphCity)){
      'linea'
    } else {
      input$lastGraphCity
    }
    
    if (idG == 'treemap') 
      g <- list(
        highchartOutput('CityTree'),
        uiOutput('anioCiudad')
      )
    if (idG == 'linea') 
      g <- highchartOutput('vizLine')
    if (idG == 'barras') 
      g <- highchartOutput('vizStackCiudad')
    
    g
  })
  
  

# Objetivos ---------------------------------------------------------------

  output$botonesObjetivos <- renderUI({

    BotonesGenerales(dicObj, cscl = 'buttonObj')
  })
  
  output$SelectorVarObjetivos <- renderUI({
    
    idobj <- input$last_Obj
    if (is.null(idobj)) idobj<- 'pobreza_y_equidad'
    
    selectorVar(dicObj, idobj, 'VariablesObjtivos')
  })
  

  baseObje <- reactive({
    BaseGeneralObj(input$VariablesObjtivos, objDat) %>% left_join(codigos)
  })
  

  
  output$vizLineObjetive <- renderHighchart({
    vizLineObje(baseObje(), dicObj$label[dicObj$id == input$VariablesObjtivos])
  })
  
  output$vizTreeObjetive <- renderHighchart({
    df <- baseObje() %>% filter(b == input$anioObjSel)
   vizTreeObje(df, dicObj$label[dicObj$id == input$VariablesObjtivos], minColor = '#cb4c55', maxColor = '#26327e')
  })
  
  output$vizMapObj <- renderLeaflet({
    df <- baseObje() %>% filter(b == input$anioObjSel)
    
    vizMapObj(df, dicObj$label[dicObj$id == input$VariablesObjtivos])
  })
  
  output$vizRankObj <- renderHighchart({
    df <- baseObje() %>% filter(b == input$anioObjSel)
    #df <- df %>% select(a, c, formato)
    #hgch_bar_OcaNum(df, verLabel = dicObj$label[dicObj$id == input$VariablesObjtivos], horLabel = 'Ciudad', orientation = 'hor', sort = 'desc', theme = cid_theme, dropNa = TRUE) 
    vizBarObje(df, verlabel = dicObj$label[dicObj$id == input$VariablesObjtivos])
  })
  
  output$grafObj <- renderUI({
    BotonesGraficas(c('linea', 'treemap', 'barras', 'mapa'), 'buttonStyleGraphObj')
  })
  
  
  output$anioObj <- renderUI({
    
    gr <- input$lastGraphObj
    
    if(is.null(gr)) gr <- 'linea'
    
    if(gr == 'linea') return()  
      
    selectorAnio(objDat, input$VariablesObjtivos, 'anioObjSel')
  })
  
  
  output$VizObj <- renderUI({
    
    idG <- if (is.null(input$lastGraphObj)){
             'linea'} else {
              input$lastGraphObj
              }         
    
    if (idG == 'treemap') 
      g <- highchartOutput('vizTreeObjetive')
    if (idG == 'linea') 
      g <- highchartOutput('vizLineObjetive')
    if (idG == 'barras') 
      g <- highchartOutput('vizRankObj')
    if (idG == 'mapa') 
      g <- leafletOutput('vizMapObj')
    
    g
  })
  
  

# FALTA CIUDADES OBJETIVOS ------------------------------------------------

  output$grafObjCiudades <- renderUI({
    BotonesGraficas(c('linea', 'barras'), 'buttonStyleGraphObjCiud')
  })
  

  output$CiudObj <- renderUI({
    variables <- objDat %>% select(CIUDAD) %>% collect() %>% .$CIUDAD
    variables <- unique(variables)
    selectizeInput('ciudadObjD', 
                   'Selección de ciudad',
                   variables )
  })
  
  output$BotCiudadObj <- renderUI({
    id_c <- input$ciudadObjD
    dic <- dicCiudad(id_c, objDat, dicObj)
    BotonesGenerales(dic, 'buttonObjCty')
  })
    
  output$varCiudadObj <- renderUI({
    
    temaElg <- input$last_ObjCty
    
    if(is.null(temaElg)) temaElg <- 'pobreza_y_equidad'
     
    ciuElg <- input$ciudadObjD
    d <- objDat %>% filter(Ciudad == ciuElg) %>% collect()
    d <- Filter(function(x) !all(is.na(x)), d)
    dic <- dicObj 
    dic$id_tema <- iconv(gsub(' ', '_', tolower(dic$Tema)), to="ASCII//TRANSLIT")
    dic$Tema_Mod <- stringi::stri_trans_totitle(tolower(dic$Tema))
    dic <- dic %>% filter(id_tema == temaElg)
    varInfo <- data.frame(id = names(d))
    varInfo <- varInfo %>% inner_join(dic)
    
    variables <-  as.list(setNames(varInfo$id, varInfo$label))
    elg <- sample(variables, 2)

    selectizeInput('varObjCiudadE', 'Selección de variables', 
                   choices = variables, multiple = TRUE,
                   selected = elg,
                   options = list(maxItems = 2,
                                  plugins= list('remove_button', 'drag_drop')))
                   
  })
  #

  
  
  baseObjeCiudad <- reactive({
    
    temaElg <- input$last_ObjCty
    if(is.null(temaElg)) temaElg <- 'pobreza_y_equidad'
    
    ciudElg <- input$ciudadObjD
    varSelc <- input$varObjCiudadE
    
    d <- tbl(db, sql("SELECT * FROM objetivos_comparada_data")) %>% 
      filter(Ciudad == ciudElg) %>% collect()
    
    d <- d[,c('Año', varSelc)]
options(scipen = 9999)
    format <- dicObj %>% filter(id %in% varSelc) %>% select(id, label, ctype)
    d <- d %>% gather(id, valor, -Año) %>% left_join(format) %>% drop_na(valor)
    d$est <- ifelse(d$ctype == 'Pct', d$valor*100, d$valor)
    d$format <- ifelse(d$ctype == 'Pct', paste0(round(d$est,1), '%'), d$valor)
    d
  })
  
output$baks <- renderPrint({
  baseObjeCiudad()
})
  
  output$grafCiudadObj <- renderHighchart({
    db <- baseObjeCiudad()
    hchart(db, type = "line", hcaes(x = Año, y = est, group = label)) %>% 
      hc_plotOptions(series = list(marker = list(enabled = TRUE, 
                                                 symbol = "circle"))) %>% 
      hc_tooltip(headerFormat = "", 
                 pointFormat = "<b></b>{point.label}<br/><b>
                                 Corte {point.Año}</b>: {point.format}")%>% 
      hc_xAxis(title = list(text = '')) %>% 
      hc_yAxis(title = list(text = '')) %>% 
      hc_add_theme(custom_theme(custom = cid_theme)) %>%   hc_exporting(enabled = TRUE)
    })
  
  
  output$barCiudadObj <- renderHighchart({
    db <- baseObjeCiudad()
    db <- db %>% select(Año, label, valor) %>% spread(label, valor)
    f <- fringe(db)
    nms <- getClabels(f)
    d <- f$d
    d <- d %>% drop_na()
    horLabel <- nms[2]
    verLabel <- nms[3]
    hchart(d, type = "bubble", hcaes(x = b, y = c, group = a))  %>% 
      hc_tooltip(headerFormat = "", 
                pointFormat = paste0("<b> Corte: {point.a}<br/><b>", 
                horLabel, "</b>: {point.b}<br/><b>", verLabel, "</b>: {point.c}")) %>% 
       hc_xAxis(title = list(text = horLabel)) %>% 
       hc_yAxis(title = list(text = verLabel)) %>% 
       hc_add_theme(custom_theme(custom = cid_theme)) %>%   hc_exporting(enabled = TRUE)
   })
  
  
  output$VizObjCif <- renderUI({
    
    idG <- if (is.null(input$lastGraphObjC)){
      'linea'} else {
        input$lastGraphObjC
      }         
    
    # if (idG == 'treemap') 
    #   g <- highchartOutput('vizTreeObjetive')
    if (idG == 'linea') 
      g <- highchartOutput('grafCiudadObj')
    if (idG == 'barras') 
      g <- highchartOutput('barCiudadObj')
    
    g
  })
  
  
# CRUCES OBJ Vs SUBJ ------------------------------------------------------

  
  #Ciudad para el cruce
  
  output$CiudadCruce <- renderUI({
    
    ciudadesSub <- subjDat %>% select(CIUDAD) %>% collect() %>% .$CIUDAD
    ciudadesObj <- objDat %>% select(CIUDAD) %>% collect() %>% .$CIUDAD
    ciudadC <- intersect(unique(ciudadesSub) , unique(ciudadesObj))
    selectInput('cidCruc', 'Seleccione Ciudad', ciudadC)
  })
  
  baseBot <- reactive({
    ciudad <- input$cidCruc
    baseC <- subjDat %>% filter(CIUDAD == input$cidCruc) %>% collect()
    baseC <- Filter(function(x) !all(is.na(x)), baseC)
    names(baseC)
  })
  
  baseObB <- reactive({
    ciudad <- input$cidCruc
    baseC <- objDat %>% filter(CIUDAD == input$cidCruc) %>% collect()
    baseC <- Filter(function(x) !all(is.na(x)), baseC)
    names(baseC)
  })
  
 output$botonesCruces <- renderUI({
   
   CrucesSbj <- dicSbj %>% drop_na(Tema)
   CrucesSbj$temasCruces <-CrucesSbj$Tema
   CrucesSbj <- CrucesSbj %>% filter(id %in% baseBot())
   CrucesObj <- dicObj %>% drop_na(Tema)
   CrucesObj$temasCruces <- CrucesObj$Tema
   CrucesObj <- CrucesObj %>% filter(id %in% baseObB())
   
   dic <- CrucesObj
   dic$id_tema <- iconv(gsub(' ', '_', tolower(dic$temasCruces)), to="ASCII//TRANSLIT")
   dic$Tema_Mod <- stringi::stri_trans_totitle(tolower(dic$temasCruces))
   
   temas <- iconv(gsub(' ', '_', tolower(intersect(CrucesObj$temasCruces, CrucesSbj$temasCruces))), to="ASCII//TRANSLIT")
   
   map(temas, function(z){
     HTML( paste0(
       tags$button(id = z, class = "buttonStyleCruces", type = "button",
                   tags$img(src = paste0('img/temas/',z, '.png') , class =  'cosa'), #paste0('img/',z, '.png')
                   dic$Tema_Mod[dic$id_tema == z][1]
       ),
       
      "
       <script type='text/javascript'>
         document.querySelector('.buttonStyleCruces').classList.add('pressed');
         document.querySelector('.cosa').classList.add('inverse');
     	</script>
     "
     )
     )
     
     
   })
 })
  
  

  #Menú percepción
  
 CruceSbj <- reactive({
    CrucesSbj <- dicSbj %>% drop_na(Tema)
    CrucesSbj$temasCruces <- CrucesSbj$Tema
    CrucesSbj$id_tema <- iconv(gsub(' ', '_', tolower(CrucesSbj$temasCruces)), to="ASCII//TRANSLIT")
   
    idB <- input$last_cruce
    if(is.null(idB)) idB <- 'pobreza_y_equidad'
    
    seT <- CrucesSbj %>% filter(id_tema == idB)
    d <- data.frame(id = baseBot()) %>% inner_join(seT)
    as.list(setNames(d$id, d$label))
   # bs <- subjDat %>% filter(CIUDAD == input$cidCruc) %>% collect()
    #bs[, c('AÑO',intersect(baseBot(), seT$id))]

  })
  
 CruceObj <- reactive({
   
   CrucesObj <- dicObj %>% drop_na(Tema)
   CrucesObj$temasCruces <- CrucesObj$Tema
   CrucesObj$id_tema <- iconv(gsub(' ', '_', tolower(CrucesObj$temasCruces)), to="ASCII//TRANSLIT")
   
   idB <- input$last_cruce
   if(is.null(idB)) idB <- 'pobreza_y_equidad'
   
   seT <- CrucesObj %>% filter(id_tema == idB)
   d <- data.frame(id = baseObB()) %>% inner_join(seT)
   as.list(setNames(d$id, d$label))
 
 })
  
  
  
  output$percCruces <- renderUI({
   # div(class = 'crucesPerc',
    selectInput('varPerC', 'Datos de percepción', CruceSbj())
    #)
  })
  
  output$oficCruces <- renderUI({
    #div(class = 'crucesObj',
    selectInput('varOfiC', 'Datos objetivos', CruceObj())
    #)
  })
  
  
  dataSubCruces <- reactive({
    bs <- subjDat %>% 
            filter(CIUDAD == input$cidCruc) %>% 
              select_('AÑO', input$varPerC) %>% collect()
    
    bs <- bs %>% 
           group_by_('AÑO', input$varPerC) %>% drop_na() %>% 
            summarise(total = n()) %>%
             mutate(Porcentaje = (total/sum(total))*100) %>% 
              select(c=input$varPerC, 'AÑO', Porcentaje)
    bs <- bs %>% left_join(dic_ind)
    bs$index[is.na(bs$index)] <- 'z'
    bs$leg <- paste0(bs$index, bs$c)
    bs <- bs %>% select(leg, 'AÑO', Porcentaje)
    names(bs) <- c(dicSbj$label[dicSbj$id == input$varPerC], 'AÑO', 'Porcentaje')
    bs
  })
  
  
  output$grafSubC <- renderHighchart({

    anioL <- unique(dataSubCruces()$AÑO)
    
    if (length(anioL) > 1) {
      h <- linesubjCru(dataSubCruces())}#hgch_line_CatYeaNum(dataSubCruces(), dropNa = TRUE, theme = cid_theme, percentage = TRUE)}
    if (length(anioL) == 1) {
      d <- dataSubCruces()[,-2]
      h <- barsubjCru(d)
    }
    h

  })
  
  
  dataObjCruces <- reactive({
    idElg <- input$varOfiC
    
    bs <- objDat %>% 
      filter(CIUDAD == input$cidCruc) %>% 
      select_('AÑO', input$varOfiC) %>% collect()
    
    format <- dicObj$ctype[dicObj$id == idElg] 
    
    bs <- changeNames(bs)
    
    if (format == 'Pct') {
      bs$formato <- paste0((bs$b)*100, '%')
      bs$est <- bs$b * 100} else {
        bs$formato <- bs$b    
        bs$est <- bs$b 
      }
    bs %>% drop_na()
    })
  

  output$grafObjC <- renderHighchart({
  
    h <- crucLineObje(dataObjCruces(), dicObj$label[dicObj$id == input$varOfiC] )
    h
    
  })
  
  
  
  #indice ODS
  
  baseODS <- reactive({
    odsDat <-  tbl(db, sql("SELECT * FROM ods_full_data")) %>% collect()
    odsDat$Indicadores <- trimws(gsub('[0-9]\\.[0-9]*|\\.', '',odsDat$Indicadores))
    odsDat$Objetivos <- tolower(odsDat$Objetivos)
    odsDat <- odsDat %>% drop_na(Valor)
    odsDat
  })
  
  output$botonesODS <- renderUI({

 temas <- as.character(unique(baseODS()$Objetivos))
    map(temas, function(z){
        tags$button(id = z, class = "buttonStyleODS", type = "button",
                    tags$img(src = paste0('img/ods/',z, '.jpg') , class =  'imgODS')
        )
    })
  })
  
  output$selods <- renderUI({
    
    idOds <- input$last_ods
    if (is.null(idOds)) idOds <- 'objetivo1'
    df <-  baseODS()
    df <- df %>% filter(Objetivos == idOds)
    div( class = 'odsIn',
   selectInput('odsIndicador', 'Indicador', unique(df$Indicadores))
    )
  })
  
  output$textOds <- renderUI({
    info <- tbl(db, sql("SELECT * FROM ods_objetivos_data")) %>% collect()
    info$Número <- paste0('objetivo', info$Número)
    idOds <- input$last_ods
    if (is.null(idOds)) idOds <- 'objetivo1'
    tex <- info %>% filter(Número == idOds)
    HTML(paste0(tex$Título, ': ', tex$Descripción))
  })
  
  output$vizOds <- renderHighchart({
    df <- baseODS() %>% 
           filter(Indicadores == input$odsIndicador) 
    captT <- unique(df$Fuente)
    hoLab <- unique(df$Indicadores)
    df <- df %>% select(Ciudad, Valor)
    bubbles(df, hoLab, captT)
  })
  
  datCu <- reactive({
   
    CUDat <-  tbl(db, sql("SELECT * FROM ciudades_universitarias_data")) %>% collect()
    CUDat
  })
  
  dicCu <- reactive({
    CUDic <-  tbl(db, sql("SELECT * FROM ciudades_universitarias_dic_")) %>% collect()
  })
  
  output$selCiudUn <- renderUI({
    
    SelInd <- dicCu()[c(-1,-2, -3),]
    
    acd <- SelInd  %>% 
      dplyr::group_by(Categoria) %>% nest()
    
    lista_dim <- purrr::map(seq_along(acd$data), function(i) setNames(acd$data[[i]]$id, acd$data[[i]]$label))
    names(lista_dim) <- acd$Categoria
    
    div(class = 'centInd',
    selectizeInput('indCCU', 'Indicador', lista_dim)
    )
  })
  
  
  output$vizCU <- renderHighchart({
    CUDat <- datCu() %>% select(ciudad, ano, input$indCCU)
    CUDat <- changeNames(CUDat)
    CUDat$c <- round(CUDat$c, 2)
    CUDat <- CUDat %>% plyr::rename(c('a' = 'Ciudad'))
    hgch_line_CatYeaNum(CUDat, theme = cid_theme, verLabel = dicCu()$label[dicCu()$id ==input$indCCU], horLabel = 'Año')
  })
  
  
  #indice EOT
  
  dicEOT <- reactive({
    EotDic <-  tbl(db, sql("SELECT * FROM eot_dic_")) %>% collect()
    EotDic
  })
 
  output$selindeot <- renderUI({
    
    SelInd <- dicEOT()[c(-1,-2),]
    lista_dim <-  as.list(setNames(SelInd$id, SelInd$label))
    div(class = 'centInd',
    selectInput('indEOT', 'Indicador', lista_dim))
  })
  
  
  baseEOT <- reactive({
    idElg <- input$indEOT
    EotDat <-  tbl(db, sql("SELECT * FROM eot_data")) %>% collect()
    EotDat <- EotDat  %>% 
                select_('Ciudad', 'Ano', idElg) %>%
                  collect() %>% 
                     drop_na() 
    format <- dicEOT()$ctype[dicEOT()$id == idElg] 
    EotDat <- changeNames(EotDat)
    
    if (format == 'Pct') {
      EotDat$formato <- paste0(round(EotDat$c, 2)*100, '%')
      EotDat$est <- EotDat$c * 100} else {
        EotDat$formato <- EotDat$c    
        EotDat$est <- EotDat$c 
      }
    EotDat
  })
  
  output$asdas <- renderPrint({
    baseEOT()
  })
  
  output$vizlinEot <- renderHighchart({
  vizLineEOT(baseEOT(), dicEOT()$label[dicEOT()$id == input$indEOT] )
  })
  
  

# IPS ---------------------------------------------------------------------

  # output$butMenuIps <- renderUI({
  #   map(c('Departamentos', 'Ciudades', 'Bogotá'), function(z){
  #       tags$button(id = z, class = "bttIPS", type = "button",
  #                   z
  #       )
  #   })
  #  })
  
  output$radIps <- renderUI({
    
    radioButtons('claseIPS', '', c('Departamentos', 'Ciudades', 'Bogotá'))
    
  })
  
  output$anioIPS <- renderUI({
    if (input$claseIPS != 'Departamentos')
    selectInput('anioSelIps', 'Año', 2009:2016)
  })
  
  
  output$legMap <- renderUI({
    tags$img(src = 'img/ips/IPS.png', class = 'imgLeg')
  })
  
  dataIPS <- reactive({
    
    if (input$claseIPS == 'Departamentos') {
      dt <-  tbl(db, sql("SELECT * FROM ips_departamentos_variables_data")) %>% collect()
      dt$IPS <- 1
      codigo <- read_csv('data/mapa/codigosIPS.csv')
      dt <- dt %>%  left_join(codigo)
      dt <- dt %>% select(code, name = Departamento, value = IPS, everything())
    }
    if (input$claseIPS == 'Ciudades') {
      dt <-  tbl(db, sql("SELECT * FROM ips_interciudades_resultados_data")) %>% filter(Anio == input$anioSelIps) %>% collect()
      dt$color <- ifelse(dt$IPS <= 45.5, '#ba7d1b',
                    ifelse(dt$IPS > 45.5 & dt$IPS <= 57.5, '#d6b277',
                      ifelse(dt$IPS > 57.5 & dt$IPS <= 66.5, '#2e4c53',
                        ifelse(dt$IPS > 66.5 & dt$IPS <= 75.5, '#829499',
                          ifelse(dt$IPS > 75.5 & dt$IPS <= 87.5, '#b2cebe', '#2c6444')))))
      codigos <- read_csv('data/mapa/codigos.csv')
      codigos <- codigos %>% select(Ciudad = CIUDAD, everything())
      dt <- dt %>% 
             left_join(codigos) %>% 
               select(name = Ciudad, z = IPS, lat = lat , lon = lng, color, everything()) %>% 
                drop_na()
    }
    if (input$claseIPS == 'Bogotá') {
      dt <-  tbl(db, sql("SELECT * FROM intraurbano_localidades_data")) %>% filter(Año == input$anioSelIps) %>% collect()
      dt <-  dt %>% select(localidad = Localidad, everything()) 
    }
    
    dt 
  }) 
  
  output$mapDepto <- renderHighchart({
    
    myClickFunc <- JS("function(event) {Shiny.onInputChange('hcClicked',  {id:event.point.name, timestamp: new Date().getTime()});}")
    
    hm <- hcmap("countries/co/co-all",
                data = dataIPS(), 
                value = "value",
                joinBy = list('hc-a2', 'code'),
                showInLegend = FALSE, nullColor = "white",
                borderWidth = 1,
                allowPointSelect = TRUE,
                cursor = 'pointer',
                dataLabels = list(
                  enabled = FALSE,
                  fontFamily= 'Karla',
                  format = '{point.name}'),
                showInLegend = FALSE,
                events = list(click = myClickFunc)
    ) %>% 
      hc_colorAxis(
        dataClasses= list(list(
          from= 1,
          color= '#c5c4c5'
        ))) %>% 
      hc_legend(enabled = FALSE) %>% 
      hc_tooltip(
        headerFormat = '',
        pointFormat = '<b>{point.name}</b>'
      )
    hm
  })
  
 output$fichaDepto <- renderUI({
  
   dp <- input$hcClicked$id
   dp <- iconv(dp, to="ASCII//TRANSLIT")
     
   data <- tbl(db, sql("SELECT * FROM ips_departamentos_variables_data")) %>% collect()
   data$Departamento <-  iconv(data$Departamento, to="ASCII//TRANSLIT")
   dic <- tbl(db, sql("SELECT * FROM ips_departamentos_variables_dic_")) %>% collect() %>% 
     drop_na(Dimensión, Componente)
   
   data <- data %>% filter(Departamento == dp)
   data <- Filter(function(z) !all(is.na(z)), data)
   dimST <- unique(dic$Dimensión) 

   data <- data %>% gather(id, valor)
   df <- dic %>% left_join(data, by = 'id')
   
   df$formato <- ifelse(df$ctype == 'Pct', paste0(as.numeric((df$valor))*100, '%'), df$valor)
   
   
   l <- map_chr(dimST, function(z) {
     d0 <- df %>%
       filter(Dimensión %in% z)
     comSt <- unique(d0$Componente)
     p0 <- map_chr(comSt, function(y) {
       d1 <- d0 %>%
         filter(Componente %in% y)
       p1 <- paste0('<table style="line-height: 0.01;">
                     <tr><td class = "colTabDesc">',
                    d1$label, '</td> <td class = "colTabValr">', d1$formato,'</td></tr></table>', collapse = '</br>')
       p1 <- paste0('<span style="color:#4e5055; font-size: 1.6rem; font-weight: 700;line-height: 2.5;">', y, '</span>', '<br/>', p1)
       p1
     })
     p2 <- paste(p0,  collapse = '<br/>')
     p2 <- paste(
       '<span style="font-size: 23px; font-weight: 500;">', z, '</span>' ,
       '<br/>', p2)
     p2
   })
   
   l0 <- HTML(paste(l, collapse = '<br/>'))
   l0
 })
  
  observeEvent(input$hcClicked$id, {
    id = input$hcClicked$id
    showModal(modalDialog(
      title = id,
      footer = modalButton("Cerrar"), 
      easyClose = TRUE,
      uiOutput('fichaDepto')
    ))
  })

  
   
  output$mapCiudad <- renderHighchart({
    
    myClickFunc <- JS("function(event) {Shiny.onInputChange('ClickedCiudad', {id:event.point.name, timestamp: new Date().getTime()});}")
    
    hcmap('countries/co/co-all')%>% 
      hc_legend(enabled = FALSE) %>% 
      hc_add_series(
        data = dataIPS(),
        type = "mapbubble",
        allowPointSelect = TRUE,
        cursor = 'pointer',
        borderWidth = 1,
        cursor = 'pointer', minSize = '3%',
        maxSize = 30, events = list(click = myClickFunc),
        tooltip= list(
          headerFormat= '',
          pointFormat='<b>{point.name}</b>'
        )
      ) 
  })
  
  dataCiudadesIPS <- reactive({
    d <- tbl(db, sql("SELECT * FROM ips_interciudades_resultados_data")) %>% collect()
    ciuElg <- input$ClickedCiudad$id
    d <- d %>% filter(Ciudad == ciuElg)
    d <- Filter(function(w) !all(is.na(w)), d)
    d
  })
  
  
  output$dimGrafIPS <- renderHighchart({
    dtres <-  dataCiudadesIPS()
    dicres  <-  tbl(db, sql("SELECT * FROM ips_interciudades_resultados_dic_")) %>% collect()
    
    datGra <- dtres %>%
      filter(Anio == input$anioSelIps) %>%
      select(NHB, FB, Op) %>%
      gather(id, valor) %>% inner_join(dicres)
    datGra$ciudad <- 'bla'
    datGra <- datGra %>% select(ciudad, label, valor)
    datGra$Anio <- input$anioSelIps
    datGra$label <- trimws(gsub('Dimensión de|Dimensión', '', datGra$label))
    datGra$colorn <- ifelse(datGra$valor <= 45.5, '#ba7d1b',
                            ifelse(datGra$valor > 45.5 & datGra$valor <= 57.5, '#d6b277',
                                   ifelse(datGra$valor > 57.5 & datGra$valor <= 66.5, '#2e4c53',
                                          ifelse(datGra$valor > 66.5 & datGra$valor <= 75.5, '#829499',
                                                 ifelse(datGra$valor > 75.5 & datGra$valor <= 87.5, '#b2cebe', '#2c6444')))))
    datGra$labelM <- c('cNecesidades Básicas Humanas', 'bFundamentos del Bienestar', 'aOportunidades')
    stcIPS(datGra = datGra)
  })
  
  output$radioIPS <- renderUI({
    radioButtons('selObser', '', c('Individual', 'Comparación'), inline = TRUE)
  })
  
  output$ModaSelectIPS <- renderUI({
    dicS <- dicIPSciudad
    varInf <- data.frame(id = names(dataCiudadesIPS()))
    dicI <- dicS %>% inner_join(varInf)
    varsNu <- dicI %>% select(id, label, grupo)
    bla <- as.list(setNames(varsNu$id, varsNu$label))
    acd <- varsNu  %>% 
      dplyr::group_by(grupo) %>% nest()
    
    lista_dim <- purrr::map(seq_along(acd$data), function(i) setNames(acd$data[[i]]$id, acd$data[[i]]$label))
    names(lista_dim) <- acd$grupo
    
    if (input$selObser == 'Individual') 
      sl <- selectizeInput('varIndIPS', 'Selecciona Variable', lista_dim) 
    if (input$selObser == 'Comparación')
      sl <- selectizeInput("varIndIPSCom","Seleccione Variables",
                           choices = lista_dim,multiple = TRUE,
                           selected = sample(bla,2),
                           options = list(plugins= list('remove_button')))
    sl
  }) 
  
  ModaldatavizIPS <- reactive({
    
    if (input$selObser == 'Individual')
      idVar <- input$varIndIPS
    if (input$selObser == 'Comparación')
      idVar <- input$varIndIPSCom
    
    d <- dataCiudadesIPS() %>% select(-Ciudad) %>% gather(id, valor, -Anio)
    d <- d %>% filter(id %in% c('Anio', idVar))
    
    d <- d %>% inner_join(dicIPSciudad, by = 'id')
    d <- d %>% select(Anio, Variable = label, Valor = valor)
    d
  })
  


  output$ModalVizIPS <- renderHighchart({
    df <- ModaldatavizIPS()
    
    if (input$selObser == 'Individual') {
    h <- ModBarIps(df,input$anioSelIps)}
    if (input$selObser == 'Comparación') {
      dt <- df %>% select(Variable, Año = Anio, Valor)
    h <- hgch_line_CatYeaNum(dt, horLabel = 'Año', theme = cid_theme, verLabel = 'Total' )}
    
    h
  })
  
  output$fichaCiudad <- renderUI({ 

    htmlTemplate("templates/template.html",
                 graficoDim = highchartOutput('dimGrafIPS', height = 45),
                 radioBotones = uiOutput('radioIPS'),
                 graficoTodo =  highchartOutput('ModalVizIPS', width = 350, height = 350),
                 selecDesc = uiOutput('ModaSelectIPS')
    )
  })
  
  observeEvent(input$ClickedCiudad$id, {
    id = input$ClickedCiudad$id
    showModal(modalDialog(
      title = id,
      footer = modalButton("Cerrar"), 
      easyClose = TRUE,
     uiOutput('fichaCiudad')
    ))
  }) 
  
  output$mapLocalidad <- renderLeaflet({
    loc <- topojson_read("data/mapa/localidades-bog.topojson")
        
    loc@data  <- left_join(loc@data, dataIPS())
    bins <- c(0, 45.5, 57.5, 66.5, 75.5, 87.5, Inf)
    pal <- c('#ba7d1b', '#d6b277', '#2e4c53', '#829499', '#b2cebe', '#2c6444')
    pal <- colorBin(pal, domain = loc$IPS, na.color = '#BDAA81',  bins = bins)

    leaflet(data = loc) %>%
      addProviderTiles(providers$BasemapAT.basemap) %>%
      setView(lng = -74.09729, lat = 4.58, zoom = 10) %>% 
      addPolygons(
        weight = 2,
        opacity = 1,
        color = "white",
        fillOpacity = 0.7,
        fillColor = ~pal(loc$IPS),
        layerId = ~localidad,
        label = ~localidad,
          highlight = highlightOptions(
          color= '#666',
          opacity = 1,
          weight= 3,
          fillOpacity= 1,
          bringToFront = FALSE)
      )
    
  })
  
 
  
  
  output$vizIPS <- renderUI({
    if (input$claseIPS == 'Departamentos') {
      viz <- highchartOutput('mapDepto')
    }
    if (input$claseIPS == 'Ciudades') {
      viz <- highchartOutput('mapCiudad')
    }
    if (input$claseIPS == 'Bogotá') {
      viz <- leafletOutput('mapLocalidad')
    }
    viz
  })
  
  
  
  output$tablaIPS <- renderPrint({
    input$mapLocalidad_shape_click
  })
  
  
  dataLocalidadesIPS <- reactive({
    locElg <- input$mapLocalidad_shape_click$id
    dloc <-  tbl(db, sql("SELECT * FROM intraurbano_localidades_data")) %>% filter(Localidad %in% locElg) %>% collect()
    dBog <-  tbl(db, sql("SELECT * FROM intraurbano_bogota_data")) %>% collect()
    dBog$Localidad <-  'Total Bogotá'
    d <- bind_rows(dloc, dBog) %>% select(-Ciudad)
    d <- Filter(function(w) !all(is.na(w)), d)
    d
  })
  
  output$dimGrafIPSloc <- renderHighchart({
    dtres <-  dataLocalidadesIPS()
    dicres  <-  tbl(db, sql("SELECT * FROM intraurbano_localidades_dic_")) %>% collect()
    
    datGra <- dtres %>%
      filter(Año == input$anioSelIps, Localidad != 'Total Bogotá' ) %>%
       select(NHB, FB, Op) %>%
        gather(id, valor) %>% inner_join(dicres)
     datGra$ciudad <- 'bla'
     datGra <- datGra %>% select(ciudad, label, valor)
     datGra$Anio <- input$anioSelIps
    datGra$label <- trimws(gsub('Dimensión de|Dimensión', '', datGra$label))
    datGra$colorn <- ifelse(datGra$valor <= 45.5, '#ba7d1b',
                            ifelse(datGra$valor > 45.5 & datGra$valor <= 57.5, '#d6b277',
                                   ifelse(datGra$valor > 57.5 & datGra$valor <= 66.5, '#2e4c53',
                                          ifelse(datGra$valor > 66.5 & datGra$valor <= 75.5, '#829499',
                                                 ifelse(datGra$valor > 75.5 & datGra$valor <= 87.5, '#b2cebe', '#2c6444')))))
    datGra$labelM <- c('cNecesidades Básicas Humanas', 'bFundamentos del Bienestar', 'aOportunidades')
    stcIPS(datGra = datGra)
    #datGra
  })
  
  output$radioIPSloc <- renderUI({
    radioButtons('selObserloc', '', c('Individual', 'Comparación'), inline = TRUE)
  })
  
  output$ModaSelectIPSLoc <- renderPrint({
    dicS <- dicIPSciudad
    varInf <- data.frame(id = names(dataLocalidadesIPS() %>% filter(Localidad != 'Total Bogotá')))
    dicI <- dicS %>% inner_join(varInf)
    varsNu <- dicI %>% select(id, label, grupo)
    bla <- as.list(setNames(varsNu$id, varsNu$label))
    acd <- varsNu  %>% 
      dplyr::group_by(grupo) %>% nest()
    varsNu
    lista_dim <- purrr::map(seq_along(acd$data), function(i) setNames(acd$data[[i]]$id, acd$data[[i]]$label))
    names(lista_dim) <- acd$grupo

    if (input$selObserloc == 'Individual')
      sl <- selectizeInput('varIndIPSloc', 'Selecciona Variable', lista_dim)
    if (input$selObserloc == 'Comparación')
      sl <- selectizeInput("varIndIPSComloc","Seleccione Variables",
                           choices = lista_dim,multiple = TRUE,
                           selected = sample(bla,2),
                           options = list(plugins= list('remove_button')))
    sl
  }) 
  
  
  ModaldatavizIPSloc <- reactive({
    
    if (input$selObserloc == 'Individual')
      idVar <- input$varIndIPSloc
    if (input$selObserloc == 'Comparación')
      idVar <- input$varIndIPSComloc

    d <- dataLocalidadesIPS()[,c('Localidad', 'Año', idVar)]
    varNam <- data.frame(id = names(d))
    dicT <- varNam %>% left_join(dicIPSciudad, by = 'id')
    dicT$label <- coalesce(dicT$label, dicT$id) 
    # d <- d %>% select(Anio, Variable = label, Valor = valor)
    names(d) <- dicT$label
    d
  })
  
  output$bblabla <- renderPrint({
    ModaldatavizIPSloc()
  })
  
  # 
  output$ModalVizIPSloc <- renderHighchart({
    df <- ModaldatavizIPSloc()

    if (input$selObserloc == 'Individual') {
      h <- hgch_line_CatYeaNum(df,  theme = cid_theme, verLabel = names(df)[3])}
    if (input$selObserloc == 'Comparación') {
      dt <- df %>% select(-Localidad) %>%  gather(id, valor, -Año)
      dt <- dt %>% select(Variable = id, Año, Valor = valor)
      h <- hgch_line_CatYeaNum(dt, horLabel = 'Año', theme = cid_theme, verLabel = 'Total' )}

    h
  })
  # 
  output$fichaLocalidad <- renderUI({

    htmlTemplate("templates/template.html",
                 graficoDim = highchartOutput('dimGrafIPSloc', height = 45),
                 radioBotones = uiOutput('radioIPSloc'),
                 graficoTodo =  highchartOutput('ModalVizIPSloc', width = 350, height = 350),
                 selecDesc = uiOutput('ModaSelectIPSLoc')
    )
  })
  
  observeEvent(input$mapLocalidad_shape_click, {
    id = input$mapLocalidad_shape_click$id
    showModal(modalDialog(
      title = id,
      footer = modalButton("Cerrar"), 
      easyClose = TRUE,
      uiOutput('fichaLocalidad')
    ))
  })

  
  # observeEvent(input$menuSup == 'percepcion', {
  #   
  # setBookmarkExclude(c("theTabsObj", 'MenuIndices'))
  #   }
  # )
  
  
  observe({
    if (length(parseQueryString(session$clientData$url_search)) > 0) {
      print(length(parseQueryString(session$clientData$url_search)))
      # updateSelectInput(session, 'anioSubjSel', selected = parseQueryString(session$clientData$url_search)$anio)
      updateSelectizeInput(session = session, inputId = 'anioSubjSel', selected = 2013)
    }
  })
  
  
  
  

  
  # cdata <- session$clientData
  # 
  # # Values from cdata returned as text
  # output$clientdataText <- renderText({
  #   cnames <- names(cdata)
  #   allvalues <- lapply(cnames, function(name) {
  #     paste(name, cdata[[name]], sep = " = ")
  #   })
  #    paste(allvalues, collapse = "\n")
  # })
  # 
  # output$skd <- renderPrint({
  #   reactiveValuesToList(input)
  # })

  
  # akk <- reactive({
  #   query <- parseQueryString(session$clientData$url_search)
  #   
  #   for (i in 1:(length(reactiveValuesToList(input)))) {
  #     nameval = names(reactiveValuesToList(input)[i])
  #     valuetoupdate = query[[nameval]]
  #   }
  #   nameval
  # })
  # 
  # output$skd <- renderPrint({
  #   akk()
  # })

  
  # idLink <-  reactive({
  #   
  #   idSel <- input$menuSup
  # 
  #   if (input$menuSup == 'percepcion') {
  #     d <- paste0(idSel, input$theTabs) 
  #     if (input$theTabs == 'tabTema') {
  #       idG <- if (is.null(input$lastGraph)){
  #         'barras'
  #       } else {
  #         input$lastGraph
  #       }  
  #      h <- paste0(d, input$VariablesSubjetivos, input$anioSubjSel, idG) }
  #     if (input$theTabs == 'tabCiud') {
  #       idG <- if (is.null(input$lastGraphCity)){
  #         'linea'
  #       } else {
  #         input$lastGraphCity
  #       }
  #       h <- paste0(d, input$ciudadSubj, input$varCiudadSubjSel, idG)}
  #     }
  #   if (input$menuSup == 'oficiales') {
  #     d <- paste0(idSel, input$theTabsObj)      
  #     if (input$theTabsObj == 'tabTemaObj') {
  #       idG <- if (is.null(input$lastGraphObj)){
  #         'linea'} else {
  #           input$lastGraphObj
  #         }   
  #       h <- paste0(d, input$VariablesObjtivos, idG) }
  #     if (input$theTabsObj == 'tabCiudObj') {
  #       idG <- if (is.null(input$lastGraphObjC)){
  #         'linea'} else {
  #           input$lastGraphObjC
  #         }
  #       varf <- paste(input$varObjCiudadE, collapse = "_")
  #       h <- paste0(d, input$ciudadObjD, varf, idG)
  #       }
  #   }
  #   if (input$menuSup == 'cruces') {
  #     h <- paste0(idSel, input$cidCruc, paste(c(input$varPerC, input$varOfiC), collapse = 'Vs'))}
  #   if (input$menuSup == 'indices') {
  #     d <- paste0(idSel, input$MenuIndices)
  #     if (input$MenuIndices == 'IPS') {
  #      if (input$claseIPS == 'Departamentos') {
  #        h <- paste0(d, 'depto', input$hcClicked$id) }
  #      if (input$claseIPS == 'Ciudades') {
  #        h <- paste0(d, 'ciudad', input$ClickedCiudad$id) }
  #      if (input$claseIPS == 'Bogotá') {
  #        h <- paste0(d, 'bogota', input$mapLocalidad_shape_click$id)
  #      }}
  #     if (input$MenuIndices == 'ODS') {
  #      h <- paste0(d, input$odsIndicador) 
  #     }
  #     if (input$MenuIndices == 'ICU') {
  #      h <- paste0(d, input$indCCU) 
  #     }
  #     if (input$MenuIndices == 'EOT') {
  #      h <- paste0(d, input$indEOT) 
  #     }}
  #   
  #   iconv(h, to="ASCII//TRANSLIT")
  #   
  # })
  # 
  # 
  # output$link <- renderUI({
  # 
  #   if (input$menuSup == 'percepcion') {
  #     if (input$theTabs == 'tabTema') {
  #       idG <- ifelse(is.null(input$lastGraph), 'barras',  input$lastGraph)
  #       idbut <- ifelse(is.null(input$last_btn),'bienestar_subjetivo', input$last_btn)
  #       h <- sprintf("?menuSup=%s&theTabs=%s&VariablesSubjetivos=%s&anioSubjSel=%s&last_btn=%s&lastGraph=%s", input$menuSup, input$theTabs, input$VariablesSubjetivos, input$anioSubjSel, idbut, idG) }
  #     if (input$theTabs == 'tabCiud') {
  #       idG <- if (is.null(input$lastGraphCity)){
  #         'linea'
  #       } else {
  #         input$lastGraphCity
  #       }
  # 
  #       h <- sprintf("?men=%s&typ=%s&city=%s&var=%s&graf=%s", input$menuSup, input$theTabs, input$ciudadSubj, input$varCiudadSubjSel, idG)}
  #   }
  #   if (input$menuSup == 'oficiales') {
  #     if (input$theTabsObj == 'tabTemaObj') {
  #       idG <- if (is.null(input$lastGraphObj)){
  #         'linea'} else {
  #           input$lastGraphObj
  #         }
  #       h <-  sprintf("?men=%s&typ=%s&var=%s&graf=%s", input$menuSup, input$theTabsObj, input$VariablesObjtivos, idG) }
  #     if (input$theTabsObj == 'tabCiudObj') {
  #       idG <- if (is.null(input$lastGraphObjC)){
  #         'linea'} else {
  #           input$lastGraphObjC
  #         }
  #       varf <- paste(input$varObjCiudadE, collapse = "_")
  #       h <- sprintf("?men=%s&typ=%s&city=%s&comp=%s&graf=%s", input$menuSup, input$theTabsObj, input$ciudadObjD, varf, idG)
  #     }
  #   }
  #   if (input$menuSup == 'cruces') {
  #     h <- sprintf("?men=%s&city=%s&comp=%s", input$menuSup, input$cidCruc, paste(c(input$varPerC, input$varOfiC), collapse = 'Vs'))}
  #   if (input$menuSup == 'indices') {
  #     if (input$MenuIndices == 'IPS') {
  #       if (input$claseIPS == 'Departamentos') {
  #        idDe <- input$hcClicked$id
  #        if (is.null(idDe)) idDe <- ''
  #         h <- sprintf("?men=%s&indice=%s&depto=%s", input$menuSup, input$MenuIndices, idDe)}
  #       if (input$claseIPS == 'Ciudades') {
  #         idCy <- input$ClickedCiudad$id
  #         if (is.null(idCy)) idCy <- ''
  #         h <- sprintf("?men=%s&indice=%s&ciud=%s&anio=%s", input$menuSup, input$MenuIndices,  idCy, input$anioSelIps)}
  #       if (input$claseIPS == 'Bogotá') {
  #         idBta <- input$mapLocalidad_shape_click$id
  #         if (is.null(idBta)) idCy <- ''
  #         h <- sprintf("?men=%s&indice=%s&loc=%s&anio=%s", input$menuSup, input$MenuIndices, idBta, input$anioSelIps)
  #       }}
  #     if (input$MenuIndices == 'ODS') {
  #       h <- sprintf("?men=%s&indice=%s&ods=%s", input$menuSup, input$MenuIndices, input$odsIndicador)
  #     }
  #     if (input$MenuIndices == 'ICU') {
  #       h <- sprintf("?men=%s&indice=%s&icu=%s", input$menuSup, input$MenuIndices, input$indCCU)
  #     }
  #     if (input$MenuIndices == 'EOT') {
  #       h <- sprintf("?men=%s&indice=%s&eot=%s", input$menuSup, input$MenuIndices, input$indEOT)
  #     }}
  # 
  #   queryBuild <- h
  #   externalUrl <- sprintf(
  #     "%s%s%s",
  #     session$clientData$url_hostname,
  #     session$clientData$url_pathname,
  #     queryBuild
  #   )
  # 
  #   tags$a(externalUrl, href = queryBuild, target = "_blank")
  # })
  # 
  # observe({
  #   query <- parseQueryString(session$clientData$url_search)
  #   if (is.null(query)) query <- 'hola'
  #   if (!is.null(query)) query <- 'chao'
  # })
  # # # 
  # output$kds <- renderPrint({
  #   idLink()
  # })
  # 
  # output$urlText <- renderText({
  #   paste(sep = "",
  #         "protocol: ", session$clientData$url_protocol, "\n",
  #         "hostname: ", session$clientData$url_hostname, "\n",
  #         "pathname: ", session$clientData$url_pathname, "\n",
  #         "port: ",     session$clientData$url_port,     "\n",
  #         "search: ",   session$clientData$url_search,   "\n"
  #   )
  # })
  # 
  # 
  # cdata <- session$clientData
  # 
  # output$clientdataText <- renderText({
  #   cnames <- names(cdata)
  #   
  #   allvalues <- lapply(cnames, function(name) {
  #     paste(name, cdata[[name]], sep = " = ")
  #   })
  #   paste(allvalues, collapse = "\n")
  # })
})

