setwd("~/GitHub/vkme18")

pacman::p_load(tidyverse,broom,rio,stargazer,haven)

#kigger på filerne i mappen med Mutz' replikationsdata
dir("data/05_mutz")

#indlæser filen med tværsnitsdata
mutz05 <- read_dta("data/Amerispeak2016OctForReplication.dta") %>% 
  as_tibble() 

#vi skal kode nogle få variable om - i Mutz' do-file ser det således ud:
# egen cutdifftherm= cut(thermdiffTC), group(20)
# 
# recode majorsex (-4=4)(-3=3)(-2=2) (-1=1)(0=0)(1=-1) ///
#   (2=-2) (3=-3) (4=-4), gen(majorsexR) ///
#   
#   generate majorindex=(majorsexR+majorrelig+majorrace)/3

#her er tidy-versionen af samme øvelse
mutz05<-mutz05 %>% 
  mutate(cutdifftherm=cut(thermdiffTC,breaks=20,labels=F),
         majorsexR=majorsex*-1,
         majorindex=(majorsexR+majorrelig+majorrace)/3)

#ols-modellen fra tabel S4
s4m1<-lm(cutdifftherm~party3+noncollegegrad+white+GENDER+AGE7+religion+
           INCOME+lookwork+ecoworry+perecoperc+safetynet+medianincome+
           #            prop_civlaborforce_unemp+prop_manuf+ #af anonymitetshensyn er disse variable desværre ikke med
           majorindex+pt4r+sdoindex+prejudice+
           isoindex+china+immigindex+tradeindex+natsupindex+
           ecoperc+terrorthreat,data=mutz05)

summary(s4m1)

#Model 1 fra Tabel S5
s5m1<-lm(cutdifftherm~party3+noncollegegrad+white+GENDER+AGE7+religion+INCOME,data=mutz05)

stargazer(s5m1,type="text",digits=2,style = "apsr")

# ØVELSE: Føj 'økonomi'-variable til model 2 herunder og 'status'-variable til model 3, 
# og vis som Mutz at statusvariablene kan 'dræbe' koefficienten på uddannelse (noncollegegrad).
# Det behøver ikke være helt samme model som i S5, bare samme grundlæggende resultat.
# Vis de tre modeller side om side med stargazer()-funktionen nederst.


s5m2<-lm(cutdifftherm~party3+noncollegegrad+white+GENDER+AGE7+religion+INCOME+lookwork+ecoworry+perecoperc+safetynet+medianincome,data=mutz05)
s5m3<-lm(cutdifftherm~party3+noncollegegrad+white+GENDER+AGE7+religion+INCOME+majorindex+pt4r+sdoindex+prejudice+isoindex+china+immigindex+tradeindex,data=mutz05)

# Modellerne har fået nogle neutrale deskriptive navne for overskuelighedens skyld
stargazer(s5m1,s5m2,s5m3,type="text",digits=2, object.names = T,
          column.labels = c("Baggrund", "Left behind", "Angry white men")) #noncollegegrad er insig i model 3



