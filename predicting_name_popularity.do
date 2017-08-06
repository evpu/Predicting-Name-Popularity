* using Stata
clear all

* Convert data from TXT file
tempfile clean
gen year=.
gen name=""
gen gender=""
save clean, replace

clear all
forval i=1880/2013{
	insheet using "data\yob`i'.txt"
	rename v1 name
	rename v2 gender
	rename v3 obs
	gen year=`i'
	append using clean
	save clean, replace
	clear
}



* ************************************************************************
* Graph 1: Jacqueline
use clean, clear
keep if name=="Jacqueline" & gender=="F"
tsset year
gen lady_Jacqueline=15000 if  year>= 1961 &  year <= 1963

local options graphregion(c(white)lw(thick)lc(white)) legend(size(small) region(lw(thick)lc(white))) ylabel(, angle(0)) 

twoway (area lady_Jacqueline year, fintensity(inten20) color(pink) lcolor(white) lw(none)) (tsline obs, lw(medthick) lc(cranberry)), ytitle("") ttitle("") `options' xlabel(1900[10]2010, labsize(small)) ylabel(0[1000]15000, labsize(small)) legend(order(1 "Jacqueline Kennedy as the First Lady (1961-1963)"))
graph export "Jacqueline.eps"


* ************************************************************************

* Graph 2: Emily
clear all
use clean
keep if name=="Emily" & gender=="F"
save temp, replace
tsset year

* Forecast starting from 1970 using 20 lags
drop if year >=1970
tsappend, add(44)
reg obs L(1/10).obs
forecast create ar30
estimate store model1
forecast estimates model1
forecast solve, simulate(errors,statistic(stddev,prefix(sd_)) reps(500))

gen middle=f_obs if year>=1970

gen low95=f_obs-1.96*sd_obs if year>=1970
gen up95=f_obs+1.96*sd_obs if year>=1970


gen low90=f_obs-1.645*sd_obs if year>=1970
gen up90=f_obs+1.645*sd_obs if year>=1970

gen low99=f_obs-2.575*sd_obs if year>=1970
gen up99=f_obs+2.575*sd_obs if year>=1970

merge 1:1 name year gender using temp

graph twoway (tsline obs if year<1970, lw(medthick) lc(cranberry)) (rarea up99 low99 year, fintensity(inten10) color(pink) lcolor(white) lw(vvvthin)) (rarea up95 low95 year, fintensity(inten20) color(pink) lcolor(white) lw(vvvthin))  (rarea up90 low90 year, fintensity(inten30) color(pink) lcolor(white) lw(vvvthin)) (tsline obs if year>=1970, lw(medthick) lc(cranberry) lp(longdash_dot)) (tsline middle, lw(medthick) lc(purple) lp(dash)), `options' xlabel(1880[30]2010, labsize(small)) ylabel(#10, labsize(small)) legend(order(1 "Actual data 1880-1969" 2 "99% CI" 5 "Actual data 1970-present" 3 "95% CI" 6 "Projection 1970-present"  4 "90% CI") row(3)) xtitle("") subtitle("Emily", position(12) ring(0) color(cranberry)) yline(30000, lc(ltbluishgray))
gr_edit .plotregion1.style.editstyle margin(zero) editcopy
graph save Emily, replace



* ************************************************************************

* Graph 2: Daniel
clear all
use clean
keep if name=="Daniel" & gender=="M"
save temp, replace
tsset year

* Forecast starting from 1970 using 20 lags
drop if year >=1970
tsappend, add(44)
reg obs L(1/10).obs
forecast create ar30
estimate store model1
forecast estimates model1
forecast solve, simulate(errors,statistic(stddev,prefix(sd_)) reps(500))

gen middle=f_obs if year>=1970

gen low95=f_obs-1.96*sd_obs if year>=1970
gen up95=f_obs+1.96*sd_obs if year>=1970


gen low90=f_obs-1.645*sd_obs if year>=1970
gen up90=f_obs+1.645*sd_obs if year>=1970

gen low99=f_obs-2.575*sd_obs if year>=1970
gen up99=f_obs+2.575*sd_obs if year>=1970

merge 1:1 name year using temp



graph twoway (tsline obs if year<1970, lw(medthick) lc(ebblue)) (rarea up99 low99 year, fintensity(inten30) color(eltblue) lcolor(white) lw(vvvthin)) (rarea up95 low95 year, fintensity(inten60) color(eltblue) lcolor(white) lw(vvvthin))  (rarea up90 low90 year, fintensity(inten80) color(eltblue) lcolor(white) lw(vvvthin)) (tsline obs if year>=1970, lw(medthick) lc(ebblue) lp(longdash_dot)) (tsline middle, lw(medthick) lc(navy) lp(dash)), `options' xlabel(1880[30]2010, labsize(small)) ylabel(#10, labsize(small)) legend(order(1 "Actual data 1880-1969" 2 "99% CI" 5 "Actual data 1970-present" 3 "95% CI" 6 "Projection 1970-present"  4 "90% CI") row(3)) xtitle("") subtitle("Daniel", position(12) ring(0) color(navy))
gr_edit .plotregion1.style.editstyle margin(zero) editcopy
graph save Daniel, replace

* ************************************************************************
* Combine graphs for Emily and Daniel

graph combine "Daniel.gph" "Emily.gph", graphregion(c(white)lw(thick)lc(white))
graph export "Daniel_Emily.eps"
