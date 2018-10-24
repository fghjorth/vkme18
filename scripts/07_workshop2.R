setwd("~/GitHub/vkme18")

pacman::p_load(tidyverse,haven,labelled,stargazer,ggeffects,readxl,janitor)

## TIDYING AF REGNEARK

roster_raw <- read_excel("data/07_dirty_data.xlsx") # available at http://github.com/sfirke/janitor
glimpse(roster_raw)

roster <- roster_raw %>%
  clean_names() %>%
  remove_empty(c("rows", "cols")) %>%
  mutate(hire_date = excel_numeric_to_date(hire_date),
         cert = coalesce(certification, certification_1)) %>% # from dplyr
  select(-certification, -certification_1) # drop unwanted columns

## OMKODNING 

iris

iris <- iris %>% 
  mutate(laengdedummy=ifelse(Petal.Length>4,1,0),
         type=case_when(Species=="setosa" ~ "a",
                        Species=="versicolor" ~ "b",
                        TRUE ~ NA_character_))

## VISUALISERING

p1 <- ggplot(data = iris, aes(x = Petal.Length, y = Petal.Width))
p1

p2 <- p1 + geom_point(aes(color = Species))
p2

p3 <- p2 + geom_smooth(method='lm')
p3

p4 <- p3 + xlab("Petal Length (cm)") + ylab("Petal Width (cm)") + ggtitle("Petal Length versus Petal Width")
p4

## ØVELSE

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