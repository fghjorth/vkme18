setwd("~/GitHub/vkme18")

p_install(stargazer)
p_install(effects)
pacman::p_load(tidyverse,broom,rio,stargazer, effects,ggeffects)

# ØVELSE: Føj 'økonomi'-variable til model 2 herunder og 'status'-variable til model 3, 
# og vis som Mutz at statusvariablene kan 'dræbe' koefficienten på uddannelse (noncollegegrad).
# Det behøver ikke være helt samme model som i S5, bare samme grundlæggende resultat.
# Vis de tre modeller side om side med stargazer()-funktionen nederst.
mutz05<-import("data/05_mutz/Amerispeak2016OctForReplication.dta") %>% 
  as_tibble() 

#Tidy'er datasættet som Mutz do-file
mutz05<-mutz05 %>% 
  mutate(cutdifftherm=cut(thermdiffTC,breaks=20,labels=F),
         majorsexR=majorsex*-1,
         majorindex=(majorsexR+majorrelig+majorrace)/3)

#Laver model 1
s5m1<-lm(cutdifftherm~party3+noncollegegrad+white+GENDER+AGE7+religion+INCOME,data=mutz05)

#Øvelse første del: Tilføj variablene: "Looking for work", "Concern about future expenses", "Perceptions of family finances (better)","support safety net", "Area median income", "Area unemployed", "Area manufacturing". OBS: mangler de sidste to variable. 
s5m2<-lm(cutdifftherm~party3+noncollegegrad+white+GENDER+AGE7+religion+INCOME+lookwork+ecoworry+ecoperc+safetynet+medianincome,data=mutz05)
s5m3<-lm(cutdifftherm~party3+noncollegegrad+white+GENDER+AGE7+religion+INCOME+majorindex+pt4r+sdoindex+prejudice+isoindex+china+immigindex+tradeindex,data=mutz05)

stargazer(s5m1,s5m2,s5m3,type="text",digits=2, style = "apsr")

#Mislykket forsøg på visualisering af effekerne
#Får fitted values
augmented_s5m1 <- augment(s5m1)
augmented_s5m2 <- augment(s5m2)
augmented_s5m3 <- augment(s5m3)

glimpse(augmented_s5m2)

#plotter cutdifftherm som funktion af indkomst og tilføjer fitted values linje. 
plot2 <- ggplot(augmented_s5m2, aes(x = INCOME, y = cutdifftherm, colour = white)) + 
  geom_point(position = "jitter", alpha = 0.4) + scale_x_continuous(limits = c(1,20)) + scale_y_continuous(limits = c(-50,50))
plot2 + 
  geom_line(aes(y = .fitted))

glimpse(augmented_s5m3)

#plotter cutdifftherm som funktion af major index og tilføjer fitted values linje.
plot3 <- ggplot(augmented_s5m3, aes(x = majorindex, y = cutdifftherm, color = white)) + 
  geom_point(position = "jitter", alpha = 0.4) + scale_x_continuous(limits = c(1,5)) + scale_y_continuous(limits = c(0,30))
plot3 + geom_line(aes(y = .fitted))

#alternativ (FH): predictions med ggeffects::ggpredict()
preds_income <- ggpredict(s5m2,"INCOME") 

%>% mutate(var="Income")
preds_majindx <- ggpredict(s5m3,"majorindex") %>% mutate(var="Majorindex")

preds <- bind_rows(preds_income,preds_majindx)
preds <- bind_rows(preds_income,preds_majindx)
preds <- bind_rows(preds_income,preds_majindx)
preds <- bind_rows(preds_income,preds_majindx)
preds <- bind_rows(preds_income,preds_majindx)
preds <- bind_rows(preds_income,preds_majindx)
preds <- bind_rows(preds_income,preds_majindx)
preds <- bind_rows(preds_income,preds_majindx)
preds <- bind_rows(preds_income,preds_majindx)
preds <- bind_rows(preds_income,preds_majindx)
preds <- bind_rows(preds_income,preds_majindx)
preds <- bind_rows(preds_income,preds_majindx)
preds <- bind_rows(preds_income,preds_majindx)
preds <- bind_rows(preds_income,preds_majindx)
preds <- bind_rows(preds_income,preds_majindx)

ggplot(preds_income,aes(x=x,y=predicted,ymin=conf.low,ymax=conf.high)) +
  geom_line() +
  geom_ribbon(alpha=.2) +
  theme_bw()

skrive et eller andet
skrive et eller andet
skrive et eller andet
skrive et eller andet
skrive et eller andet

