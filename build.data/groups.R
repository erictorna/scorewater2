library(tidyverse)
library(lubridate)
library(dplyr)
library(data.table)

groups = readRDS("/home/idiap/projects/scorewater2/build.data/groupsreals.rds")

groups = groups %>% group_by(scensal, grup_ICD10MC, municipi, provincia, codi_edar, Zona) %>%
  summarize_if(is.numeric, sum, na.rm=T)

groups = groups %>% select(scensal, grup_ICD10MC, municipi, provincia, codi_edar, Zona, 
                                   casos_prevalents, poblacio_prevalent, pob_real)

groups = groups %>% mutate(`prevalencia(%)`=round((casos_prevalents/poblacio_prevalent)*100, 2))
saveRDS(groups, file='~/idiap/projects/scorewater2/build.data/grups_definitius.rds')