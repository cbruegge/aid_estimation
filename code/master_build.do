*************************************************
*
* .master_build.do
*
* Builds CPI Price Data
*
*************************************************

use "${local_directory}/data/output/cleaned_expenditure_data.dta"

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