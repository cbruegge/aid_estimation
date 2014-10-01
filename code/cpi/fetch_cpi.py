from get_series import *
from math import ceil

# Set workspace variables
data_directory_path = (
	"/Users/Chris/Documents/Research/stanford/" + 
	"ra_larry/CGE_MODEL/utility_functions/cpi/data/cpi_series/"
	)

item_list = ["SAF1","SAE"]
region_list = ["0100", "X100"]
adjustment = "U"
periodicity = "R"
start_year = 1980
end_year = 2014

series_list = []
for region in region_list:
	for item in item_list:
		series_list.append(
			"CU"+adjustment+periodicity+region+item
			)
	

for series_id in series_list:

	temp_start_year = start_year

	# Clear Output Series Files
	print "Pulling data for " + series_id
	with open(data_directory_path + series_id + ".txt",'w') as f:
		f.write("series_id, year, period, value, footnotes\n")

	# Pull 10-years at a time
	queries_left = ceil((end_year - temp_start_year + 1) / 10.0)
	while (queries_left > 0):
		temp_end_year = min(end_year,temp_start_year + 9)

		print "\t... " + str(temp_start_year) + " to " + str(temp_end_year)

		get_series(
			[series_id],
			temp_start_year,
			temp_end_year,
			data_directory_path
		)

		temp_start_year = temp_start_year + 10
		queries_left = ceil((end_year - temp_start_year + 1) / 10.0)




