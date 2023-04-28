library(tidyverse)
library(lubridate)
library(dplyr)
library(data.table)

farmacs = readRDS("/home/idiap/projects/scorewater2/build.data/farmacsreals.rds")

farmacs = farmacs %>% group_by(Zona, codi_edar, date, Therapeutic_Group, Compound) %>%
  summarize_if(is.numeric, sum, na.rm=T)

farmacs = farmacs %>% mutate(`prevalencia_nddd(%)`=round((nddd/pob_SIDIAP_mensual)*100,2))
farmacs = farmacs %>% mutate(`prevalencia_env(%)`=round((env/pob_SIDIAP_mensual)*100,2))
farmacs = farmacs %>% mutate(`prevalencia_compocant(%)`=round((`compocant (mg)`/pob_SIDIAP_mensual)*100,2))

farmacs = farmacs %>% select(Zona, codi_edar, date, Therapeutic_Group, Compound,
                             Zona, pob_SIDIAP_mensual, pob_real, nddd, `prevalencia_nddd(%)`, 
                             env, `prevalencia_env(%)`, `compocant (mg)`, `prevalencia_compocant(%)`)

saveRDS(farmacs, file='~/idiap/projects/scorewater2/build.data/prevalencia_farmacs.rds')
