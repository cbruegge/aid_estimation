*************************************************
*
* ffile#_to_stata
*
* Import ffile.csv and save as stata dataset
*
*************************************************
infix using "${local_directory}/code/build/${input_file}.dct", clear
gen from_file = "${input_file}"
save "${local_directory}/data/temp/${output_file}"

exit, clear STATA
