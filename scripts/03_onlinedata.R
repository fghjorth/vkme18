setwd("~/GitHub/vkme18/")

pacman::p_load(tidyverse,rvest,magrittr,janitor,stringr,textclean,rtweet)

###
# DEL 1: SCREEN SCRAPING
###

krurl<-"https://da.wikipedia.org/wiki/Konger%C3%A6kken"

#først indlæser vi websiden
kr<-read_html(krurl)

#så udtrækker vi alle tabeller fra siden
kr_tables<-html_nodes(kr,"table")
kr_tables

#det var mange tabeller :-/ ved at bruge CSS-selectoren 'wikitable' kan vi fokusere på de interessante tabeller (bemærk punktummet)
kr<-html_nodes(kr,".wikitable")
kr

#tabellerne fra 1-3 er vist dem vi skal bruge
#gemmer hver af dem som tabel og samler i een tabel (fill=T sørger for at tomme celler bare sættes som missing)
kr_all<-bind_rows(html_table(kr[[1]],fill=T),
                  html_table(kr[[2]],fill=T),
                  html_table(kr[[3]],fill=T)) %>% 
  filter(Navn!="Navn") %>% #fjerner ekstra rækker
  clean_names() #fikser variabelnavne, fra pakken janitor

#lidt ekstra trylleryl: fødsels/dødsår
kr_all<-kr_all %>% 
  mutate(byear=str_extract(født,"\\d{3,4}")) %>% #udtrækker tal med 3 eller 4 cifre
  mutate(dyear=ifelse(is.na(død),str_extract(fratrådte_død,"\\d{3,4}"),str_extract(død,"\\d{3,4}"))) %>% 
  mutate(number=row_number(),
         yrs=as.numeric(dyear)-as.numeric(byear))

#plot
ggplot(kr_all,aes(number,yrs)) +
  geom_point()

#eksempel 2: screen scraping af folketingsdebatter
#testdebateurl<-"http://webarkiv.ft.dk/Samling/19991/MENU/00449865.htm"

fttaleurl <- "http://webarkiv.ft.dk/Samling/19991/salen/R1_BEH1_3_3_263.htm"

#træk text ud af url'et
fttale <- fttaleurl %>% 
  read_html() %>% 
  html_nodes("p") %>%  
  html_text() 

#lidt extra housekeeping for at få kun den rene tekst
fttale <- fttale %>% 
  .[2:5] %>% 
  paste(.,collapse = " ") %>% 
  replace_html() %>% 
  replace_white()


###
# DEL 2: API'ER
###

key<-"xxx"
secret<-"yyy"  
create_token(app="mpdata",key,secret)

#info om udvalgt twitter-bruger: LLR
llr<-lookup_users("larsloekke")

#info om LLR
str(llr)

#hvem følger LLR? 
llr_followers<-get_followers("larsloekke",n=1000)

#find LLR's seneste 200 tweets
llrtweets<-get_timeline("larsloekke",n=200)

#kig på tweets efter emneord
dkpoltweets<-search_tweets(q="#dkpol",n=100)
