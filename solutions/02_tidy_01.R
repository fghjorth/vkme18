rm(list=ls())

library(foreign)
library(tidytext)
library(dplyr)
library(plyr)
library(ggplot2)
library(devtools)
library(tidyr)
library(magrittr)
library(stringr)
library(lubridate)
library(rio)

# SPM 1
trolltweets <- import("https://github.com/fivethirtyeight/russian-troll-tweets/raw/master/IRAhandle_tweets_1.csv")
names(trolltweets)
head(trolltweets)

# SPM 2
table(trolltweets$language)
trolltweets %>% 
  dplyr::count(language) %>%
  arrange(desc(n))

# SPM 3
table(trolltweets$region)
trolltweets %>% 
  group_by(region) %>% 
  dplyr::summarize(fo = sum(followers)) %>% 
  arrange(desc(fo))

# SPM 4
trolltweets %>% 
  group_by(language) %>% 
  dplyr::summarize(re = sum(retweet)) %>% 
  arrange(desc(re))

# SPM 5
trolltweets %>% 
  dplyr::summarize(donald = sum(str_count(content, pattern = "Trump|trump")))

trolltweets %>% 
  dplyr::summarize(hillary = sum(str_count(content, pattern = "Clinton")))
