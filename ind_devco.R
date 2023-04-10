library(readr)
library(readxl)
library(dplyr)
library(ggplot2)
library(tidyr)
library(srvyr)
library(unhcRstyle)
library(survey)
library(stringr)

main3 <- 
  read_csv2("C:/Users/PONCECOL/OneDrive - UNHCR/UNHCR_PAPC/RMS sept2022/Análisis/main.csv")


### Costa ----------

dfc <- main3 %>% filter(PROVINCE=="manabi" |
                          PROVINCE=="guayas" |
                          PROVINCE=="santaelena" |
                          PROVINCE=="losrios" |
                          PROVINCE=="eloro")

dfc <- dfc %>% mutate(llegada=str_sub(REF10a, 1, 4)) %>% 
  filter(llegada != 2022)

dfc <- dfc %>% select("PROVINCE", "llegada", "_index", "_parent_index", "weights", 
                      "DWA01", "LIGHT03", "DISCRIMINATED")

aux_ind <- 
  read_csv2("C:/Users/PONCECOL/OneDrive - UNHCR/UNHCR_PAPC/RMS sept2022/Análisis/ind.csv")

#aux_ind$hhnumb <- aux_ind$'_parent_index'
#aux_ind$penumb <- aux_ind$'_index'

aux_ind2 <- aux_ind %>%
  group_by(hhnumb) %>% 
  summarise(mat=sum(ifelse(EDU01_Enroll==1,1,0), na.rm = TRUE),
            doc=sum(ifelse(estatus_migratorio<=4,1,0), na.rm = TRUE))

aux_ind3 <- aux_ind2 %>% ungroup %>% 
  rename("_parent_index" = hhnumb) 

dfc <- inner_join(dfc, aux_ind3, by="_parent_index")

dfc <- dfc %>%
  mutate(ind_1 = case_when(DWA01 %in% c(1,2) & LIGHT03==2 & mat>0 & 
        doc>0 ~ 1,
     TRUE ~ 0))

dfc <- dfc %>%
  mutate(ind_2 = case_when(DWA01 %in% c(1,2) & LIGHT03==2 & mat>0 ~ 1,
                           TRUE ~ 0))

table(dfc$DISCRIMINATED)

### Pichincha ----------

dfcp <- main3 %>% filter(PROVINCE=="pichincha" |
                           PROVINCE=="tungurahua" |
                           PROVINCE=="chimborazo" |
                           PROVINCE=="cotopaxi" |
                           PROVINCE=="azuay" |
                           PROVINCE=="loja" |
                           PROVINCE=="santodomingodelostsachilas")

dfcp <- dfcp %>% mutate(llegada=str_sub(REF10a, 1, 4)) %>% 
  filter(llegada != 2022)

dfcp <- dfcp %>% select("PROVINCE", "llegada", "_index", "_parent_index", "weights", 
                      "DWA01", "LIGHT03", "DISCRIMINATED")

dfcp <- inner_join(dfcp, aux_ind3, by="_parent_index")

dfcp <- dfcp %>%
  mutate(ind_1 = case_when(DWA01 %in% c(1,2) & LIGHT03==2 & mat>0 & 
                             doc>0 ~ 1,
                           TRUE ~ 0))

dfcp <- dfcp %>%
  mutate(ind_2 = case_when(DWA01 %in% c(1,2) & LIGHT03==2 & mat>0 ~ 1,
                           TRUE ~ 0))


table(dfcp$DISCRIMINATED)

### survey calculations ---------

svy.dat.2 <- svydesign(ids=~1, data=dfc, weights=dfc$weights)

svytable(~dfc$ind_2, design=svy.dat.2) %>% table()

svy.dat.3 <- svydesign(ids=~1, data=dfcp, weights=dfcp$weights)

svytable(~dfcp$ind_2, design=svy.dat.3) %>% table()

