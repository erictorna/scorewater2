library(tidyverse)
library(lubridate)
library(dplyr)
library(data.table)

groups = readRDS("/home/idiap/projects/scorewater2/build.data/groupsreals.rds")
groups = groups %>% mutate(poblacio_prevalent = ifelse(is.na(poblacio_prevalent), 0, poblacio_prevalent)) %>% 
  mutate(casos_prevalents = ifelse(is.na(casos_prevalents), 0, casos_prevalents)) %>% 
  mutate(pob_real = ifelse(is.na(pob_real), 0, pob_real))
groups$casos_incidents<- NULL
groups$poblacio_incident<-NULL
groups2 = groups %>% group_by(scensal, municipi, provincia, codi_edar, Zona, edat, sexe) %>% summarize_if(is.numeric, max, na.rm=TRUE) %>% select(scensal, municipi, 
                                                                                                                                            provincia, codi_edar,
                                                                                                                                            Zona, edat, sexe, 
                                                                                                                                            poblacio_prevalent,
                                                                                                                                            pob_real)
groups2 = groups2 %>% group_by(scensal, municipi, provincia, codi_edar, Zona) %>% summarize_if(is.numeric, sum, na.rm=TRUE)

groups = groups %>% group_by(scensal, grup_ICD10MC, municipi, provincia, codi_edar, Zona) %>%
  summarize_if(is.numeric, sum, na.rm=T) %>% select(-poblacio_prevalent, -pob_real)

groups = full_join(groups, groups2)
groups = groups %>% mutate(`prevalencia(%)`=round((casos_prevalents/poblacio_prevalent)*100, 2))
saveRDS(groups, file='~/idiap/projects/scorewater2/build.data/grups_definitius.rds')

