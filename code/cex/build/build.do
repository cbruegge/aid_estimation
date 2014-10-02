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
			append using "${local_directory}/data/mfile`year'`quarter'.dta" 
		}
		shell rm "${local_directory}/data/mfile`year'`quarter'.dta"
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
			append using "${local_directory}/data/ffile`year'`quarter'.dta" 
		}
		shell rm "${local_directory}/data/ffile`year'`quarter'.dta"
	}
}


* Merge Member and Family Records with the NEWID variable
merge m:m NEWID using "${local_directory}/data/mfile.dta"

food = EXP(23) + EXP(24) + EXP(25)
clothing = EXP(29)
rent_utilities = EXP(34) + EXP(38) + EXP(39) + EXP(40) + EXP(41) + EXP(42)
medical = EXP(44) + EXP(45) + EXP(46) + EXP(47) + EXP(48) + EXP(49)
motor_vehicle = EXP(52) + EXP(53) 
furniture = EXP(36)
housing_interest = EXP(76)
housing_tax = EXP(77)
housing_goods = EXP(78)
life_insurance = EXP(51)
gifts_contributions = EXP(69)
personal_interest = EXP(71) + EXP(72)
other_goods = EXP(26) + EXP(27) + EXP(28) + EXP(31) + EXP(32) + EXP(37) + EXP(55) ///
	+ EXP(61) + EXP(62) + EXP(63)
other_services = EXP(30) + EXP(33) + EXP(35) + EXP(43) + EXP(50) + EXP(54) + EXP(56) ///
	+ EXP(57) + EXP(58) + EXP(59) + EXP(60) + EXP(64)

tab _merge



exit, clear STATA