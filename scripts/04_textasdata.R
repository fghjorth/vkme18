setwd("~/GitHub/vkme18")

pacman::p_load(tidyverse,readtext,quanteda,stringr,rio)

####
# TF-IDF
####

simpletexts<-c("velfærd velfærd velfærd",
               "velfærd velfærd vækst",
               "velfærd vækst vækst",
               "vækst vækst vækst")
simplecorpus<-corpus(simpletexts,docnames=c("el","s","v","la"))
simpledfm<-dfm(simpletexts)

#tf-idf
dfm_tfidf(simpledfm)

#regner efter i hånden
tf<-3
idf<- log10( 4/3 )
tf*idf

####
# DICTIONARY 
####

# 1: importer tekster
nytaars <- readtext("data/04_royal",encoding="latin1")

# 2: lav korpus
ncorp <- corpus(nytaars)

# 3: importer ordbog
afinn <- import("https://raw.githubusercontent.com/fnielsen/afinn/master/afinn/data/AFINN-da-32.txt")

posord <- afinn$V1[afinn$V2 > 0]
negord <- afinn$V1[afinn$V2 < 0]

dict <- dictionary(list(pos=posord,
                        neg=negord))

# 4: lav en dfm baseret paa ordbogen
ndfm <- dfm(ncorp,dictionary = dict) 

# 5: lav om til data frame
ndf <- quanteda::convert(ndfm,to="data.frame")

corpsummary <- ncorp %>% summary() %>% as_data_frame()

# 6: analyser ordbalance over tid
ndf <- ndf %>% 
  mutate(year=substr(document,1,4),
         balance=pos-neg) %>% 
  left_join(.,corpsummary,by=c("document"="Text")) %>% #fletter corpus summary ind så vi ved hvor mange ord der er i hver tekst 
  mutate(balanceperword=balance/Tokens)

ggplot(ndf,aes(year,balanceperword)) +
  geom_point()

ndf %>% 
  arrange(balance) %>% 
  slice(1:3)

####
# WORDSCORES: BATURO & MIKHAYLOV 
####

# 1: importer tekster
bhtxts<-readtext("data/04_bh/2011_12",encoding="windows-1251") #encoding kan estimeres med encoding()

bhtxts[1,2]
bhtxts[,1]

#definer referencevaerdier
tscores<-c(rep(NA,41),-1,rep(NA,16),1,rep(NA,33))

# 2: konstruer korpus
bhcorp<-corpus(bhtxts)

# 3: konstruer document feature matrice
bhdfm<-dfm(bhcorp,remove="\\s+",valuetype="regex")

# 4: estimer wordscores
bh_ws<-textmodel_wordscores(bhdfm,tscores)

#konstruer data frame med praedikerede wordscores
bh_ws_pred<-predict(bh_ws) 
bh_ws_df<-data_frame(text=names(bh_ws_pred),score=as.numeric(bh_ws_pred)) %>% 
  mutate(yr=as.numeric(str_extract(text,"[0-9]+")),
         province=str_extract(text,"[^_]+"))

#modeller positioner som fkt af tid
olsmodel<-lm(score~yr+province,data=bh_ws_df)
summary(olsmodel)

