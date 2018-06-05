

shinyServer(function(input, output, session){
  
  output$idbase <- renderUI({
    selectInput('basechoose', 'Seleccione Data',
                c('Datos oficiales' = 'do', 
                  'Datos de percepción ciudadana' = 'pc',
                  'Índice de progreso social' = 'ips',
                  'Índice de ciudades universitarias' = 'icu',
                  'Objetivos de desarrollo sostenible' = 'ods',
                  'Educación orientada al trabajo' = 'eot'))
  })
  
  basedb <- reactive({
    
    idb <- input$basechoose
    
    if(idb == 'pc') {
      h <- tbl(db, sql("SELECT * FROM subjetivos_comparada_data")) }
    if(idb == 'do' ) {
      h <- tbl(db, sql("SELECT * FROM objetivos_comparada_data")) }
    if(idb == 'ips' ) {
       if (input$selips == 'Departamento') {
         h <- tbl(db, sql("SELECT * FROM ips_departamentos_variables_data"))}
       if (input$selips == 'Ciudad'){
         if (input$selCiudM == 'Dimensiones') {
         h <- tbl(db, sql("SELECT * FROM ips_interciudades_resultados_data"))}
         if (input$selCiudM == 'Componentes') {
         h <- tbl(db, sql("SELECT * FROM ips_interciudades_variables_data"))}
         }
      if (input$selips == 'Bogotá'){
        if (input$tipoBog == 'Total'){
          if (input$selTip == 'Dimensiones') {
            h <- tbl(db, sql("SELECT * FROM intraurbano_bogota_data"))}
          if (input$selTip == 'Componentes') {
            h <- tbl(db, sql("SELECT * FROM intraurbano_variables_bogota_data"))}}
        if (input$tipoBog == 'Localidades'){
          if (input$selTip == 'Dimensiones') {
            h <- tbl(db, sql("SELECT * FROM intraurbano_localidades_data"))}
          if (input$selTip == 'Componentes') {
            h <- tbl(db, sql("SELECT * FROM intraurbano_variables_localidades_data"))}}
        }
      }
    if(idb == 'icu' ) {
      h <- tbl(db, sql("SELECT * FROM ciudades_universitarias_data")) }
    if(idb == 'ods' ) {
      h <- tbl(db, sql("SELECT * FROM ods_full_data")) }
    if(idb == 'eot' ) {
      h <- tbl(db, sql("SELECT * FROM eot_data")) }
    h
  })
  

  
  diccdb <- reactive({
    
    idb <- input$basechoose
    
    if(idb == 'pc')
      h <-  tbl(db, sql("SELECT * FROM subjetivos_comparada_dic_"))
    if(idb == 'do')
      h <-  tbl(db, sql("SELECT * FROM objetivos_comparada_dic_"))
    if(idb == 'ips') {
      if (input$selips == 'Departamento') {
        h <- tbl(db, sql("SELECT * FROM ips_departamentos_variables_dic_"))}
    if (input$selips == 'Ciudad'){
      if (input$selCiudM == 'Dimensiones') {
        h <- tbl(db, sql("SELECT * FROM ips_interciudades_resultados_dic_"))}
      if (input$selCiudM == 'Componentes') {
        h <- tbl(db, sql("SELECT * FROM ips_interciudades_variables_dic_"))}
    }
    if (input$selips == 'Bogotá'){
      if (input$tipoBog == 'Total'){
        if (input$selTip == 'Dimensiones') {
          h <- tbl(db, sql("SELECT * FROM intraurbano_bogota_dic_"))}
        if (input$selTip == 'Componentes') {
          h <- tbl(db, sql("SELECT * FROM intraurbano_variables_bogota_dic_"))}}
      if (input$tipoBog == 'Localidades'){
        if (input$selTip == 'Dimensiones') {
          h <- tbl(db, sql("SELECT * FROM intraurbano_localidades_dic_"))}
        if (input$selTip == 'Componentes') {
          h <- tbl(db, sql("SELECT * FROM intraurbano_variables_localidades_dic_"))}}
    }
  }
    if(idb == 'icu')
      h <- tbl(db, sql("SELECT * FROM ciudades_universitarias_dic_"))
    if(idb == 'ods')
      h <- tbl(db, sql("SELECT * FROM ods_full_data"))
    if(idb == 'eot')
      h <- tbl(db, sql("SELECT * FROM eot_dic_"))
    h
  })
  
  botonesMenu <- reactive({
    
    idb <- input$basechoose
    
    if(idb == 'pc') {
      h <-  BotonesGenerales(diccdb() %>% collect(), cssl = "buttonStyle") }
    if(idb == 'do' ) {
      h <-  BotonesGenerales(diccdb() %>% collect(), cssl = "buttonStyleObj")}
    if(idb == 'ips' ) {
      h <- radioButtons('selips', '', c('Departamento', 'Ciudad', 'Bogotá'))}
    if(idb == 'icu' ) {
      d <- diccdb() %>% collect()
      d$temas <-  iconv(tolower(d$Categoria), to="ASCII//TRANSLIT")
      h <- map(as.character(unique(d$temas))[c(-1,-2)], function(z){
        HTML(paste0(
          tags$button(id = z, class = 'buttonStyleIcu', type = "button",
                      tags$img(src = paste0('icu/',z, '.png'), class = 'cosa'), #paste0('img/',z, '.png')
                      tags$span(d$Categoria[d$temas == z][1], class = 'textBut')),
                      "
        <script type='text/javascript'>
          document.querySelector('.buttonStyleIcu').classList.add('pressed');
          document.querySelector('.cosa').classList.add('inverse');
      	</script>
      "
          
      ))
          })}
    if(idb == 'ods' ) {
      d <- basedb() %>% collect()
      temas <- tolower(as.character(unique(d$Objetivos)))
      h <-  map(temas, function(z){
                       tags$button(id = z, class = "buttonStyleODS", type = "button",
                       tags$img(src = paste0('ods/',z, '.jpg') , class =  'imgODS'))}) 
      }
    if(idb == 'eot' ){
      h <- HTML('<span style = "color:#00CEF6">Propone analizar lo que sucede en los diferentes tramos de la trayectoria escolar y laboral 
con el fin de plantear alternativas que ayuden a mitigar el efecto de factores como el
insuficiente desarrollo de competencias de los estudiantes y la desarticulación institucional.</span>') }
    h
  })
  
  ciudades <- reactive({
    ciudadID <- basedb() %>% collect() 
    
    idb <- input$basechoose
   

    if (idb == 'pc') {
     CD <-  ciudadID %>% .$CIUDAD
     CD <- unique(CD) }
    if (idb == 'icu' ) {
     CD <- ciudadID %>% .$ciudad
     CD <- unique(CD) }
    if (idb == 'do' ) {
     CD <-  ciudadID %>% .$Ciudad
     CD <- unique(CD) }
    if (idb == 'ods' ) {
      CD <-  ciudadID %>% .$Ciudad
      CD <- unique(CD)
    }
    if (idb == 'eot') {
      CD <-  ciudadID %>% .$Ciudad
      CD <- unique(CD)
    }

    CD
    
  })
  
  output$SelCiudad <- renderUI({
    selectInput('ciudadEle', 'Seleccione Ciudad', ciudades())
  })
  
  filtrosDicc <- reactive({
    
    idb <- input$basechoose
    temS <- input$last_btn
    temO <- input$last_btnObj
    objID <- input$last_btnods
    icuId <- input$last_btnicu

    if (is.null(temS)) {
     temS <- 'bienestar_subjetivo' }
    if (is.null(temO)) {
     temO <- 'pobreza_y_equidad' }
    if (is.null(objID)) {
     objID <- 'objetivo1' }
    if (is.null(icuId)) {
     icuId <- 'general' }
  

    dic <- diccdb() %>% collect()



    if (idb == 'ods') {
      dic$id_tema <- tolower(dic$Objetivos) }
    if (idb == 'icu' ) {
      dic$id_tema <- iconv(tolower(as.character(dic$Categoria)), to="ASCII//TRANSLIT") }
    if (idb == 'pc') {
      dic$id_tema <- iconv(gsub(' ', '_', tolower(dic$Tema)), to="ASCII//TRANSLIT")}
    if (idb == 'do') {
      dic$id_tema <- iconv(gsub(' ', '_', tolower(dic$Tema)), to="ASCII//TRANSLIT")}

    if (idb == 'pc') {
      dcom <- data.frame(id = c('CIUDAD', 'AÑO'), label = c('Ciudad', 'Año')) }
    if (idb == 'do') {
      dcom <- data.frame(id = c('Ciudad', 'Año'), label = c('Ciudad', 'Año')) }
    if (idb == 'icu') {
      dcom <- data.frame(id = c('ciudad', 'ano'), label = c('Ciudad', 'Año'))
    }
    # 
    if (idb == 'pc') {
      dic <- dic %>% filter(id_tema == temS)
      dic <- bind_rows(dcom, dic)}
    if (idb == 'do') {
      dic <- dic %>% filter(id_tema == temO)
      dic <- bind_rows(dcom, dic)}
    if (idb == 'ods') {
      dic <- dic %>% filter(id_tema == objID) }
    if (idb == 'icu') {
      dic <- dic %>% filter(id_tema == icuId)
      dic <- bind_rows(dcom, dic) }
    if (idb == 'ips') {
      dic <- dic
    }
    if (idb == 'eot') {
      dic <- dic
    }
    
    dic
  })
  
  
  
  # output$cielo <- renderPrint({
  #   filtrosDicc()
  # })
  # 
  filtrosBase <- reactive({

    idb <- input$basechoose
    dta <- basedb() #%>% filter() %>% collect()

    if (idb == 'pc') {
      CD <-  dta %>% filter(CIUDAD %in% input$ciudadEle) %>% collect()
      CD <- CD[, filtrosDicc()$id]
      CD <- Filter(function(x) !all(is.na(x)), CD)
      }
    if (idb == 'do') {
      CD <-  dta %>% filter(Ciudad %in% input$ciudadEle) %>% collect()
      CD <- CD[, filtrosDicc()$id]
      CD <- Filter(function(x) !all(is.na(x)), CD)
    }
    if (idb == 'ods') {
      CD <-  dta %>% filter(Ciudad %in% input$ciudadEle) %>% collect()
      CD$Año <- 2015
      CD$Objetivos <- tolower(CD$Objetivos)
      CD <- CD %>% filter(Objetivos %in% unique(filtrosDicc()$id_tema))
      to_c <- grep("%", CD$simbolo)
      CD$Valor[to_c] <- paste0(CD$Valor[to_c], '%')
      to_p <- grep("\\$̣", CD$simbolo)
      CD$Valor[to_p] <- paste0('$', CD$Valor[to_p])
      CD <- CD %>% select(-simbolo)
    }
    if (idb == 'icu') {
      CD <-  dta %>% filter(ciudad %in% input$ciudadEle) %>% collect()
      CD <- CD[, filtrosDicc()$id]
      CD <- Filter(function(x) !all(is.na(x)), CD)
    }
    if (idb == 'ips') {
      CD <- dta %>% collect()
    }
    if (idb == 'eot') {
      CD <- dta %>% filter(Ciudad %in% input$ciudadEle) %>% collect()
      CD <- Filter(function(x) !all(is.na(x)), CD)
      CD
    }
    CD
  })

 tabNamesCol <- reactive({
  
   df <- filtrosBase()
   
   if (input$basechoose != 'ods') {
   varNam <- data.frame(id = names(df))
   dicInd <- varNam %>% 
              inner_join(diccdb() %>% collect(), by = 'id') %>% .$label
   names(df) <- as.character(dicInd)
   df } else {
     df <- df
   }
   df
   
 })
  
 output$blabla <- renderPrint({
   tabNamesCol()
 })
  
  output$printData <- renderDataTable(tabNamesCol(),
    options = list(
      pageLength = 5,
      language = list(url = "//cdn.datatables.net/plug-ins/f2c75b7247b/i18n/Spanish.json")
    )
  )

  
  output$downFiltros <- renderUI({
    div(class = 'filtButSty', style="text-align: end;",
      downloadButton('downFilt', 'Descarga CSV'),
      downloadButton('downxlsxFilt', 'Descarga XLSX')
    )
  })
  
  output$downFilt <- downloadHandler(
    "filtro_ciudadTema.csv",
    content = function(file) {
      d <- filtrosBase()
      if (elBase() == 'ods') {
        d$Valor[grep('%', d$Valor)] <- as.numeric(gsub('\\%', '', d$Valor[grep('%', d$Valor)]))/100
      }
      write_csv(d, file, na = '')
    })
  

  
  elBase <- reactive({
    
    idb <- input$basechoose
    
    if(idb == 'pc')
      h <-  'subjetivos'
    if(idb == 'do' )
      h <-  'objetivos'
    if(idb == 'ips' )
      h <- 'ips'
    if(idb == 'icu' )
      h <- 'icu'
    if(idb == 'ods' )
      h <- 'ods'
    if(idb == 'eot' )
      h <- 'eot'
    h  
  })
  
  output$downxlsxFilt <- downloadHandler(
    "filtros.xlsx",
    content = function(file) {
      d <- filtrosBase()
      if (elBase() == 'ods'){
        dic <- NULL
      } else {
      varInfo <- data.frame(id = names(d))
      dic <- filtrosDicc()
      dic <- inner_join(varInfo, dic) }
      exc_gen(data = d, dic = dic, ciudadE = 'ciudad', Tbase = elBase(), file)
    })

  
  DownloadAllG <- reactive({
    idb <- input$basechoose
    
    if (idb == 'pc')
      h <- list(
        downloadButton('downSBJ', 'Descarga todos los datos CSV'),
        downloadButton('downSBJxlsx', 'Descarga todos los datos XLSX'))
    if (idb == 'do' )
      h <- list(
        downloadButton('downOBJ', 'Descarga todos los datos CSV'),
        downloadButton('downOBJxlsx', 'Descarga todos los datos XLSX'))
    if (idb == 'ips' )
      h <- list(
        downloadButton('downIPS', 'Descarga todos los datos CSV'),
        downloadButton('downIPSxlsx', 'Descarga todos los datos XLSX'))
    if (idb == 'icu' )
      h <- list(
        downloadButton('downICU', 'Descarga todos los datos CSV'),
        downloadButton('downICUxlsx', 'Descarga todos los datos XLSX'))
    if (idb == 'ods' )
      h <- list( 
        downloadButton('downODS', 'Descarga todos los datos CSV'),
        downloadButton('downODSxlsx', 'Descarga todos los datos XLSX'))
    if (idb == 'eot' )
      h <- list(  
        downloadButton('downEOT', 'Descarga todos los datos CSV'),
        downloadButton('downEOTxlsx', 'Descarga todos los datos XLSX')
      )
    h
  })
  
  output$salida <- renderUI({
    DownloadAllG()
  })
  
  output$Menu <- renderUI({
    botonesMenu()
  })
  
  output$downSBJ <- downloadHandler(
    "all_data_subjetivos.csv",
    content = function(file) {
      d <- tbl(db, sql("SELECT * FROM subjetivos_comparada_data")) %>% collect()
      write_csv(d, file, na = '')
    })

 
  output$downSBJxlsx <- downloadHandler(
   "all_data_subjetivos.xlsx",
  content = function(file) {
   d <- tbl(db, sql("SELECT * FROM subjetivos_comparada_data")) %>% collect()
   dic <- tbl(db, sql("SELECT * FROM subjetivos_comparada_dic_")) %>% collect()
   exc_gen(data = d, dic = dic, ciudadE = 'comparada', Tbase = 'subjetivos', file)
  })  
  
  output$downOBJ <- downloadHandler(
    "all_data_objetivos.csv",
    content = function(file) {
      d <- tbl(db, sql("SELECT * FROM objetivos_comparada_data")) %>% collect()
      write_csv(d, file, na = '')
    })
  
  output$downOBJxlsx <- downloadHandler(
    "all_data_objetivos.xlsx",
    content = function(file) {
      d <- tbl(db, sql("SELECT * FROM objetivos_comparada_data")) %>% collect()
      dic <- tbl(db, sql("SELECT * FROM objetivos_comparada_dic_")) %>% collect()
      exc_gen(data = d, dic = dic, ciudadE = 'comparada', Tbase = 'objetivos', file)
    })
  

  output$downODS <- downloadHandler(
    "all_data_ods.csv",
    content = function(file) {
      d <- tbl(db, sql("SELECT * FROM ods_full_data")) %>% collect()
      d$Valor[grep('%', d$simbolo)] <- as.numeric(gsub('\\%', '', d$Valor[grep('%', d$simbolo)]))/100
      d <- d %>% select(-simbolo)
      write_csv(d, file, na = '')
    })
  
  output$downODSxlsx <- downloadHandler(
    "all_data_ods.xlsx",
    content = function(file) {
      d <- tbl(db, sql("SELECT * FROM ods_full_data")) %>% collect()
      to_c <- grep("%", d$simbolo)
      d$Valor[to_c] <- paste0(d$Valor[to_c], '%')
      to_p <- grepl('\\$', '', d$simbolo)
      d$Valor[to_p] <- paste0('$', d$Valor[to_p])
      d <- d %>% select(-simbolo)
      exc_gen(data = d, dic = NULL, ciudadE = 'comparada', Tbase = 'ods', file)
    })
  
  output$downICU <- downloadHandler(
    "all_data_icu.csv",
    content = function(file) {
      d <- tbl(db, sql("SELECT * FROM ciudades_universitarias_data")) %>% collect()
      write_csv(d, file, na = '')
    })
  
  output$downICUxlsx <- downloadHandler(
    "all_data_icu.xlsx",
    content = function(file) {
      d <- tbl(db, sql("SELECT * FROM ciudades_universitarias_data")) %>% collect()
      dic <- tbl(db, sql("SELECT * FROM ciudades_universitarias_dic_")) %>% collect()
      exc_gen(data = d, dic = dic, ciudadE = 'comparada', Tbase = 'icu', file)
    })
  
  output$downIPS <- downloadHandler(
    "all_data_ips.csv",
    content = function(file) {
      d <- basedb() %>% collect()
      write_csv(d, file, na = '')
    })
  
  tbIPS <- reactive({
    
    elgIPS <- input$selips
    


    if (elgIPS == 'Departamento') {
      a <- 'ipsDpto' }
    if (elgIPS == 'Ciudad') {
      if (input$selCiudM == 'Dimensiones') {
        a <- 'ipsCiud'}
      if (input$selCiudM == 'Componentes') {
        a <- 'ipsCiuDim'} }
    if (input$selips == 'Bogotá'){
      if (input$tipoBog == 'Total'){
        if (input$selTip == 'Dimensiones') {
          a <- 'totalBta'}
        if (input$selTip == 'Componentes') {
          a <- 'totalBta'}}
      if (input$tipoBog == 'Localidades'){
        if (input$selTip == 'Dimensiones') {
          a <- 'ipsBta'}
        if (input$selTip == 'Componentes') {
          a <- 'ipsBta'}}
    }
  

    #if (elgIPS == 'Ciudad' & input$selCiudM == 'Componentes')
    #   a <- 'ipsCiuDim'
    # if (input$tipoBog == 'Total')
    #   a <- 'totalBta'
    a
  })
  
  output$dajhsbd <- renderPrint({
    tbIPS()
  })
  output$downIPSxlsx <- downloadHandler(
    "all_data_ips.xlsx",
    content = function(file) {
      d <- basedb() %>% collect()
      dic <- diccdb() %>% collect()
      exc_gen(data = d, dic = dic, ciudadE = 'comparada', Tbase = tbIPS(), file)
    })
  
  output$downEOT <- downloadHandler(
    "all_data_eot.csv",
    content = function(file) {
      d <- basedb() %>% collect()
      write_csv(d, file, na = '')
    })
  
  output$downEOTxlsx <- downloadHandler(
    "all_data_eot.xlsx",
    content = function(file) {
      d <- basedb() %>% collect()
      dic <- diccdb() %>% collect()
      exc_gen(data = d, dic = dic, ciudadE = 'comparada', Tbase = 'eot', file)
    })
  
  output$aver <- renderUI({
    if (input$basechoose == 'ips') {
      if (input$selips == "Ciudad") {
        d <- radioButtons('selCiudM', '', c('Dimensiones', 'Componentes')) }
      if (input$selips == "Bogotá") {
        d <- list(
          radioButtons('tipoBog', '', c('Total', 'Localidades'), inline = TRUE),
          radioButtons('selTip', '', c('Dimensiones', 'Componentes')))}
    } else{
      return()
    }
    d
  })

  observe({
    query <- parseQueryString(session$clientData$url_search)
    if (!is.null(query$data)) {
      df <- data.frame(lab  = c('Datos oficiales', 
                          'Datos de percepción ciudadana',
                          'Índice de progreso social',
                          'Índice de ciudades universitarias',
                          'Objetivos de desarrollo sostenible',
                          'Educación orientada al trabajo'),
                       id = c('do', 'pc', 'ips', 'icu', 'ods', 'eot'))
      updateSelectInput(session, 'basechoose', label = NULL, choices = setNames(query$data, as.character(df$lab[df$id == query$data])),
                        selected = NULL)
    }
  })
  
})