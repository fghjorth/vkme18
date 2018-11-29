setwd("~/GitHub/vkme18")

pacman::p_load(tidyverse,stargazer)

# MIGRANT CRISIS RESPONSES

mcd <- readRDS("data/12_migrant_elecs_long.rds")

#beregnet direkte
treatpost <- mcd %>% filter(close01==1 & post01==1) %>% .$yshare %>% mean()
treatpre <- mcd %>% filter(close01==1 & post01==0) %>% .$yshare %>% mean()
ctrlpost <- mcd %>% filter(close01==0 & post01==1) %>% .$yshare %>% mean()
ctrlpre <- mcd %>% filter(close01==0 & post01==0) %>% .$yshare %>% mean()

(diffindiffs<-(treatpost-treatpre) - (ctrlpost-ctrlpre))

#med kovariater
m1 <- lm(yshare~post01*close01,data=mcd)
m2 <- lm(yshare~post01*close01+dfshare15+ownershare+edushare+immishare,data=mcd)

stargazer(m1,m2,type="text")

# ENOS 2016

ed<-read_csv("data/12_enos.csv")

#ny df ed_did kun med de variable vi skal bruge
ed_did<-ed

#vi definerer 'treat' som dummy for at bo <500yrds fra demolition site
ed_did<-mutate(ed_did,treated=ifelse(demo.distance<500,1,0))

#udvælger treated samt turnout i 2000 og 2004
ed_did<-select(ed_did,treated,vote2000,vote2004) 

#konverter fra wide til long format
ed_did<-gather(ed_did,year,turnout,vote2000:vote2004)

#ny variabel 'post' som dummy for 2004
ed_did<-mutate(ed_did,post=ifelse(year=="vote2004",1,0))

#regressionsmodel
didmodel<-lm(turnout~post*treated,data=ed_did)
summary(didmodel)

#placebo test: vi goer alt det samme, bare med nondemodistance
ed_placebotest<-ed %>% 
  mutate(treated=ifelse(nondemo.distance<500,1,0)) %>% 
  select(treated,vote2000,vote2004) %>% 
  gather(year,turnout,vote2000:vote2004) %>% 
  mutate(post=ifelse(year=="vote2004",1,0))

placebomodel<-lm(turnout~post*treated,data=ed_placebotest)
summary(placebomodel)

stargazer(didmodel,placebomodel,type="text")
