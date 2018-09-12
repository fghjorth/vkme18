pacman::p_load(tidyverse,gapminder,rio)

gapminder<-gapminder

## løsning 1

by_country <- group_by(gapminder, country)

country_sum <- summarize(by_country,avglifeexp=mean(lifeExp),medianpop=median(pop))

big_countries <- filter(country_sum, medianpop > 10000000)

result1 <- arrange(big_countries, desc(country), avglifeexp)

## løsning 2

result2 <-
  arrange(
    filter(
      summarize(
        group_by(gapminder,
                 country
        ),
        avglifeexp=mean(lifeExp),
        medianpop=median(pop)
      ),
      medianpop > 10000000
    ),
    desc(country),
    avglifeexp
  )

## løsning 3

result3 <- gapminder %>%
  group_by(country) %>%
  summarize(avglifeexp=mean(lifeExp),
            medianpop=median(pop)) %>% 
  filter(medianpop > 10000000) %>%
  arrange(desc(country), avglifeexp)

## øvelse

trolltweets<-import("https://github.com/fivethirtyeight/russian-troll-tweets/raw/master/IRAhandle_tweets_1.csv")
