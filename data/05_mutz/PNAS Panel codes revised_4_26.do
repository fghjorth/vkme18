
generate difftherm=reptherm-demtherm

  */ by wave interactions/*

generate pretradeselfwave=pretradeself*wave
generate prelookingforworkwave=prelookingforwork*wave
generate prepersonecowave=prepersoneco*wave
generate preproimmselfwave=preproimmself*wave
generate prechinaselfwave=prechinaself*wave
generate preeconomywave=preeconomy*wave
generate presdowave=sdoscale10*wave
generate pretradediffdemwave =pretradediffdem*wave
generate preimmdiffdemwave=preimmdiffdem*wave
generate prechinadiffdemwave=prechinadiffdem*wave
generate pretradediffrepwave =pretradediffrep*wave
generate preimmdiffrepwave=preimmdiffrep*wave
generate prechinadiffrepwave=prechinadiffrep*wave
generate newacs_medianinc=acs_medianinc/1000
generate acsincomewave =newacs_medianinc*wave
generate acsunemplwave = acs_unemploy*wave
generate acsmfgwave = acs_mfg*wave
generate pretradeperwave=pretradeper*wave
generate prexparty3wave=prexparty3*wave
generate preincomewave=preincome*wave

xtset MNO wave
egen cutdifftherm= cut(difftherm), group(20)


 /*Table 1 analyses*/
 
 
xtreg cutdifftherm xparty3 income lookingforwork personeco tradeper ///
    tradeself proimmself chinaself ///
 	tradediffdem immdiffdem chinadiffdem  ///
  	tradediffrep immdiffrep chinadiffrep ///
   	sdo  economy ///
 	prexparty3wave preincomewave prelookingforworkwave prepersonecowave pretradeperwave ///
 	pretradeselfwave   preproimmselfwave  prechinaselfwave ///
 	pretradediffdemwave  preimmdiffdemwave prechinadiffdemwave ///
 	pretradediffrepwave  preimmdiffrepwave prechinadiffrepwave ///
 	presdowave preeconomywave acsunemplwave acsmfgwave acsincomewave ///
    wave , fe 
 
 
drop if voted2016==0
logit demrepvote xparty3 income lookingforwork personeco tradeper ///
    tradeself proimmself chinaself ///
 	tradediffdem immdiffdem chinadiffdem  ///
 	tradediffrep immdiffrep chinadiffrep ///
  	sdo  economy ///
 	prexparty3wave preincomewave prelookingforworkwave prepersonecowave pretradeperwave ///
 	pretradeselfwave   preproimmselfwave  prechinaselfwave ///
 	pretradediffdemwave  preimmdiffdemwave prechinadiffdemwave ///
 	pretradediffrepwave  preimmdiffrepwave prechinadiffrepwave ///
 	presdowave preeconomywave acsunemplwave acsmfgwave acsincomewave ///
    wave, cluster(MNO) 



