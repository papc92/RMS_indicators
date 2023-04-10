clear all
set more off
pause off

cd "C:\Users\PONCECOL\Downloads"

use rms_main.dta, clear

drop region

gen region=.
replace region=1 if PROVINCE == "esmeraldas" | PROVINCE ==  "carchi" | PROVINCE == "imbabura" | PROVINCE == "sucumbios" | PROVINCE == "orellana"
replace region=2 if PROVINCE == "pichincha" | PROVINCE == "santodomingodelostsachilas" | PROVINCE == "cotopaxi" | PROVINCE == "chimborazo" | PROVINCE == "tungurahua" 
replace region=3 if PROVINCE == "manabi" | PROVINCE == "losrios" | PROVINCE == "guayas" | PROVINCE == "santaelena" | PROVINCE == "eloro" | PROVINCE == "azuay" | PROVINCE == "loja" | PROVINCE == "zamorachinchipe"

gen aux_ciu=substr(city_other,1,5)

replace region=2 if (aux_ciu=="MORON" | aux_ciu=="NAPO" | aux_ciu=="NAPO," | aux_ciu=="Puyo") & PROVINCE=="98"
replace region=3 if (aux_ciu=="AZOGU" | aux_ciu=="CAÑA" | aux_ciu=="LA TR") & PROVINCE=="98"

clonevar idindivi = Intro02_1

rename _merge merge_sample_child

duplicates tag idindivi, gen(dup)

replace idindivi="797-00642920a" if idindivi=="797-00642920" & HH01==8
replace idindivi="797-00642920b" if idindivi=="797-00642920" & HH01==4
replace idindivi="797-00653552a" if idindivi=="797-00653552" & HH01==5
replace idindivi="797-00653552b" if idindivi=="797-00653552" & HH01==4


merge 1:1 idindivi using "C:\Users\PONCECOL\Downloads\aux_cambiosNAC_less15.dta", keepus(nacionalidadbase nacionalidadrespondida)

gen aux=1 if nacionalidadbase =="Venezolana" & nacionalidadrespondida=="Colombiana" & _merge==3
replace aux=2 if nacionalidadbase =="Venezolana" & nacionalidadrespondida=="Ecuatoriana" & _merge==3
replace aux=3 if nacionalidadbase =="Colombiana" & nacionalidadrespondida=="Venezolana" & _merge==3
replace aux=4 if nacionalidadbase =="Colombiana" & nacionalidadrespondida=="Ecuatoriana" & _merge==3
replace aux=5 if nacionalidadbase =="Colombiana" & nacionalidadrespondida=="Otra" & _merge==3

replace REF02=2 if aux==1 | aux==2
replace REF02=1 if aux==3 | aux==4 | aux==5

*br HH04 idindivi region if nacionalidadbase=="Venezolana" & nacionalidadrespondida=="Colombiana"

*replace weights=84.8622 if idindivi=="797-00615628"
*replace weights=359.8307 if idindivi=="797-00634467"
 
replace HH04=2 if idindivi=="797-00559470"
replace HH04=1 if idindivi=="797-00602304"
replace HH04=2 if idindivi=="797-00626800"
replace HH04=2 if idindivi=="797-00635710"
replace HH04=1 if idindivi=="797-00291867"
replace HH04=1 if idindivi=="797-00376862"
replace HH04=2 if idindivi=="797-00447229"
replace HH04=2 if idindivi=="797-00547381"
replace HH04=1 if idindivi=="797-00606228"
replace HH04=2 if idindivi=="797-00607492"
replace HH04=2 if idindivi=="797-00635914"
replace HH04=1 if idindivi=="797-00656793"
 
 
gen weights=.

replace weights=33.9164 if REF02==1 & HH04==1 & region==1 & merge_sample_child==1
replace weights=13.9630 if REF02==1 & HH04==1 & region==2 & merge_sample_child==1
replace weights=6.8992  if REF02==1 & HH04==1 & region==3 & merge_sample_child==1
replace weights=157.1267 if REF02==2 & HH04==1 & region==1 & merge_sample_child==1
replace weights=178.1069 if REF02==2 & HH04==1 & region==2 & merge_sample_child==1
replace weights=240.5987 if REF02==2 & HH04==1 & region==3 & merge_sample_child==1


replace weights=69.9034 if REF02==1 & HH04==2 & region==1 & merge_sample_child==1
replace weights=12.9650 if REF02==1 & HH04==2 & region==2 & merge_sample_child==1
replace weights=14.7246 if REF02==1 & HH04==2 & region==3 & merge_sample_child==1
replace weights=485.8928 if REF02==2 & HH04==2 & region==1 & merge_sample_child==1
replace weights=354.3329 if REF02==2 & HH04==2 & region==2 & merge_sample_child==1
replace weights=325.2038 if REF02==2 & HH04==2 & region==3 & merge_sample_child==1


replace weights=13.9500 if REF02==1 & HH04==1 & region==1 & merge_sample_child==3
replace weights=14.9549 if REF02==1 & HH04==1 & region==2 & merge_sample_child==3
replace weights=9.3884  if REF02==1 & HH04==1 & region==3 & merge_sample_child==3
replace weights=84.8622  if REF02==2 & HH04==1 & region==1 & merge_sample_child==3
replace weights=186.0981 if REF02==2 & HH04==1 & region==2 & merge_sample_child==3
replace weights=174.1418 if REF02==2 & HH04==1 & region==3 & merge_sample_child==3


replace weights=82.0128 if REF02==1 & HH04==2 & region==1 & merge_sample_child==3
replace weights=24.6010 if REF02==1 & HH04==2 & region==2 & merge_sample_child==3
replace weights=29.3972 if REF02==1 & HH04==2 & region==3 & merge_sample_child==3
replace weights=372.4482 if REF02==2 & HH04==2 & region==1 & merge_sample_child==3
replace weights=359.8307 if REF02==2 & HH04==2 & region==2 & merge_sample_child==3
replace weights=810.2953 if REF02==2 & HH04==2 & region==3 & merge_sample_child==3

replace weights=. if region==. | REF02>2


bysort idindivi: gen w_roster=weights/HH01
ex

preserve
	*keep region weights w_roster _index
	keep HH04 REF02 merge_sample_child region weights w_roster _index
	save rms_weights.dta, replace
restore

*===========================================================================================*

clear
import excel "RMS_Ecuador_-_Septiembre_2022_-_all_versions_-_False_-_2022-11-13-20-57-33.xlsx", sheet("S1") firstrow

rename _index _roster_index
clonevar _index=_parent_index

merge m:1 _index using rms_hh.dta
drop _merge

merge m:1 Intro02_1 HH01 using rms_weights.dta, keepus(w_roster)

drop _index
rename _roster_index _index

preserve
	keep Intro02 Intro02_1 HH01 w_roster _parent_index _index
	save rms_ind_weights.dta, replace
restore





