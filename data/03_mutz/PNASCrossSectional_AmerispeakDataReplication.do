  /*file for running regressions on amerispeaks data */
  
use "C:\Users\mutz\Dropbox\amerispeak panel\wave 1\AmerispeakFeb2017.dta", clear 


egen cutdifftherm= cut(thermdiffTC), group(20)

recode majorsex (-4=4)(-3=3)(-2=2) (-1=1)(0=0)(1=-1) ///
  (2=-2) (3=-3) (4=-4), gen(majorsexR) ///
  
generate majorindex=(majorsexR+majorrelig+majorrace)/3

   
     /*all analysis */
	 /* Table S4 results */
	
regress cutdifftherm party3 noncollegegrad  white GENDER AGE7 religion ///
 INCOME lookwork ecoworry perecoperc  safetynet medianincome ///
   prop_civlaborforce_unemp prop_manuf ///
    majorindex pt4r  sdoindex prejudice ///
     isoindex china immigindex tradeindex natsupindex       ///
     ecoperc  terrorthreat ///
	
	
logit voterclintrump party3 noncollegegrad  white GENDER AGE7 religion ///
 INCOME lookwork ecoworry perecoperc  safetynet medianincome ///
   prop_civlaborforce_unemp prop_manuf  majorindex pt4r sdoindex prejudice ///
     isoindex china immigindex tradeindex natsupindex       ///
    syslegindex govttrust  ecoperc  terrorthreat ///
  

logit trumppref party3 noncollegegrad  white GENDER AGE7 religion ///
 INCOME lookwork ecoworry perecoperc  safetynet medianincome ///
   prop_civlaborforce_unemp prop_manuf  majorindex pt4r sdoindex prejudice ///
     isoindex china immigindex tradeindex natsupindex       ///
    syslegindex govttrust  ecoperc  terrorthreat ///

  
     /* analysis demonstrating what education represents*/
	/* Figure 3 and Table S5 results */
	
regress cutdifftherm party3 noncollegegrad  white GENDER AGE7 religion INCOME

regress cutdifftherm party3 noncollegegrad  white GENDER AGE7 religion INCOME ///
 lookwork ecoworry perecoperc  safetynet medianincome ///
   prop_civlaborforce_unemp prop_manuf 
  
regress cutdifftherm party3 noncollegegrad  white GENDER AGE7 religion INCOME ///
    majorindex pt4r  sdoindex prejudice ///
     isoindex china immigindex tradeindex     


logit voterclintrump party3 noncollegegrad  white GENDER AGE7 religion INCOME///

logit voterclintrump party3 noncollegegrad  white GENDER AGE7 religion INCOME///
  lookwork ecoworry perecoperc  safetynet medianincome ///
   prop_civlaborforce_unemp prop_manuf ///
  
logit voterclintrump party3 noncollegegrad  white GENDER AGE7 religion INCOME///
    majorindex pt4r  sdoindex prejudice ///
     isoindex china immigindex tradeindex      
 


logit trumppref party3 noncollegegrad  white GENDER AGE7 religion INCOME

logit trumppref party3 noncollegegrad  white GENDER AGE7 religion INCOME ///
 lookwork ecoworry perecoperc  safetynet medianincome ///
   prop_civlaborforce_unemp prop_manuf 
  
logit trumppref party3 noncollegegrad  white GENDER AGE7 religion INCOME ///
    majorindex pt4r  sdoindex prejudice ///
     isoindex china immigindex tradeindex      
 
  /* models with only economic hardship vars */
  /* Table S3 results */  
regress cutdifftherm party3 AGE7 GENDER noncollegegrad religion white ///
 INCOME lookwork ecoworry perecoperc safetynet ecoperc prop_manuf medianincome ///
  prop_civlaborforce_unemp

logit voterclintrump party3 AGE7 GENDER noncollegegrad religion white ///
 INCOME lookwork ecoworry perecoperc safetynet ecoperc prop_manuf medianincome ///
  prop_civlaborforce_unemp 

logit trumppref party3 AGE7 GENDER noncollegegrad religion white ///
 INCOME lookwork ecoworry perecoperc safetynet ecoperc prop_manuf medianincome ///
  prop_civlaborforce_unemp 
