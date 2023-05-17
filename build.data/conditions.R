library(tidyverse)
library(lubridate)
library(dplyr)
library(data.table)

conditions = readRDS("/home/idiap/projects/scorewater2/build.data/conditionsreals.rds")

conditions = conditions %>% mutate(poblacio_prevalent = ifelse(is.na(poblacio_prevalent), 0, poblacio_prevalent)) %>%
  mutate(casos_prevalents = ifelse(is.na(casos_prevalents), 0, casos_prevalents)) %>%
  mutate(pob_real = ifelse(is.na(pob_real), 0, pob_real))
conditions$casos_incidents<- NULL
conditions$poblacio_incident<-NULL

conditions2 = conditions %>% group_by(scensal, municipi, provincia, codi_edar, Zona, edat, sexe) %>% summarize_if(is.numeric, max, na.rm=TRUE) %>% select(scensal, municipi,
                                                                                                                                                  provincia, codi_edar,
                                                                                                                                                  Zona, edat, sexe,
                                                                                                                                                  poblacio_prevalent,
                                                                                                                                                  pob_real)
conditions2 = conditions2 %>% group_by(scensal, municipi, provincia, codi_edar, Zona) %>% summarize_if(is.numeric, sum, na.rm=TRUE)

conditions = conditions %>% group_by(scensal, condicio, municipi, provincia, codi_edar, Zona) %>%
  summarize_if(is.numeric, sum, na.rm=T) %>% select(-poblacio_prevalent, -pob_real)
conditions = full_join(conditions, conditions2)
conditions = conditions %>% mutate(`prevalencia(%)`=round((casos_prevalents/poblacio_prevalent)*100, 2))
saveRDS(conditions, file='~/idiap/projects/scorewater2/build.data/prevalencia_conditions.rds')
write.csv(conditions, '~/idiap/projects/scorewater2/conditions.csv')
