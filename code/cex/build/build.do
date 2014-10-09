*************************************************
*
* build.do
*
* Builds the ffile and mfile datasets
*
*************************************************

shell rm "${local_directory}/data/ffile.dta"
shell rm "${local_directory}/data/mfile.dta"


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
save "${local_directory}/data/mfile.dta"

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
merge m:m NEWID using "${local_directory}/data/mfile.dta", gen(merge_mfile)
tab _merge_mfile

* Create Variable to Merge with Price Indices
replace REGION = 5 if REGION == .
gen merge_var = REGION * 1000000 + BLSURBN * 100000 + year * 10 + quarter

save "${local_directory}/data/output/cleaned_expenditure_data.dta"



exit, clear STATA