*************************************************
*
* build.do
*
* Builds the ffile and mfile datasets
*
*************************************************

shell rm "${local_directory}/data/ffile.dta"
shell rm "${local_directory}/data/mfile.dta"

clear
forvalues ii = ${start_year} / ${end_year} {
	local year = mod(`ii',100)
	if `year' < 10 {
		local year = "0" + "`year'"
	}

	forvalues quarter = 1/4 {
		disp "`year'`quarter'"

		if `quarter' == 2 {
			append using "${local_directory}/data/ffile`year'`quarter'.dta" 
		}
		shell rm "${local_directory}/data/ffile`year'`quarter'.dta"
	}
}
save "${local_directory}/data/ffile.dta"

clear
forvalues ii = ${start_year} / ${end_year} {
	local year = mod(`ii',100)
	if `year' < 10 {
		local year = "0" + "`year'"
	}
	forvalues quarter = 1/4 {
		if `quarter' == 2 {
			append using "${local_directory}/data/mfile`year'`quarter'.dta" 
		}
		shell rm "${local_directory}/data/mfile`year'`quarter'.dta"
	}
}
save "${local_directory}/data/mfile.dta"


exit, clear STATA