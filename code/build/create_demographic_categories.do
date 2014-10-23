*************************************************
*
* ./build/create_demographic_categories.do
*
* Creates Demographic Vars from ffiles and mfiles
*
*************************************************

**** Need Education ****


foreach ii of numlist 1 4 6 {
	gen CUTENUR`ii' = CUTENUR == `ii'
} 

foreach ii of numlist 1 2 3 4 {
	gen RACE`ii' = RACE == `ii'
}

gen MALE = SEX == 1

forvalues ii = 1/4 {
	gen MARITAL`ii' = MARITAL == `ii'
}

replace EMPSTAT = 0 if EMPSTAT == .
forvalues ii = 1/4 {
	gen EMPSTAT`ii' = EMPSTAT == `ii'
}

