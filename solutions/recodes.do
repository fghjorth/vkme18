**************************************************************************
*The Conditional Impact of Local Economic Conditions on Incumbent Support*
**************************************************************************

*Authors: Frederik Hjorth, Martin Vinæs LArsen, Peter Thisted Dinesen and Kim Mannemar Sønderskov.


*FILE PURPOSE: Creates precinct-level dataset
*VERSION: STATA 13.1
*REQUIRED PACKAGES: 

*remember to update location
cd "C:\Users\au595748\Dropbox\housing\githubmappe\data"

*importing matched file on electoral support at parliamentary elections and housing prices
import delim allaf.csv, delim(",") clear
sort zipy




*changing missing to be compatible with stata format (i.e. replacing NA and NaN with "." for all variables)
foreach x of varlist * {
capture replace `x'="." if `x'=="NA"
capture replace `x'="." if `x'=="NaN"
}
destring *, replace

*dropping precints with no electoral information
drop if voters==.


*for how many precints do we have ctr. dont we have price information
count if zip==. & votes!=.
count if zip!=. & votes!=.


*merging dataset containing number of trades in zipcode
preserve
import delim allvoldat.txt, delim(",") clear
sort zipy
keep zipy nt0
tempfile numbers
saveold `numbers', replace
restore
sort zipy
merge m:1 zipy using `numbers', nogen keep(1 3)

gen logntrades=log(nt0)

*merging with dataset containing controls for unemprate and median inc
replace y=y+2000
sort zip y
merge m:1 zip y using zips_allyrs.dta, nogen keep(1 3)
replace y=y-2000

*count variable for number of election
recode year 2001=1 2005=2 2007=3 2011=4 2015=5, gen(eleccount)

*recoding incsup
replace incsupport=incsupport*100

*setting time and panel variables
tsset valgstedid eleccount

*fd incumbent support
gen d_ab=(a+b)-(l.a+l.b)
gen d_vc=(v+c)-(l.v+l.c)
gen d_inc=d_ab*100 if year==2001 | year==2015
replace d_inc=d_vc*100 if year==2005 | year==2007 | year==2011

*incsupport defined as PM party
gen pm_inc=a*100 if year ==2001 | year==2015
replace pm_inc=v*100 if year==2005 | year==2007 | year==2011

*growth in median income
gen grow=(medianinc_fd/(medianinc-medianinc_fd))*100


*recoding control variables so they make sense
replace unemprate=unemprate*100 // 0 to 100 pct.
replace medianinc_fd=medianinc_fd/1000
replace medianinc=medianinc/1000 //in thousands
replace unemprate_fd=unemprate_fd*100



*creating variable which indivate whether results are estimated
gen votes2=round(votes)
gen calc=0
replace calc=1 if votes2!=votes

*dropping irrelevant variables 
drop votes* komnavn vsnavn kredsnavn kontanthjaelp arbejd boligstoer_kv ejer formue indkomst ///
indkomst_80 hp_2yrpos hp_2yrneg  medianinc_lag unemprate_lag d_ab d_vc y

 
*labels
label var valgstedid "Precinct identifier"
label var muninum "Municipality"
label var year "Year"
label var zip "Zip code"
label var zipy "Zip by Year"
label var hp_1yr "$\Delta$ housing price"
label var hp_2yr "$\Delta$ housing price (2 years)"
label var hp_1yrneg "$\Delta$ housing price (negative)"
label var hp_1yrpos "$\Delta$ housing price (positive)"
label var unemprate "Unemployment rate"
label var medianinc "Median income (1000 DKK)"
label var unemprate_fd "Unemployment rate (change)"
label var medianinc_fd "Median income (change)"
label var pop "Population"
la var voters "Number of voters"
label var nt0 "Trades"
label var logntrades "Log(trades)"
label var a "Support for Social Democratic Party"
label var v "Support for Liberal Party"
label var b "Support for Social Liberal Party"
label var c "Support for Conservative Party"
label var incs "Support for Governing Parties (pct.)"
label var d_inc "Change in Support for Governing Parties (pct.)"
label var pm_inc "Support for Prime Minister party (pct.)"
label var calc "Votes estimated"




saveold replidata.dta, replace
