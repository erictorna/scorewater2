library(data.table)
library(lubridate)
library(readr)
library(readODS)
library(tidyverse)
library(dplyr)
rename = dplyr::rename
# Carreguem dades
conditions <- readRDS('~idiap/data/scorewater/scorewater2/SCOREwater_entregable_conditions_20221201.rds')
farmacs <- readRDS('~idiap/data/scorewater/scorewater2/SCOREwater_entregable_farmacs_20221201.rds')
groups <- readRDS('~idiap/data/scorewater/scorewater2/SCOREwater_entregable_grups_ICD10MC_20221201.rds')
barrisbesos=read_rds("/home/idiap/projects/scorewater/seccions_censals_barris.rds") %>% select(Zona, Sc2020) %>% rename(scensal=Sc2020) %>% unique()

# Per cada arxiu afegim un 0 davant dels codis censals curts i marquem quins d'ells pertanyen als barris de BCN-besos d'interès
setDT(conditions)
conditions$scensal = stringr::str_pad(conditions$scensal, 10, side = "left", pad = 0)
conditions$cm<-NULL
conditions$ip2011<-NULL
conditions = left_join(conditions, barrisbesos)

setDT(farmacs)
farmacs$scensal = stringr::str_pad(farmacs$scensal, 10, side = "left", pad = 0)
farmacs$cm<-NULL
farmacs$ip2011<-NULL
farmacs = left_join(farmacs, barrisbesos)

setDT(groups)
groups$scensal = stringr::str_pad(groups$scensal, 10, side = "left", pad = 0)
groups$cm<-NULL
groups$ip2011<-NULL
groups = left_join(groups, barrisbesos)

saveRDS(conditions, file = 'build.data/conditions.rds')

saveRDS(farmacs, file = 'build.data/farmacs.rds')

saveRDS(groups, file = 'build.data/groups.rds')
