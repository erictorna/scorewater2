library(data.table)
library(lubridate)
library(readr)
library(readODS)
library(tidyverse)
rename=dplyr::rename
# Carreguem dades
conditions <- readRDS('~/idiap/projects/scorewater2/build.data/conditions.rds')
farmacs <- readRDS('~/idiap/projects/scorewater2/build.data/farmacs.rds')
groups <- readRDS('~/idiap/projects/scorewater2/build.data/groups.rds')

# Llegim les taules amb les dades provinents de l'INE de l'any 2021 i les ajuntem totes en un unic fitxer
barcelona = read.table('~/idiap/projects/scorewater2/poblacio_BCN_2021.csv', sep='\t', header = TRUE) %>% rename(edat = Edad..grupos.quinquenales.) %>% rename(scensal=Sección)
girona = read.table('~/idiap/projects/scorewater2/poblacio_GIR_2021.csv', sep='\t', header = TRUE) %>% rename(edat = Edad..grupos.quinquenales.) %>% rename(scensal=Sección)
tarragona = read.table('~/idiap/projects/scorewater2/poblacio_TAR_2021.csv', sep='\t', header = TRUE) %>% rename(edat = Edad..grupos.quinquenales.) %>% rename(scensal=Sección)
lleida = read.table('~/idiap/projects/scorewater2/poblacio_LLE_2021.csv', sep='\t', header = TRUE) %>% rename(edat = Edad..grupos.quinquenales.) %>% rename(scensal=Sección)
# Les dades de sidiap només arriben fins a 80+ anys, aixi que tots els superiors els cambiem per aquesta categoria
catalunya = rbind(barcelona, girona, tarragona, lleida) %>% mutate(edat=ifelse(edat=='100 y más'|edat=='95-99'|edat=='90-94'|edat=='85-89'|edat=='80-84', '80+', edat))
setDT(catalunya)
# Eliminem les files que contenen dades que no ens interessen com el totals
catalunya = catalunya[edat!='Total']
catalunya = catalunya[scensal!='TOTAL']
# Sumem tots els membres de les categories 80+ generades anteriorment
catalunya$Total<-as.numeric(catalunya$Total)
catalunya = catalunya %>% group_by(Sexo, scensal, edat) %>% summarize_if(is.numeric, sum, na.rm=T)
setDT(catalunya)
# Arreglem la variable sexe
catalunya = catalunya[Sexo!='Ambos Sexos']
catalunya = catalunya %>% mutate(Sexo=ifelse(Sexo=='Hombres', 'H', 'D')) %>% rename(sexe = Sexo)

# Ajuntem dades
conditions = left_join(conditions, catalunya) %>% rename(pob_real=Total)
farmacs = left_join(farmacs, catalunya) %>% rename(pob_real=Total)
groups = left_join(groups, catalunya) %>% rename(pob_real=Total)

# I ja estaria
saveRDS(conditions, file = 'build.data/conditionsreals.rds')
saveRDS(farmacs, file = 'build.data/farmacsreals.rds')
saveRDS(groups, file = 'build.data/groupsreals.rds')
