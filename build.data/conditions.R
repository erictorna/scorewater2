library(tidyverse)
library(lubridate)
library(dplyr)
library(data.table)

conditions = readRDS("/home/idiap/projects/scorewater2/build.data/conditionsreals.rds")

conditions = conditions %>% group_by(scensal, condicio, municipi, provincia, codi_edar, Zona) %>%
  summarize_if(is.numeric, sum, na.rm=T)

conditions = conditions %>% select(scensal, condicio, municipi, provincia, codi_edar, Zona, 
                                   casos_prevalents, poblacio_prevalent, pob_real)

conditions = conditions %>% mutate(`prevalencia(%)`=round((casos_prevalents/poblacio_prevalent)*100, 2))
saveRDS(conditions, file='~/idiap/projects/scorewater2/build.data/prevalencia_conditions.rds')
