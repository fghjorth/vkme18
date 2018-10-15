setwd("~/GitHub/vkme18")

pacman::p_load(tidyverse,readxl)

dir("data")

oecd <- read_excel("data/06_oecdtable.xlsx",skip=5) %>% 
  slice(-1) %>% #fjern tom række
  slice(-36) %>% #fjern fodnoterække
  select(-2) %>% #fjern tom kolonne
  gather(year,migration,2:18) %>% #tidy
  mutate(year=as.numeric(year),migration=as.numeric(migration)) %>% #konverter til numerisk
  rename(country=Year) #omdøb kolonne
  
ggplot(oecd,aes(x=year,y=migration,group=country,color=country)) +
  geom_line() +
  scale_color_viridis_d() +
  theme_minimal()