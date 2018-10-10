#Henter pakker
pacman::p_load(tidyverse,readtext,quanteda,stringr,rio)

#Directory 
setwd("C:/Users/kzc744/Documents/GitHub/vkme18")

# 1: importer tekster
nytaars <- readtext("data/04_royal",encoding="latin1")

# 2: lav korpus
ncorp <- corpus(nytaars)

# 3: Ordbog: Skjulte hentydninger til danske fodboldklubber.  
fodboldordbog <- dictionary(list(VejleBoldklub = c("jeppe virøe", "vejle", "vb"), 
                                 FCMidtjylland = c("fcm", "midtjylland", "herning"),
                                 FCKøbenhavn = c("fck", "hovedstaden", "københavn"), 
                                 AaB = c("danmarks paris","aab", "aalborg"),
                                 EsbjergfB = c("esbjerg", "efb"),
                                 AGF = c("aarhus", "smilets by", "agf"),
                                 Brøndby = c("brøndby", "vestegnen", "bif"),
                                 ACHorsens = c("horsens", "ach"), 
                                 FCNordsjælland = c("peter brixtofte", "farum", "fcn"), 
                                 Sønderjyske = c("ringridning", "sønderjylland", "haderslev"), 
                                 RandersFC = c("mokai", "randers", "rfc"), 
                                 OB = c("h.c. andersen", "odense", "ob"), 
                                 Vendsyssel = c("thy", "vendsyssel", "vff", "skagen"), 
                                 HobroIK = c("quincy antipas", "hobro", "hik")))

#Laver en dfm på baggrund af den store fodbold ordbog
fodbolddfm <- dfm(ncorp,dictionary = fodboldordbog) 

# 5: lav om til data frame
fodbolddf <- quanteda::convert(fodbolddfm,to="data.frame")

#Udregn frekvens - Jeppe er ikke nævnt en eneste gang i hele 72 taler 
frekvens <- colSums(fodbolddf != 0)
frekvens

# 6: plot frekvenser over tid (FH)
fodbolddf_tidy <- fodbolddf %>% 
  mutate(yr=as.numeric(substr(document,1,4))) %>% 
  select(-document) %>% 
  gather(Klub,Omtaler,1:14)

ggplot(fodbolddf_tidy,aes(x=yr,y=Omtaler,group=Klub,color=Klub)) +
  geom_line() +
  scale_color_viridis_d() +
  theme_minimal()