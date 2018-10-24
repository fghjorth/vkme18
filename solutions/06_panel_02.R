pacman::p_load(tidyverse, haven, lmtest, plm)
dir("Dropbox")
### ØVELSE 2 ###
### Henter data
panel_mutz <- read_stata("Dropbox/PanelwithoutZips_F.dta")
### Laver de to modeller - modellen er effekten af ens personlige økonomi på holdningen til Kina

lm_model <- lm(chinaself~personeco, data =panel_mutz)
pl_model <- plm(chinaself~personeco, index=c("MNO","wave"),model="within", data=panel_mutz) #Her 'indekseres' medlemsnummer og wave for at holde tidsinvariante elementer konstante

clustervcov <- coeftest(pl_model,vcovHC(pl_model,cluster="group")) #Der tilføjes 'clustered' standardfejl til fixed effects modellen
clusterses <- clustervcov[,2]

stargazer(lm_model,pl_model,type="text",se=list(NULL,clusterses)) #Tabellen viser, at koefficienten for personlig økonomi bliver insignifikant ved fixed effects


