
library(whisker)
library(tidyverse)
temas <- read_csv('data/temas.csv') #%>% drop_na(id)
cy <- 'Manizales'
temas <- temas %>% filter(Ciudad == cy)
temas$BASE <- tolower(temas$BASE)
temas <- temas %>% select(sectionTitle = Tema, everything())
desCid <- read_csv('data/ciudades.csv')


#vizPos <- c('hgch_line_YeaNum', 'hgch_bar_YeaNum', 'hgch_area_YeaNum', 'hgch_donut_CatNum', 'hgch_pie_CatNum')
#temas$graf <- ifelse(temas$BASE == 'objetivos', vizPos[grep('YeaNum', vizPos)], vizPos[grep('CatNum', vizPos)])


a <- map(unique(temas$sectionTitle), function(z) {
  df <- temas 
  df$numdt <- 1:nrow(df)
  df <- df %>%  filter(sectionTitle %in% z)
  df$num <- 1:nrow(df)
  d <- list(sectionTitle = df$titTemas[df$sectionTitle == z][1],
            subsections =
              map(df$Indicador,function(x){
                if (sum(is.na(df$id)) == 2){
                tx <- list(subsectionTitle = df$DesTemas[df$Indicador == x], sectionGraph = 'na', Base = 'NA', sectionColumns = 'NA')
                } else {
                  if (sum(is.na(df$DesTemas)) == 1) {
                    dft <- df %>% drop_na(DesTemas)
                    tx <- list(subsectionTitle = dft$DesTemas[dft$Indicador == x], sectionBlock = paste0('vizPar',  df$numdt[df$Indicador == x]), sectionGraph = as.character(df$viz[df$Indicador == x]), sectionNumber = paste0('vizPar', df$num[df$Indicador == x]), parId = paste0('parrCol', df$numdt[df$Indicador == x]), Base = df$BASE[df$Indicador ==x], sectionColumns = paste0('Año,AÑO,', df$id[df$Indicador ==x]), dicHor = df$Indicador[df$Indicador ==x], dicVer = 'Año', sectCol = df$X6[df$Indicador == x])#paste0('twoCol', df$num[df$Indicador == x]))
                  } 
                   if (sum(is.na(df$DesTemas)) == 0) {
                    tx <- list(subsectionTitle = df$DesTemas[df$Indicador == x], sectionGraph = df$viz[df$Indicador == x], sectionBlock = paste0('loloo', x), Base = df$BASE[df$Indicador ==x], sectionColumns = paste0('Año,AÑO,', df$id[df$Indicador ==x]), dicHor = df$Indicador[df$Indicador ==x], dicVer = 'Año', sectCol = df$X6[df$Indicador ==x])#, Ciudad = unique(df$Ciudad), Base = df$BASE[df$Indicador ==x], sectionColumns = paste0('Año,AÑO,', df$id[df$Indicador ==x]), sectionText = temas$DesTemas[temas$sectionTitle == x], sectionGraph = df$graf[df$Indicador ==x])
                }}
                tx
              })
              
  )
  d
})


rep <- list(
  titulo = unique(temas$TituloGeneral)[1],
  Ciudad = cy,
  descripcion = desCid$Descripción[desCid$Ciudad == cy], 
  desGeneral = temas$Des_general[1],
  sections = a
)


renderRmd <- function(rep, output_file = paste0("ciudades/",cy, ".html")){
  rmdTplPath <- "template.rmd"
  rmdTpl <- readLines(rmdTplPath)
  repRmd <- whisker.render(rmdTpl, data = rep)
  t <- "report.Rmd"
  write(repRmd, t)
  rmarkdown::render(t,output_file = output_file,
                    params = p,
                    output_options = list(
                      template= "template.html"
                    )
  )
  #unlink(t)
}
renderRmd(rep)




#dataObsCat <- read_csv('data/seleccion/objetivos_Cartagena_data.csv')
#dataPerCar <- read_csv('data/seleccion/subjetivos_Cartagena_data.csv')


