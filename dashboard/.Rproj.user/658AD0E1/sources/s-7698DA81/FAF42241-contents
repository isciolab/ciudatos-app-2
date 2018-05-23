library(RSQLite)
library(datafringe)

datElg <- read_csv('data/temas.csv')
db <- src_sqlite('data/allData/db.sqlite3')

ciudades <- unique(datElg$Ciudad)

map(ciudades, function(z){
   dat_objetivos <- tbl(db, sql("SELECT * FROM objetivos_comparada_data")) 
   varOb <- datElg %>% 
              filter(BASE == 'Objetivos') %>% 
                drop_na(id)
   datInf <- varOb %>% select(id, Ciudad)
   varCh <- datInf %>% filter(Ciudad == z) %>% .$id
   df <- dat_objetivos %>% filter(Ciudad == z) %>% collect()
   df <- Filter(function(x) !all(is.na(x)), df)
   varCh <- intersect(varCh, names(df))
   df <- df[, c('Ciudad', 'Año', varCh)]
   write_csv(df, paste0('data/seleccion/objetivos_', z, '_data.csv'))
})


map(ciudades, function(z) {
  dat_subjet <- tbl(db, sql("SELECT * FROM subjetivos_comparada_data"))
  varOb <- datElg %>% 
            filter(BASE == 'Subjetivos') %>% 
             drop_na(id)
  datInf <- varOb %>% select(id, Ciudad)
  
  varCh <- datInf %>% filter(Ciudad == z) %>% .$id
  
  df <- dat_subjet %>% filter(CIUDAD == z) %>% collect()
  df <- Filter(function(x) !all(is.na(x)), df)
  varCh <- intersect(varCh, names(df))
  df <- try(df[, c('CIUDAD', 'AÑO', varCh)])
  try(write_csv(df, paste0('data/seleccion/subjetivos_', z, '_data.csv')))
})




