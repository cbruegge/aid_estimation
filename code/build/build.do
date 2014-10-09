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
foreach file of local cpi_files {
	* Import Data
	insheet using "${local_directory}/data/cpi_series/`file'.txt"

	* Collapse to quarter
	gen quarter = .
	replace quarter = 1 if period == "M01" | period == "M02" | period == "M03"
	replace quarter = 2 if period == "M04" | period == "M05" | period == "M06"
	replace quarter = 3 if period == "M07" | period == "M08" | period == "M09"
	replace quarter = 4 if period == "M10" | period == "M11" | period == "M12"

	collapse (first) series_id (mean) *_price, by(year quarter)

	replace *_price = *_price / 100

	* Define Merge Variables
	urban = 1 + regexm(area_code,"D") // 1 - urban; 2 - rural 

	area_code = substr(`file',5,4)
	gen region = .
	replace region = 1 if area_code == "0100"
	replace region = 2 if area_code == "0200"
	replace region = 3 if area_code == "0300"
	replace region = 4 if area_code == "0400"
	replace region = 5 if regexm(area_code,"D")

	merge_var = region * 1000000 + urban * 100000 + year*10 + quarter

	save "${local_directory}/data/temp/`file'.dta"

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

* Create the Family Record File
clear
forvalues ii = ${start_year} / ${end_year} {
	local year = mod(`ii',100)
	if `year' < 10 {
		local year = "0" + "`year'"
	}

	forvalues quarter = 1/4 {
		disp "`year'`quarter'"

		if `quarter' == 2 {
			append using "${local_directory}/data/temp/ffile`year'`quarter'.dta" 
		}
	}
}

* Create N Expenditure Categories from the BLS Expenditure Data
include "${local_directory}/code/cex/build/create_expenditure_categories.do"

* Merge Member and Family Records with the NEWID variable
merge m:m NEWID using "${local_directory}/data/temp/mfile.dta", gen(merge_mfile)
tab _merge_mfile

* Create Variable to Merge with Price Indices
replace REGION = 5 if REGION == .
gen merge_var = REGION * 1000000 + BLSURBN * 100000 + year * 10 + quarter

*************************************************
* Merge CEX and CPI Data
*************************************************

* Merge Price Data for Each Good
local files : dir "${local_directory}/data/cpi_series" files "*.txt"
for file of local files {
	merge m:1 merge_var using "${local_directory}/temp/`file'.dta", gen(merge_`file')
}

* Create Real Expenditures
include "${local_directory}/build/create_real_expenditure_categories.do"

* Create Weighted Price Indices
foreach category in "food gas_util trans housing outside_good" {
	price_`category' = `category' / real_`category' 
	gen lprice_`category' = log(price_`category')
}

gen INC = ( ///
		  EXP(1) ///
		+ EXP(2) ///
		+ EXP(3) ///
		+ EXP(4) ///
		+ EXP(5) ///
		+ EXP(6) ///
		+ EXP(7) ///
		+ EXP(8) ///
		+ EXP(9) ///
		+ EXP(10) ///
		+ EXP(11) ///
		+ EXP(12) ///
		+ EXP(13) ///
		+ EXP(14) 
	)

keep lprice_* lexp share_* BLSURBN CUTENUR GOVHOUS PUBHOUS INC

save "${local_directory}/data/output/cleaned_data.dta", replace 

exit, clear STATA