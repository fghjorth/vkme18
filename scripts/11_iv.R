setwd("~/GitHub/vkme18")

pacman::p_load(tidyverse,haven,estimatr,stargazer)

cs <- read_dta("data/11_colantonestanig.dta")

# normal ols
# reg leave_share import_shock i.nuts1, cluster(nuts2)
olsmodel<-lm_robust(leave_share ~ import_shock + factor(nuts1), data = cs, clusters = factor(nuts2), se_type = "stata")

# iv regression
# ivreg2 leave_share (import_shock=instrument_for_shock) i.nuts1, cluster(nuts2) 

ivmodel <- iv_robust(leave_share ~ import_shock + factor(nuts1) |  instrument_for_shock + factor(nuts1), 
                     clusters = factor(nuts2), data=cs, se_type = "stata")

# stargazer spiser ikke estimatr-output direkte, så vi definerer et lm-objekt og indlæser koefficienter og standardfejl 
# fra de rigtige modeller i stargazer-kommandoen
lmmodel <- lm(leave_share ~ import_shock + factor(nuts1), data = cs)

stargazer(lmmodel,lmmodel,
          coef = list(olsmodel$coefficients,ivmodel$coefficients),
          se=list(olsmodel$std.error,ivmodel$std.error),
          type = "text",omit = "factor",
          column.labels = c("OLS","IV"))

# ØVELSE: estimer model 4 og 6 fra Tabel 1