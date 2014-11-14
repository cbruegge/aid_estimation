from get_series import *
from math import ceil

# Set workspace variables
data_directory_path = (
	"/Users/chris.bruegge/workspace/aid_estimation/data/cpi_series/"
	)

item_list = ["SAH"]
#item_list = ["SAF1","SAF116", "SEGA", "SEHF01", "SEHF02", "SEHG", "SEHE01", "SETB", "SETA", "SETC", "SETD", "SETE","SETG", "SETG01", "SEHA", "SEHC", "SAH3", "SAA", "SAG", "SAM", "SAR", "SAE"]
# Problematic series: SETG, SETG01, SEHA

region_list = ["0100", "0200","0300","0400","D000"]
adjustment = "U"
periodicity = "R"
start_year = 1980
end_year = 2002	

for item in item_list:

	# Clear Output Series File
	with open(data_directory_path + item + ".txt",'w') as f:
		f.write("series_id, area_code, year, period," + item + "_price, footnotes\n")

	for region in region_list:

		series_id = "CU"+adjustment+periodicity+region+item
		temp_start_year = start_year
	
		# Pull 10-years at a time
		print "Pulling data for " + series_id
		queries_left = ceil((end_year - temp_start_year + 1) / 10.0)
		while (queries_left > 0):
			temp_end_year = min(end_year,temp_start_year + 9)
	
			print "\t... " + str(temp_start_year) + " to " + str(temp_end_year)
	
			get_series(
				adjustment,
				periodicity,
				region,
				item,
				temp_start_year,
				temp_end_year,
				data_directory_path
			)
	
			temp_start_year = temp_start_year + 10 
			queries_left = ceil((end_year - temp_start_year + 1) / 10.0)

