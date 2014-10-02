*************************************************
*
* ffile#_to_stata
*
* Import ffile.csv and save as stata dataset
*
*************************************************
infix using "${local_directory}/code/cex/build/${input_file}.dct", clear
gen from_file = "${input_file}"
save "${local_directory}/data/${output_file}"

exit, clear STATA
