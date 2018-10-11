setwd("~/GitHub/vkme18")

pacman::p_load(tidyverse,broom,rio,stargazer,plm,lmtest)

#bred til lang form
widedf <- data_frame(unit=letters[1:3],yt1=c(1,3,6),yt2=c(2,6,7))

tidydf <- widedf %>% 
  gather(tidspkt,pct,2:3)

#kigger på filerne i mappen med Mutz' replikationsdata
dir("data/05_mutz")

#henter filen med paneldata
mutz06 <- import("data/05_mutz/PanelwithoutZips_F.dta") %>% 
  as_tibble()

# mutz' DV er feeling thermometer difference
# generate difftherm=reptherm-demtherm
# egen cutdifftherm= cut(difftherm), group(20)

#her er tidy-versionen af samme øvelse
mutz06<-mutz06 %>% 
  mutate(cutdifftherm=cut(reptherm-demtherm,breaks=20,labels=F),
         dem=ifelse(xparty3==3,1,0),
         id=factor(MNO))

#enkel cross-sectional model: parti, holdning til Kina og SDO (kun i 2016, dvs. wave 1)
cm1 <- lm(cutdifftherm~dem+economy+personeco+sdo,data=filter(mutz06,wave==1))
stargazer(cm1,type="text")

#panelmodel med respondent og wave fixed effects
pm1 <- plm(cutdifftherm~dem+economy+personeco+sdo,data=mutz06,index=c("id","wave"),model="within")
stargazer(pm1,type="text",omit="id")

#vi kan også se på begge ved siden af hinanden
stargazer(cm1,pm1,type="text",omit="id")

#hov, en sidste ting: vi skal bruge standardfejl clustered på individniveau (dvs. 'group')
clustervcov <- coeftest(pm1,vcovHC(pm1,cluster="group"))
clusterses <- clustervcov[,2]

#vi kigger på modellerne igen, og angiver at vi vil bruge clustered se's for panelmodellen
stargazer(cm1,pm1,type="text",se=list(NULL,clusterses))
