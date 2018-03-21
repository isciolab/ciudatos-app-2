library(shiny)
library(tidyverse)
library(rio)
library(datafringe)
library(xlsx)
library(RSQLite)
library(shinyjs)


db <- src_sqlite("data/db.sqlite3")

BotonesGenerales <- function(dic, cssl){
  
  dic$id_tema <- iconv(gsub(' ', '_', tolower(dic$Tema)), to="ASCII//TRANSLIT")
  dic$Tema_Mod <- stringi::stri_trans_totitle(tolower(dic$Tema))
  dic <- dic %>% drop_na(Tema) 
  dic
  
  temas <- unique(dic$id_tema)
  
  map(temas, function(z){
    HTML( paste0(
      tags$button(id = z, class = cssl, type = "button",
                  tags$img(src = paste0('temas/',z, '.png') , class =  'cosa'), #paste0('img/',z, '.png')
                  tags$span(dic$Tema_Mod[dic$id_tema == z][1], class = 'textBut')
      ),
      
      "
        <script type='text/javascript'>
          document.querySelector('.buttonStyle, .buttonStyleObj').classList.add('pressed');
          document.querySelector('.cosa').classList.add('inverse');
      	</script>
      "
    )
    )
    
    
  })
  
}

pagOne <- function(data, ruta, ciudadE, Tbase){

  if (Tbase == 'objetivos') {
  minYear <- min(as.numeric(data$Año))
  maxYear <- max(as.numeric(data$Año)) }
  if (Tbase == 'subjetivos') {
  minYear <- min(as.numeric(data$AÑO))
  maxYear <- max(as.numeric(data$AÑO)) }
  if (Tbase == 'icu') {
  minYear <- min(as.numeric(data$ano))
  maxYear <- max(as.numeric(data$ano)) }
  if (Tbase == 'ipsBta') {
  minYear <- min(as.numeric(data$Año))
  maxYear <- max(as.numeric(data$Año)) 
  lT <- length(unique(data$Localidad))-1
  lisC <- unique(data$Localidad)}
  if (Tbase == 'ipsCiud') {
  minYear <- min(as.numeric(data$Anio))
  maxYear <- max(as.numeric(data$Anio))
  lT <- length(unique(data$Ciudad))-1 
  lisC <- unique(data$Ciudad)}
  if (Tbase == 'ipsDpto') {
  lT <- length(unique(data$Departamento))-1
  lisC <- unique(data$Departamento)}
  if (Tbase == 'ipsCiuDim') {
  minYear <- min(as.numeric(data$anio))
  maxYear <- max(as.numeric(data$anio))
  lT <- length(unique(data$ciudad))-1
  lisC <- unique(data$ciudad)}
  
  
  nFil <- dim(data)[1]
  nCol <- dim(data)[2]
  
  wb <- xlsx::createWorkbook(type="xlsx")
  
  sheet <- createSheet(wb, sheetName = "Descripción")
  
  
  titleStyle <- CellStyle(wb)+ Font(wb,  heightInPoints=16, 
                                    color="gray4", isBold=TRUE, underline=1)
  
  
  xlsx.addTitle<-function(sheet, rowIndex, title, titleStyle){
    rows <-createRow(sheet,rowIndex=rowIndex)
    sheetTitle <-createCell(rows, colIndex=2)
    setCellValue(sheetTitle[[1,1]], title)
    setCellStyle(sheetTitle[[1,1]], titleStyle)
  }
  
  
  xlsx.addTitle(sheet, rowIndex=2, title="Descripción del archivo",
                titleStyle = titleStyle)
  if (ciudadE == 'comparada' & Tbase == 'objetivos') {
    columnaUno = c('Técnica de recolección:', 
                   'Contenido:', 
                   'Ciudades/Municipio:',
                   rep('',length(unique(data$Ciudad))-1), 
                   'Años:', 
                   'Temas generales:', 
                   rep('', 14), 
                   'Total variables:', 
                   'Total filas:')
    columnaDos = c('Recolección de información de diversas fuentes.',
                   'Cifras, índices, porcentajes y tasas de diferentes aspectos de ciudad como vamos.',
                   unique(data$Ciudad),
                   paste0(minYear, '-', maxYear),
                   'd', 'p','s', 'e', 'ml', 'sc', 'v', 'ma',
                   'm','ep','cr','pc','gp','ee',
                   '', nFil, nCol)
    columnaTres = c(
      rep('',25),
      'Demografía',
      'Pobreza y equidad',
      'Salud',
      'Educación',
      'Mercado laboral',
      'Seguridad ciudadana',
      'Vivienda',
      'Medio ambiente',
      'Movilidad',
      'Espacio público',
      'Cultura recreacón y deporte',
      'Participación ciudadana',
      'Finanzas y gestión pública',
      'Entorno Económico',
      '', '', '')
    info <- data.frame(columnaUno, columnaDos, columnaTres) }
  if(ciudadE == 'comparada' & Tbase == 'subjetivos') {
    columnaUno = c('Técnica de recolección:', 
                   'Unidades de observación', 
                   'Contenido:', 
                   '', 
                   'Ciudades',
                   rep('',length(unique(data$CIUDAD))-1), 
                   'Años:', 
                   'Temas generales:', 
                   rep('', 16), 
                   '',
                   'Total variables:', 
                   'Total filas:')
    columnaDos = c('Entrevistas cara a cara, en hogares.',
                   'Las personas, los hogares, las viviendas',
                   'Resultados de las preguntas en común que se realizaron en la encuesta de',
                   'percepción ciudadana “Cómo Vamos” en las siguientes ciudades del país:',
                   unique(data$CIUDAD),
                   paste0(minYear, '-', maxYear),
                   'F', 'AG','CV', 'CO', 'AL', 'ED', 'SA', 'SP',
                   'VS','PC','RC','MV','EP','MA', 'GP','CC','GG',
                   '', nFil, nCol
    )
    columnaTres = c(
      rep('',21),
      'Información personal',
      'Optimismo y orgullo',
      'Calidad de vida',
      'Opinión económica', 
      'Alimentación',
      'Educación',
      'Salud',
      'Servicios públicos',
      'Barrio y vivienda',
      'Participación ciudadana',
      'Responsabilidad y convivencia ciudadana',
      'Movilidad vial',
      'Espacio público',
      'Medio ambiente',
      'Gestión pública',
      'Concejo de la ciudad',
      'Transparencia',
      '', '',
      '')
    info <- data.frame(columnaUno, columnaDos, columnaTres) }
  if (ciudadE != 'comparada' & Tbase == 'objetivos') {                     
    columnaUno = c('Técnica de recolección:', 
                   'Contenido:', 
                   'Ciudad/Municipio:',
                   'Años:', 
                   'Temas generales:', 
                   rep('', 14), 
                   'Total variables:', 
                   'Total filas:')
    columnaDos = c('Recolección de información de diversas fuentes.',
                   'Cifras, índices, porcentajes y tasas de diferentes aspectos de ciudad como vamos.',
                   unique(data$Ciudad)[1],
                   paste0(minYear, '-', maxYear),
                   'd', 'p','s', 'e', 'ml', 'sc', 'v', 'ma',
                   'm','ep','cr','pc','gp','ee',
                   '', nFil, nCol)
    columnaTres = c(
      rep('',4),
      'Demografía',
      'Pobreza y equidad',
      'Salud',
      'Educación',
      'Mercado laboral',
      'Seguridad ciudadana',
      'Vivienda',
      'Medio ambiente',
      'Movilidad',
      'Espacio público',
      'Cultura recreacón y deporte',
      'Participación ciudadana',
      'Finanzas y gestión pública',
      'Entorno Económico',
      '', '', '')
    info <- data.frame(columnaUno, columnaDos, columnaTres) }
  if (ciudadE != 'comparada' & Tbase == 'subjetivos') { 
    columnaUno = c('Técnica de recolección:', 
                   'Unidades de observación', 
                   'Contenido:', 
                   '', 
                   'Ciudad:',
                   'Años:', 
                   'Temas generales:', 
                   rep('', 16), 
                   '',
                   'Total variables:', 
                   'Total filas:')
    columnaDos = c('Entrevistas cara a cara, en hogares.',
                   'Las personas, los hogares, las viviendas',
                   'Resultados de las preguntas en común que se realizaron en la encuesta de',
                   'percepción ciudadana “Cómo Vamos” en las siguientes ciudades del país:',
                   unique(data$CIUDAD)[1],
                   paste0(minYear, '-', maxYear),
                   'F', 'AG','CV', 'CO', 'AL', 'ED', 'SA', 'SP',
                   'VS','PC','RC','MV','EP','MA', 'GP','CC','GG',
                   '', nFil, nCol
    )
    columnaTres = c(
      rep('',6),
      'Información personal',
      'Optimismo y orgullo',
      'Calidad de vida',
      'Opinión económica', 
      'Alimentación',
      'Educación',
      'Salud',
      'Servicios públicos',
      'Barrio y vivienda',
      'Participación ciudadana',
      'Responsabilidad y convivencia ciudadana',
      'Movilidad vial',
      'Espacio público',
      'Medio ambiente',
      'Gestión pública',
      'Concejo de la ciudad',
      'Transparencia',
      '', '',
      '')
    info <- data.frame(columnaUno, columnaDos, columnaTres) }
  if (ciudadE == 'comparada' & Tbase == 'ods') { 
    columnaUno = c('Técnica de recolección:', 
                   'Contenido:', 
                   'Ciudades/Municipio:',
                   rep('',length(unique(data$Ciudad))-1), 
                   'Objetivos:', 
                   rep('', 14))
    columnaDos = c('Recolección de información de distintas fuentes',
                   'Se presenta el estado para el año 2015 de los indicadores definidos para el monitoreo de las metas correspondientes a los 17 Objetivos del Desarrollo Sostenible en las ciudades colombianas',
                   unique(data$Ciudad),
                   '1. Fin de la pobreza', '2. Hambre cero','3. Salud y bienestar', '4. Educación de calidad', '5. Igualdad de género', '6. Agua limpia y Saneamiento', '7. Energía sostenible y no contaminante', '8. Trabajo decente y crecimiento económico',
                   '9. Industria, innovación e infraestructura', '10. Reducción de las desigualdades', '11. Ciudades y comunidades sostenibles', '12. Producción y consumo responsables', '13. Acción por el clima',  '16. Paz, justicia e institucione sólidas', '17. Alianzas para lograr los objetivos')
    columnaTres = c(
      rep('',13),
      'Erradicar la pobreza en todas sus formas en todo el mundo',
      'Poner fin al hambre, conseguir la seguridad alimentaria y una mejor nutrición, y promover la agricultura sostenible',
      'Garantizar una vida saludable y promover el bienestar para todos para todas las edades',
      'Garantizar una educación de calidad inclusiva y equitativa, y promover las oportunidades de aprendizaje permanente para todos',
      'Alcanzar la igualdad entre los géneros y empoderar a todas las mujeres y niñas',
      'Garantizar la disponibilidad y la gestión sostenible del agua y el saneamiento para todos',
      'Asegurar el acceso a energías asequibles, fiables, sostenibles y modernas para todos',
      'Fomentar el crecimiento económico sostenido, inclusivo y sostenible, el empleo pleno y productivo, y el trabajo decente para todos',
      'Desarrollar infraestructuras resilientes, promover la industrialización inclusiva y sostenible, y fomentar la innovación',
      'Reducir las desigualdades entre países y dentro de ellos',
      'Conseguir que las ciudades y los asentamientos humanos sean inclusivos, seguros, resilientes y sostenibles',
      'Garantizar las pautas de consumo y de producción sostenibles (Ningun dato disponible)',
      'Tomar medidas urgentes para combatir el cambio climático y sus efectos (tomando nota de los acuerdos adoptados en el foro de la Convención Marco de las Naciones Unidas sobre el Cambio Climático)',
      'Promover sociedades pacíficas e inclusivas para el desarrollo sostenible, facilitar acceso a la justicia para todos y crear instituciones eficaces, responsables e inclusivas a todos los niveles',
      'Fortalecer los medios de ejecución y reavivar la alianza mundial para el desarrollo sostenible')
    info <- data.frame(columnaUno, columnaDos, columnaTres) }
  if (ciudadE != 'comparada' & Tbase == 'ods') { 
    columnaUno = c('Técnica de recolección:', 
                   'Contenido:', 
                   'Ciudades:',
                   'Objetivos:', 
                   rep('', 14))
    columnaDos = c('Recolección de información de distintas fuentes',
                   'Se presenta el estado para el año 2015 de los indicadores definidos para el monitoreo de las metas correspondientes a los 17 Objetivos del Desarrollo Sostenible en las ciudades colombianas',
                   unique(data$Ciudad), 
                   '1. Fin de la pobreza', '2. Hambre cero','3. Salud y bienestar', '4. Educación de calidad', '5. Igualdad de género', '6. Agua limpia y Saneamiento', '7. Energía sostenible y no contaminante', '8. Trabajo decente y crecimiento económico',
                   '9. Industria, innovación e infraestructura', '10. Reducción de las desigualdades', '11. Ciudades y comunidades sostenibles', '12. Producción y consumo responsables', '13. Acción por el clima',  '16. Paz, justicia e institucione sólidas', '17. Alianzas para lograr los objetivos')
    columnaTres = c(
      rep('',3),
      'Erradicar la pobreza en todas sus formas en todo el mundo',
      'Poner fin al hambre, conseguir la seguridad alimentaria y una mejor nutrición, y promover la agricultura sostenible',
      'Garantizar una vida saludable y promover el bienestar para todos para todas las edades',
      'Garantizar una educación de calidad inclusiva y equitativa, y promover las oportunidades de aprendizaje permanente para todos',
      'Alcanzar la igualdad entre los géneros y empoderar a todas las mujeres y niñas',
      'Garantizar la disponibilidad y la gestión sostenible del agua y el saneamiento para todos',
      'Asegurar el acceso a energías asequibles, fiables, sostenibles y modernas para todos',
      'Fomentar el crecimiento económico sostenido, inclusivo y sostenible, el empleo pleno y productivo, y el trabajo decente para todos',
      'Desarrollar infraestructuras resilientes, promover la industrialización inclusiva y sostenible, y fomentar la innovación',
      'Reducir las desigualdades entre países y dentro de ellos',
      'Conseguir que las ciudades y los asentamientos humanos sean inclusivos, seguros, resilientes y sostenibles',
      'Garantizar las pautas de consumo y de producción sostenibles (Ningun dato disponible)',
      'Tomar medidas urgentes para combatir el cambio climático y sus efectos (tomando nota de los acuerdos adoptados en el foro de la Convención Marco de las Naciones Unidas sobre el Cambio Climático)',
      'Promover sociedades pacíficas e inclusivas para el desarrollo sostenible, facilitar acceso a la justicia para todos y crear instituciones eficaces, responsables e inclusivas a todos los niveles',
      'Fortalecer los medios de ejecución y reavivar la alianza mundial para el desarrollo sostenible')
    info <- data.frame(columnaUno, columnaDos, columnaTres) }
  if (ciudadE == 'comparada' & Tbase == 'icu') {
    columnaUno = c('Técnica de recolección:', 
                   'Contenido:', 
                   'Ciudades:',
                   rep('',length(unique(data$ciudad))-1), 
                   'Años:', 
                   'Temas generales:', 
                   rep('', 5), 
                   'Total variables:', 
                   'Total filas:')
    columnaDos = c('Recolección de información de diversas fuentes.',
                   'Cifras, índices, porcentajes y tasas de diferentes aspectos educativos.',
                   unique(data$ciudad),
                   paste0(minYear, '-', maxYear),
                   'Generales', 'Empleabilidad','Atracción', 'Asequibilidad', 'Ambiente', 'Calidad',
                   nFil, nCol)
    
    info <- data.frame(columnaUno, columnaDos) }
  if (ciudadE != 'comparada' & Tbase == 'icu') {
    columnaUno = c('Técnica de recolección:', 
                   'Contenido:', 
                   'Ciudad',
                   'Años:', 
                   'Temas generales:', 
                   rep('', 5), 
                   'Total variables:', 
                   'Total filas:')
    columnaDos = c('Recolección de información de diversas fuentes.',
                   'Cifras, índices, porcentajes y tasas de diferentes aspectos educativos.',
                   unique(data$ciudad),
                   paste0(minYear, '-', maxYear),
                   'Generales', 'Empleabilidad','Atracción', 'Asequibilidad', 'Ambiente', 'Calidad',
                   nFil, nCol)
  info <- data.frame(columnaUno, columnaDos) }
  if (Tbase == 'ipsDpto' | Tbase == 'ipsCiud' | Tbase == 'ipsBta' | Tbase == 'ipsCiuDim') {
  columnaUno = c('Técnica de recolección:', 
                 'Contenido:', 
                 'Departamento/Ciudad:',
                 rep('', lT),
                 'Componentes:', 
                 rep('', 11))
  columnaDos = c(' ',
                 ' ',
                 lisC, 
                 'Necesidades Humanas Básicas',
                 rep('',3),
                 'Fundamentos del bienestar',
                 rep('',3),
                 'Oportunidades',
                 '',
                 'Total variables:', 
                 'Total filas:'
  )
  columnaTres = c(
    rep('',3),
    rep('', lT),
    'Nutrición y cuidados básicos de Salud',
    'Agua y saneamiento básico',
    'Vivienda y Servicios públicos',
    'Seguridad Personal',
    'Acceso al conocimiento Básico', 
    'Acceso a información y telecomunicaciones',
    'Salud y Bienestar',
    'Sostenibilidad ambiental',
    'Tolerancia e Inclusión',
    'Acceso a la educación superior',
    nFil, nCol
  )
  info <- data.frame(columnaUno, columnaDos, columnaTres) }
  if (Tbase == 'totalBta') {
    columnaUno = c('Técnica de recolección:', 
                   'Contenido:', 
                   'Ciudad:',
                   'Componentes:', 
                   rep('', 11))
    columnaDos = c(' ',
                   ' ',
                   'Bogotá', 
                   'Necesidades Humanas Básicas',
                   rep('',3),
                   'Fundamentos del bienestar',
                   rep('',3),
                   'Oportunidades',
                   '',
                   'Total variables:', 
                   'Total filas:'
    )
    columnaTres = c(
      rep('',3),
      'Nutrición y cuidados básicos de Salud',
      'Agua y saneamiento básico',
      'Vivienda y Servicios públicos',
      'Seguridad Personal',
      'Acceso al conocimiento Básico', 
      'Acceso a información y telecomunicaciones',
      'Salud y Bienestar',
      'Sostenibilidad ambiental',
      'Tolerancia e Inclusión',
      'Acceso a la educación superior',
      nFil, nCol
    )
    info <- data.frame(columnaUno, columnaDos, columnaTres) }
  if(Tbase == 'eot') {
    columnaUno = c('Técnica de recolección:', 
                   'Contenido:', 
                   'Ciudades',
                   rep('',length(unique(data$Ciudad))-1), 
                   'Años:', 
                   'Total variables:', 
                   'Total filas:')
    columnaDos = c('Recolección de información de diversas fuentes.',
                   'Cifras, índices, porcentajes y tasas de diferentes aspectos de la trayectoria escolar y laboral de cinco ciudades del País',
                   unique(data$Ciudad),
                   paste0(unique(sort(data$Ano)), collapse = '/'), nFil, nCol)
    info <- data.frame(columnaUno, columnaDos)}
    
  cs1 <- CellStyle(wb) + Font(wb, isItalic=TRUE, color="gray4", isBold=TRUE) 
  cs2 <- CellStyle(wb) + Font(wb, color="gray4")
  xlsx::addDataFrame(info, sheet, startRow=4, startColumn=2, 
               col.names  = FALSE, row.names = FALSE,
               colStyle=list(`1`=cs1,`2`=cs2, `3`=cs1))
  xlsx::saveWorkbook(wb, ruta)
}