/*new code for the predicted probabilities of demrepvote*/
/* Results for Figures 1 and 2, and Tables S1 and S2
/*over-time mean change 
	drop _merge 
	drop if wave==.
	reshape wide reptherm-cutdifftherm, i(MNO) j(wave)
	
	ttest xparty31== xparty30
	ttest tradediffdem1== tradediffdem0
	ttest immdiffdem1== immdiffdem0
	ttest chinadiffdem1== chinadiffdem0
	ttest tradediffrep1== tradediffrep0
	ttest immdiffrep1== immdiffrep0
	ttest chinadiffrep1== chinadiffrep0
	ttest sdo1==sdo0

/*Back to long form 
	logit demrepvote xparty3 income lookingforwork personeco tradeper ///
    	tradeself proimmself chinaself ///
 		tradediffdem immdiffdem chinadiffdem  ///
 		tradediffrep immdiffrep chinadiffrep ///
  		sdo  economy ///
 		prexparty3wave preincomewave prelookingforworkwave prepersonecowave pretradeperwave ///
 		pretradeselfwave   preproimmselfwave  prechinaselfwave ///
 		pretradediffdemwave  preimmdiffdemwave prechinadiffdemwave ///
 		pretradediffrepwave  preimmdiffrepwave prechinadiffrepwave ///
 		presdowave preeconomywave acsunemplwave acsmfgwave acsincomewave ///
    	wave, cluster(MNO) 

/*Changes in the predicted probabilities of demrepvote based on over time change
/*in the variable of interest at a time while holding everything else at their wave0 means 
	sum income lookingforwork personeco tradeper ///
		tradeself proimmself chinaself economy ///
		prexparty3wave preincomewave prelookingforworkwave prepersonecowave pretradeperwave ///
 		pretradeselfwave   preproimmselfwave  prechinaselfwave ///
 		pretradediffdemwave  preimmdiffdemwave prechinadiffdemwave ///
 		pretradediffrepwave  preimmdiffrepwave prechinadiffrepwave ///
 		presdowave preeconomywave acsunemplwave acsmfgwave acsincomewave  if wave==0

/*for xparty3
quietly logit demrepvote xparty3 income lookingforwork personeco tradeper ///
    tradeself proimmself chinaself ///
 	tradediffdem immdiffdem chinadiffdem  ///
 	tradediffrep immdiffrep chinadiffrep ///
  	sdo  economy ///
 	prexparty3wave preincomewave prelookingforworkwave prepersonecowave pretradeperwave ///
 	pretradeselfwave   preproimmselfwave  prechinaselfwave ///
 	pretradediffdemwave  preimmdiffdemwave prechinadiffdemwave ///
 	pretradediffrepwave  preimmdiffrepwave prechinadiffrepwave ///
 	presdowave preeconomywave acsunemplwave acsmfgwave acsincomewave ///
    wave, cluster(MNO) 

  	margins, at(xparty3=(2.073 2.036) ///
		income=11.400  lookingforwork=.056  personeco=2.829  tradeper=2.626 ///
		tradeself=3.829 proimmself=3.702 chinaself=3.184 ///
		tradediffdem=1.195 immdiffdem=2.328 chinadiffdem=1.726  ///
		tradediffrep=1.192 immdiffrep=2.124 chinadiffrep=1.691  ///
		sdo=3.773  economy=2.807 ///
		prexparty3wave=0 preincomewave=0 prelookingforworkwave=0 prepersonecowave=0 pretradeperwave=0 ///
		pretradeselfwave=0 preproimmselfwave=0 prechinaselfwave=0 ///
		pretradediffdemwave=0 preimmdiffdemwave=0 prechinadiffdemwave=0 ///
 		pretradediffrepwave=0  preimmdiffrepwave=0 prechinadiffrepwave=0 ///
		presdowave=0 preeconomywave=0 acsunemplwave=0  acsmfgwave=0 acsincomewave=0 ///
		wave=0) post 
	nlcom (diff: _b[2._at] - _b[1._at])   
 
/*for tradediffdem
quietly logit demrepvote xparty3 income lookingforwork personeco tradeper ///
    tradeself proimmself chinaself ///
 	tradediffdem immdiffdem chinadiffdem  ///
 	tradediffrep immdiffrep chinadiffrep ///
  	sdo  economy ///
 	prexparty3wave preincomewave prelookingforworkwave prepersonecowave pretradeperwave ///
 	pretradeselfwave   preproimmselfwave  prechinaselfwave ///
 	pretradediffdemwave  preimmdiffdemwave prechinadiffdemwave ///
 	pretradediffrepwave  preimmdiffrepwave prechinadiffrepwave ///
 	presdowave preeconomywave acsunemplwave acsmfgwave acsincomewave ///
    wave, cluster(MNO) 
    
    margins, at(xparty3=2.073 ///
		income=11.400  lookingforwork=.056  personeco=2.829  tradeper=2.626 ///
		tradeself=3.829 proimmself=3.702 chinaself=3.184 ///
		tradediffdem=(1.195 1.916) ///
		immdiffdem=2.328 chinadiffdem=1.726  ///
		tradediffrep=1.192 immdiffrep=2.124 chinadiffrep=1.691  ///
		sdo=3.773  economy=2.807 ///
		prexparty3wave=0 preincomewave=0 prelookingforworkwave=0 prepersonecowave=0 pretradeperwave=0 ///
		pretradeselfwave=0 preproimmselfwave=0 prechinaselfwave=0 ///
		pretradediffdemwave=0 preimmdiffdemwave=0 prechinadiffdemwave=0 ///
 		pretradediffrepwave=0  preimmdiffrepwave=0 prechinadiffrepwave=0 ///
		presdowave=0 preeconomywave=0 acsunemplwave=0  acsmfgwave=0 acsincomewave=0 ///
		wave=0) post 
    nlcom (diff: _b[2._at] - _b[1._at])   

/*for immdiffdem 
quietly logit demrepvote xparty3 income lookingforwork personeco tradeper ///
    tradeself proimmself chinaself ///
 	tradediffdem immdiffdem chinadiffdem  ///
 	tradediffrep immdiffrep chinadiffrep ///
  	sdo  economy ///
 	prexparty3wave preincomewave prelookingforworkwave prepersonecowave pretradeperwave ///
 	pretradeselfwave   preproimmselfwave  prechinaselfwave ///
 	pretradediffdemwave  preimmdiffdemwave prechinadiffdemwave ///
 	pretradediffrepwave  preimmdiffrepwave prechinadiffrepwave ///
 	presdowave preeconomywave acsunemplwave acsmfgwave acsincomewave ///
    wave, cluster(MNO) 

   margins, at(xparty3=2.073 ///
		income=11.400  lookingforwork=.056  personeco=2.829  tradeper=2.626 ///
		tradeself=3.829 proimmself=3.702 chinaself=3.184 ///
		tradediffdem=1.195  ///
		immdiffdem=(2.328 2.343) ///
		chinadiffdem=1.726  ///
		tradediffrep=1.192 immdiffrep=2.124 chinadiffrep=1.691  ///
		sdo=3.773  economy=2.807 ///
		prexparty3wave=0 preincomewave=0 prelookingforworkwave=0 prepersonecowave=0 pretradeperwave=0 ///
		pretradeselfwave=0 preproimmselfwave=0 prechinaselfwave=0 ///
		pretradediffdemwave=0 preimmdiffdemwave=0 prechinadiffdemwave=0 ///
 		pretradediffrepwave=0  preimmdiffrepwave=0 prechinadiffrepwave=0 ///
		presdowave=0 preeconomywave=0 acsunemplwave=0  acsmfgwave=0 acsincomewave=0 ///
		wave=0) post 
    nlcom (diff: _b[2._at] - _b[1._at])   

/*for chinadiffdem
quietly logit demrepvote xparty3 income lookingforwork personeco tradeper ///
    tradeself proimmself chinaself ///
 	tradediffdem immdiffdem chinadiffdem  ///
 	tradediffrep immdiffrep chinadiffrep ///
  	sdo  economy ///
 	prexparty3wave preincomewave prelookingforworkwave prepersonecowave pretradeperwave ///
 	pretradeselfwave   preproimmselfwave  prechinaselfwave ///
 	pretradediffdemwave  preimmdiffdemwave prechinadiffdemwave ///
 	pretradediffrepwave  preimmdiffrepwave prechinadiffrepwave ///
 	presdowave preeconomywave acsunemplwave acsmfgwave acsincomewave ///
    wave, cluster(MNO) 

   margins, at(xparty3=2.073 ///
		income=11.400  lookingforwork=.056  personeco=2.829  tradeper=2.626 ///
		tradeself=3.829 proimmself=3.702 chinaself=3.184 ///
		tradediffdem=1.195  immdiffdem=2.328 ///
		chinadiffdem=(1.726 1.954)  ///
		tradediffrep=1.192 immdiffrep=2.124 chinadiffrep=1.691  ///
		sdo=3.773  economy=2.807 ///
		prexparty3wave=0 preincomewave=0 prelookingforworkwave=0 prepersonecowave=0 pretradeperwave=0 ///
		pretradeselfwave=0 preproimmselfwave=0 prechinaselfwave=0 ///
		pretradediffdemwave=0 preimmdiffdemwave=0 prechinadiffdemwave=0 ///
 		pretradediffrepwave=0  preimmdiffrepwave=0 prechinadiffrepwave=0 ///
		presdowave=0 preeconomywave=0 acsunemplwave=0  acsmfgwave=0 acsincomewave=0 ///
		wave=0) post 
    nlcom (diff: _b[2._at] - _b[1._at])   

/*for tradediffrep
quietly logit demrepvote xparty3 income lookingforwork personeco tradeper ///
    tradeself proimmself chinaself ///
 	tradediffdem immdiffdem chinadiffdem  ///
 	tradediffrep immdiffrep chinadiffrep ///
  	sdo  economy ///
 	prexparty3wave preincomewave prelookingforworkwave prepersonecowave pretradeperwave ///
 	pretradeselfwave   preproimmselfwave  prechinaselfwave ///
 	pretradediffdemwave  preimmdiffdemwave prechinadiffdemwave ///
 	pretradediffrepwave  preimmdiffrepwave prechinadiffrepwave ///
 	presdowave preeconomywave acsunemplwave acsmfgwave acsincomewave ///
    wave, cluster(MNO) 

  margins, at(xparty3=2.073 ///
		income=11.400  lookingforwork=.056  personeco=2.829  tradeper=2.626 ///
		tradeself=3.829 proimmself=3.702 chinaself=3.184 ///
		tradediffdem=1.195  immdiffdem=2.328 chinadiffdem=1.726   ///
		tradediffrep=(1.192 1.592) ///
		immdiffrep=2.124 chinadiffrep=1.691  ///
		sdo=3.773  economy=2.807 ///
		prexparty3wave=0 preincomewave=0 prelookingforworkwave=0 prepersonecowave=0 pretradeperwave=0 ///
		pretradeselfwave=0 preproimmselfwave=0 prechinaselfwave=0 ///
		pretradediffdemwave=0 preimmdiffdemwave=0 prechinadiffdemwave=0 ///
 		pretradediffrepwave=0  preimmdiffrepwave=0 prechinadiffrepwave=0 ///
		presdowave=0 preeconomywave=0 acsunemplwave=0  acsmfgwave=0 acsincomewave=0 ///
		wave=0) post 
    nlcom (diff: _b[2._at] - _b[1._at])   

/*for immdiffrep
quietly logit demrepvote xparty3 income lookingforwork personeco tradeper ///
    tradeself proimmself chinaself ///
 	tradediffdem immdiffdem chinadiffdem  ///
 	tradediffrep immdiffrep chinadiffrep ///
  	sdo  economy ///
 	prexparty3wave preincomewave prelookingforworkwave prepersonecowave pretradeperwave ///
 	pretradeselfwave   preproimmselfwave  prechinaselfwave ///
 	pretradediffdemwave  preimmdiffdemwave prechinadiffdemwave ///
 	pretradediffrepwave  preimmdiffrepwave prechinadiffrepwave ///
 	presdowave preeconomywave acsunemplwave acsmfgwave acsincomewave ///
    wave, cluster(MNO)  

  margins, at(xparty3=2.073 ///
		income=11.400  lookingforwork=.056  personeco=2.829  tradeper=2.626 ///
		tradeself=3.829 proimmself=3.702 chinaself=3.184 ///
		tradediffdem=1.195  immdiffdem=2.328 chinadiffdem=1.726   ///
		tradediffrep=1.192 ///
		immdiffrep=(2.124 2.634) ///
		chinadiffrep=1.691  ///
		sdo=3.773  economy=2.807 ///
		prexparty3wave=0 preincomewave=0 prelookingforworkwave=0 prepersonecowave=0 pretradeperwave=0 ///
		pretradeselfwave=0 preproimmselfwave=0 prechinaselfwave=0 ///
		pretradediffdemwave=0 preimmdiffdemwave=0 prechinadiffdemwave=0 ///
 		pretradediffrepwave=0  preimmdiffrepwave=0 prechinadiffrepwave=0 ///
		presdowave=0 preeconomywave=0 acsunemplwave=0  acsmfgwave=0 acsincomewave=0 ///
		wave=0) post 
    nlcom (diff: _b[2._at] - _b[1._at])   

/*chinadiffrep
quietly logit demrepvote xparty3 income lookingforwork personeco tradeper ///
    tradeself proimmself chinaself ///
 	tradediffdem immdiffdem chinadiffdem  ///
 	tradediffrep immdiffrep chinadiffrep ///
  	sdo  economy ///
 	prexparty3wave preincomewave prelookingforworkwave prepersonecowave pretradeperwave ///
 	pretradeselfwave   preproimmselfwave  prechinaselfwave ///
 	pretradediffdemwave  preimmdiffdemwave prechinadiffdemwave ///
 	pretradediffrepwave  preimmdiffrepwave prechinadiffrepwave ///
 	presdowave preeconomywave acsunemplwave acsmfgwave acsincomewave ///
    wave, cluster(MNO) 

  margins, at(xparty3=2.073 ///
		income=11.400  lookingforwork=.056  personeco=2.829  tradeper=2.626 ///
		tradeself=3.829 proimmself=3.702 chinaself=3.184 ///
		tradediffdem=1.195  immdiffdem=2.328 chinadiffdem=1.726   ///
		tradediffrep=1.192 immdiffrep=2.124 ///
		chinadiffrep=(1.691 1.667) ///
		sdo=3.773  economy=2.807 ///
		prexparty3wave=0 preincomewave=0 prelookingforworkwave=0 prepersonecowave=0 pretradeperwave=0 ///
		pretradeselfwave=0 preproimmselfwave=0 prechinaselfwave=0 ///
		pretradediffdemwave=0 preimmdiffdemwave=0 prechinadiffdemwave=0 ///
 		pretradediffrepwave=0  preimmdiffrepwave=0 prechinadiffrepwave=0 ///
		presdowave=0 preeconomywave=0 acsunemplwave=0  acsmfgwave=0 acsincomewave=0 ///
		wave=0) post 
    nlcom (diff: _b[2._at] - _b[1._at])   

/*sdo
quietly logit demrepvote xparty3 income lookingforwork personeco tradeper ///
    tradeself proimmself chinaself ///
 	tradediffdem immdiffdem chinadiffdem  ///
 	tradediffrep immdiffrep chinadiffrep ///
  	sdo  economy ///
 	prexparty3wave preincomewave prelookingforworkwave prepersonecowave pretradeperwave ///
 	pretradeselfwave   preproimmselfwave  prechinaselfwave ///
 	pretradediffdemwave  preimmdiffdemwave prechinadiffdemwave ///
 	pretradediffrepwave  preimmdiffrepwave prechinadiffrepwave ///
 	presdowave preeconomywave acsunemplwave acsmfgwave acsincomewave ///
    wave, cluster(MNO) 

  margins, at(xparty3=2.073 ///
		income=11.400  lookingforwork=.056  personeco=2.829  tradeper=2.626 ///
		tradeself=3.829 proimmself=3.702 chinaself=3.184 ///
		tradediffdem=1.195  immdiffdem=2.328 chinadiffdem=1.726   ///
		tradediffrep=1.192 immdiffrep=2.124 chinadiffrep=1.691  ///
		sdo=(3.773 3.930) ///
		economy=2.807 ///
		prexparty3wave=0 preincomewave=0 prelookingforworkwave=0 prepersonecowave=0 pretradeperwave=0 ///
		pretradeselfwave=0 preproimmselfwave=0 prechinaselfwave=0 ///
		pretradediffdemwave=0 preimmdiffdemwave=0 prechinadiffdemwave=0 ///
 		pretradediffrepwave=0  preimmdiffrepwave=0 prechinadiffrepwave=0 ///
		presdowave=0 preeconomywave=0 acsunemplwave=0  acsmfgwave=0 acsincomewave=0 ///
		wave=0) post 
    nlcom (diff: _b[2._at] - _b[1._at])  
    
    
 
 
/*Table 3 analyses*/
 /*Table S3 */ 
 
xtreg cutdifftherm xparty3 income lookingforwork personeco tradeper ///
    economy ///
 	acsunemplwave acsmfgwave acsincomewave ///
    wave , fe 
 
 
drop if voted2016==0
logit demrepvote xparty3 income lookingforwork personeco tradeper ///
   economy ///
 	 acsunemplwave acsmfgwave acsincomewave ///
    wave, cluster(MNO) 

