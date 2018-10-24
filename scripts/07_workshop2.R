setwd("~/GitHub/vkme18")

pacman::p_load(tidyverse,haven,labelled,stargazer,ggeffects)

essgen <- read_dta("data/07_ESS8GB.dta")
esscs <- read_dta("data/07_ESS8GB_cs.dta")

#join in country-specific vars
ess<-essgen %>% 
  left_join(.,esscs,by="idno") 

#look at variables
var_label(ess$imueclt) ; val_labels(ess$imueclt)
var_label(ess$eurefvt) ; val_labels(ess$eurefvt)
var_label(ess$euvthow) ; val_labels(ess$euvthow)
var_label(ess$euvtifno) ; val_labels(ess$euvtifno)

#recode
ess <- ess %>% 
  mutate(immsenrich=ifelse(imueclt<11,imueclt,NA),
         leavevote=case_when(euvthow==2 ~ 1,
                             euvthow==1 ~ 0,
                             euvtifno==2 ~ 1,
                             euvtifno==1 ~ 0,
                             TRUE ~ NA_real_))

#fit model
m1 <- glm(leavevote~immsenrich,data=ess,family="binomial")
stargazer(m1,type="text")

#get predictions
m1preds <- ggpredict(m1,"immsenrich")

#visualize
ggplot(m1preds,aes(x=x,y=predicted,ymin=conf.low,ymax=conf.high)) +
  geom_ribbon(alpha=.3) +
  geom_line() +
  theme_minimal() +
  labs(x="Immigrants enrich culture",y="Pr(vote Leave)")