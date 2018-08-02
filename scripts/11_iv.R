setwd("~/GitHub/vkme18")

pacman::p_load(tidyverse,haven,estimatr,ivpack)

cs <- read_dta("data/11_colantonestanig.dta")

# normal ols
# reg leave_share import_shock i.nuts1, cluster(nuts2)
olsmodel<-lm_robust(leave_share ~ import_shock + factor(nuts1), data = cs, clusters = factor(nuts2), se_type = "stata")

summary(olsmodel)

# iv regression
# ivreg2 leave_share (import_shock=instrument_for_shock) i.nuts1, cluster(nuts2) 

ivmodel <- ivreg(leave_share ~ import_shock + factor(nuts1) |  instrument_for_shock + factor(nuts1) , data=cs)

cluster.robust.se(ivmodel,factor(cs$nuts2))
