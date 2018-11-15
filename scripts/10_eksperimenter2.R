setwd("~/GitHub/vkme18")

pacman::p_load(tidyverse,randomizr,stargazer,broom)

### BLOCKING

#simuler data hvor blocking er meget relevant
#eksempel: vi treater folk med HCA-eventyr og tester holdning til HCA (y), men et subset af samplen er fynboere med markant højere y
set.seed(123456)
samplesize<-50
simdat<-data_frame(fynbo=sample(0:1,samplesize,replace=T,prob=c(.9,.1)),
                   ypre=rnorm(samplesize,mean=5)+20*fynbo,
                   simpletreat=sample(0:1,samplesize,replace=T),
                   noise=rnorm(samplesize))

simdat<-simdat %>% 
  mutate(blocktreat=block_ra(fynbo),
         ypost_simple=ypre + 1*simpletreat+noise,
         ypost_block=ypre + 1*blocktreat+noise)

#tjek at der er skævhed i assignment
table(simdat$fynbo,simdat$simpletreat)
table(simdat$fynbo,simdat$blocktreat)

#se på modeller
simplelm <- lm(ypost_simple~simpletreat+fynbo,data=simdat)
blocklm <- lm(ypost_block~blocktreat+fynbo,data=simdat)

stargazer(simplelm,blocklm,type="text")

### NONCOMPLIANCE

#indlæs data
ggd<-read_csv("data/10_gg.csv")

#overblik over data
glimpse(ggd)

#begræns data til one-person households i kontrol eller canvas
ggd<-filter(ggd,onetreat==1 & mailings==0 & phongotv==0 & persons==1)

#ift. bogen:
# VOTED hedder her v98
# ASSIGNED hedder her persngrp
# TREATED hedder her cntany

#omdøb variable så de svarer til eksemplet i bogen s. 158-159
ggd <- ggd %>% 
  transmute(VOTED=v98,
            ASSIGNED=persngrp,
            TREATED=cntany)

#model for ITT
ittmodel<-lm(VOTED~ASSIGNED,data=ggd)
summary(ittmodel)
itt<-tidy(ittmodel)[2,2]

#model for ITTD
ittdmodel<-lm(TREATED~ASSIGNED,data=ggd)
summary(ittdmodel)
ittd<-tidy(ittdmodel)[2,2]

#beregn CACE
cace <- itt / ittd


### ØVELSER

# 1: gentag koden fra HCA-eskemplet ovenfor, og ændr på én eller flere parametre
# sådan at forskellen på simpel og blokrandomisering udviskes





# 2: koden nedenfor indlæser tabel 5.1 fra bogen.
# brug kode til at beregne ITT og CACE

ggtab51 <- read_csv("data/10_ggtab51.csv") %>% 
  mutate(tau=`Y[D=1]`-`Y[D=0]`)


