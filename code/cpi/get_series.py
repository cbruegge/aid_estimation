import requests
import json

##############################################################
#
# get_series
#
# Fetches cpi price series for each series in series_list
#
# Input: 	series_list
#			region_list
#			start_year / end_year
#
# Output: 	For each series in series_list, the cpi data 
# 			between	start_year and end_year is appended to 
#			the file series_id.csv
#
#			The output columns are 
#				- series_id
#				- year
#				- period
#				- value
#				- footnotes
#
##############################################################

def get_series(series_list,start_year,end_year,data_directory_path):
	headers = {'Content-type': 'application/json'} 
	data = json.dumps(
		{"seriesid": series_list,
		"startyear":start_year, "endyear":end_year}
		) 

	p = requests.post(
		'http://api.bls.gov/publicAPI/v1/timeseries/data/',
		data=data, 
		headers=headers
		) 

	json_data = json.loads(p.text) 

	for series in json_data['Results']['series']:
	    series_id = series['seriesID']
    	
    	for row in series['data']:
        	year = row['year']
        	period = row['period']
        	value = row['value']
        	footnotes=""
        	
        	for footnote in row['footnotes']:
        		if footnote:
        			footnotes = footnotes + footnote['text'] + ','

        	if 'M01' <= period <= 'M12':
        		with open(data_directory_path + series_id + ".txt",'a') as f:
					f.write(
						series_id + "," + 
						year + "," +
						period + "," +
						value + "," + '"' +
						footnotes[0:-1] + '"' + "\n"
					) 