addLine <- function(data, dic){
  # names(data) <- paste(names(data) ,dic$label)  
  data <- map_df(data, as.character)
  line <- t(dic[,2])
  pegar <- data.frame(line)
  names(pegar) <- names(data)
  dataNew <- rbind(pegar,data)
  as.data.frame(dataNew)
}


exc_gen <- function(data, dic, ciudadE, Tbase, file){
  
  if (Tbase == 'ods') {
    data <- data
  } else {
  to_change <- dic$id[grepl("Pct", dic$ctype)]
  to_change <- as.character(to_change)
  data[,to_change] <-  map(data[,to_change], as.numeric)
  data[,to_change] <- map_df(data[,to_change], function(z) paste0(z*100,'%'))
  data <- map_df(data, function(z) ifelse(z == 'NA%', NA, z))
  }
  pagOne(data=data, file, ciudadE, Tbase)
  
  if (Tbase == 'subjetivos') {
    dic_ciudad <- dic  %>% select(id, label, Pregunta, Tema)
  } 
  
  if (Tbase == 'objetivos') {
    dic_ciudad <- dic  %>% select(id, label, Tema, Descripción, Fuente, Unidad)
  }
  if (Tbase == 'ods') {
    dic_ciudad <- NULL
  }
  if (Tbase == 'icu') {
    dic_ciudad <- dic %>% select(id, label, Categoria)
  }
  if (Tbase == 'ipsDpto' | Tbase == 'ipsCiud' | Tbase == 'ipsBta' | Tbase == 'ipsCiuDim' | Tbase == 'totalBta' | Tbase == 'eot') {
    dic_ciudad <- dic %>% select(-ctype, -cformat, -cdescription)
  }
  
  
  if (is.null(dic_ciudad)) {
  rio::export(data, file, which = 'datos', overwrite = FALSE) 
  } else {
  write.xlsx(as.data.frame(dic_ciudad), file, sheetName = 'Diccionario', row.names = FALSE, showNA = FALSE, append=TRUE)
  bar_excel <- addLine(data = data, dic = dic)
  rio::export(bar_excel, file, which = 'datos', overwrite = FALSE)
  }
  
}




#https://randommonkey.shinyapps.io/appDownload/