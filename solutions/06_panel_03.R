# Tilføjer 'chinaself' i begge
cm2 <- lm(cutdifftherm~dem+economy+personeco+sdo+chinaself,data=filter(mutz06,wave==1))
stargazer(cm2,type="text")

pm2 <- plm(cutdifftherm~dem+economy+personeco+sdo+chinaself,data=mutz06,index=c("id","wave"),model="within")
stargazer(pm2,type="text",omit="id")

clustervcov <- coeftest(pm2,vcovHC(pm2,cluster="group"))
clusterses2 <- clustervcov[,2]

stargazer(cm1,pm1,cm2,pm2,type="text",se=list(NULL,clusterses1,NULL,clusterses2), out = "textable.tex")
