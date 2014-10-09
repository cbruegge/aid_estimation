*************************************************
*
* ./cpi/build.do
*
* Builds CPI Price Data
*
*************************************************

local files : dir "${local_directory}/data/cpi_series" files "*.txt"

* Create Temporary Stata Dataset
foreach file of local files {
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

exit, clear STATA