rm(list=ls())

library(dplyr)
library(plyr)
library(tidyr)
library(magrittr)
library(stringr)
library(rio)
library(janitor)
library(rvest)
library(httr)

consurl <- "http://www.conservapedia.com/Essay:Greatest_Conservative_Movies"
liburl <- "http://www.conservapedia.com/Essay:Worst_Liberal_Movies"

# Henter data for konservative film
cons <- GET(consurl, add_headers('user-agent' = 'University student (fmg720@alumni.ku.dk)')) # Skaffer adgang
cons <- read_html(cons)
cons_tables <- html_nodes(cons, "table")
cons_dat <- rbind(html_table(cons_tables[[1]], fill = TRUE),
                  html_table(cons_tables[[2]], fill = TRUE),
                  html_table(cons_tables[[3]], fill = TRUE),
                  html_table(cons_tables[[4]], fill = TRUE),
                  html_table(cons_tables[[5]], fill = TRUE)) %>%
  clean_names()
names(cons_dat)
dim(cons_dat)
cons_dat$political <- rep(0,nrow(cons_dat)) # Værdien 0 til alle konservative film (skal bruges senere)

# Henter data for liberale film
libs <- GET(liburl, add_headers('user-agent' = 'University student (fmg720@alumni.ku.dk)')) # Skaffer adgang
libs <- read_html(libs)
libs_tables <- html_nodes(libs, "table")
libs_dat <- rbind(html_table(libs_tables[[1]], fill = TRUE),
                  html_table(libs_tables[[2]], fill = TRUE),
                  html_table(libs_tables[[3]], fill = TRUE),
                  html_table(libs_tables[[4]], fill = TRUE),
                  html_table(libs_tables[[5]], fill = TRUE),
                  html_table(libs_tables[[6]], fill = TRUE)) %>% 
  clean_names()
names(libs_dat)
dim(libs_dat)
libs_dat$political <- rep(1,nrow(libs_dat)) # Værdien 1 til alle liberale film (skal bruges senere)

# Appender datasæt
movies <- rbind(cons_dat, libs_dat)
dim(movies)

# Renser indtægtsvariabel, tager bare det værste
movies$boxoffice <- str_replace(
  movies$gross_domestic,
  pattern = ',',
  replacement = ''
)

movies$boxoffice <- str_replace(
  movies$boxoffice,
  pattern = ',',
  replacement = ''
)


movies$boxoffice <- str_replace(
  movies$boxoffice,
  pattern =  '\\[.*\\]',
  replacement = ''
)

movies$boxoffice <- str_replace(
  movies$boxoffice,
  pattern =  '\\(.*\\)',
  replacement = ''
)

movies$boxoffice <- str_replace(
  movies$boxoffice,
  pattern =  '\\$',
  replacement = ''
)

# Resten ryger i svinget. Gem alt det numeriske i en ny variabel
movies$box <- as.numeric(movies$boxoffice)

# Sammenligner boxoffices
movies %>% 
  mutate(millions = box/1000000) %>% 
  group_by(political) %>%
  dplyr::summarize(mean_millions = mean(millions, na.rm = TRUE))

# T-test
t.test(movies$box ~ movies$political) # p = 0.016, diff. er signifikant
