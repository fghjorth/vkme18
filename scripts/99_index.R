pacman::p_load(tidyverse,psych)

# simulerer data - for nemheds skyld antager vi alle holdninger er ukorrelerede, 
# men du er forhåbentlig lidt bedre stillet

n <- 1000
simdat <- data_frame(h1=sample(1:5,n,replace=T),
                     h2=sample(1:5,n,replace=T),
                     h3=sample(1:5,n,replace=T),
                     h4=sample(1:5,n,replace=T),
                     h5=sample(1:5,n,replace=T))

#check reliabilitet for udvalgte variable
simdat %>% 
  select(h1:h5) %>% 
  as.matrix() %>% 
  psych::alpha()

#konstruer refleksivt indeks
simdat %>% 
  select(h1:h5) %>% 
  rowMeans(.,na.rm = T) -> simdat$index

  