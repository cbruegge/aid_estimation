*************************************************
*
* ./build/build.do
*
* Builds CPI Price Data and CEX Expenditure Data
*
*************************************************

*************************************************
* Build CPI Data
*************************************************

local cpi_files : dir "${local_directory}/data/cpi_series" files "*.txt"

* Create Temporary Stata Dataset
foreach in_file of local cpi_files {

	local item = subinstr("`in_file'",".txt","",1)

	* Import Data
	insheet using "${local_directory}/data/cpi_series/`item'.txt", clear

	* Collapse to quarter
	gen quarter = .
	replace quarter = 1 if period == "M01" | period == "M02" | period == "M03"
	replace quarter = 2 if period == "M04" | period == "M05" | period == "M06"
	replace quarter = 3 if period == "M07" | period == "M08" | period == "M09"
	replace quarter = 4 if period == "M10" | period == "M11" | period == "M12"

	collapse (first) series_id (mean) *_price, by(year quarter area_code)

	foreach price_var of varlist *_price {
		replace `price_var' = `price_var' / 100
	}

	* Define Merge Variables
	gen urban = 1 + regexm(area_code,"D") // 1 - urban; 2 - rural 

	gen region = .
	replace region = 1 if area_code == "0100"
	replace region = 2 if area_code == "0200"
	replace region = 3 if area_code == "0300"
	replace region = 4 if area_code == "0400"
	replace region = 5 if regexm(area_code,"D")

	gen merge_var = region * 1000000 + urban * 100000 + year*10 + quarter

	save "${local_directory}/data/temp/`item'.dta"

}

*************************************************
* Build CEX Data
*************************************************

* Create the Member Record File
clear
forvalues ii = ${start_year} / ${end_year} {
	local year = mod(`ii',100)
	if `year' < 10 {
		local year = "0" + "`year'"
	}
	forvalues quarter = 1/4 {
		if `quarter' == 2 {
			append using "${local_directory}/data/temp/mfile`year'`quarter'.dta" 
		}
	}
}
save "${local_directory}/data/temp/mfile.dta"
*/ 
* Create the Family Record File
clear
forvalues ii = ${start_year} / ${end_year} {
	local year = mod(`ii',100)
	if `year' < 10 {
		local year = "0" + "`year'"
	}

	forvalues quarter = 1/4 {
		if `quarter' == 2 {
			append using "${local_directory}/data/temp/ffile`year'`quarter'.dta" 
		}
	}
}

* Create N Expenditure Categories from the BLS Expenditure Data
include "${local_directory}/code/build/create_expenditure_categories.do"

* Merge Member and Family Records with the NEWID variable
merge m:m NEWID using "${local_directory}/data/temp/mfile.dta", gen(merge_mfile)
tab merge_mfile

* Create Variable to Merge with Price Indices
replace REGION = 5 if REGION == .
gen year = substr(from_file,6,2)
gen quarter = substr(from_file,8,1)
destring year quarter, replace
replace year = 1900 + year if year >= 50
replace year = 2000 + year if year < 50
gen merge_var = REGION * 1000000 + BLSURBN * 100000 + year * 10 + quarter

*************************************************
* Merge CEX and CPI Data
*************************************************

* Merge Price Data for Each Good
local cpi_files : dir "${local_directory}/data/cpi_series" files "*.txt"
foreach in_file of local cpi_files {
	local series_id = subinstr("`in_file'",".txt","",1)
	merge m:1 merge_var using "${local_directory}/data/temp/`series_id'.dta", gen(merge_`series_id')
}

* Create Real Expenditures
include "${local_directory}/code/build/create_real_expenditure_categories.do"

* Create Demographic Dummies
include "${local_directory}/code/build/create_demographic_categories.do"

* Create Weighted Price Indices
foreach category in "food" "trans" "housing" "outside_good" {
	gen price_`category' = `category' / real_`category' 
	gen lprice_`category' = log(price_`category')
}

gen INC = ( ///
		  EXP1 ///
		+ EXP2 ///
		+ EXP3 ///
		+ EXP4 ///
		+ EXP5 ///
		+ EXP6 ///
		+ EXP7 ///
		+ EXP8 ///
		+ EXP9 ///
		+ EXP10 ///
		+ EXP11 ///
		+ EXP12 ///
		+ EXP13 ///
		+ EXP14 ///
	)

keep lprice_* lexp share_* CUTENUR* FAMSIZE AGE RACE* MALE MARITAL* EMPSTAT* INC

save "${local_directory}/data/output/cleaned_data.dta", replace 

exit, clear STATA