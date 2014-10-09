#!/bin/bash

############################################
#
# fetch_cex.sh 
#
# Fetches CEX Family and Member Files from 
# 	the NBER Website. Make sure this file is 
#	executable. 
#
# Inputs: start_year, end_year, local_directory
# Outputs: Copies ffiles and mfiles to 
# local_directory/data/(f/m)file${year}.zip 
#
############################################

start_year=${1}
end_year=${2}
local_directory=${3}
data_url=${4}

for year in `seq $start_year $end_year`;
do
        year=`expr $year % 100`
        if [ $year -lt 10 ]; then 
                year="0${year}"
        fi
        # Download Data to local directory
        echo "Pulling data for ${year}"        
        curl -o ${local_directory}/data/cex_series/mfile${year}.zip ${data_url}/mfile${year}.zip
        curl -o ${local_directory}/data/cex_series/ffile${year}.zip ${data_url}/ffile${year}.zip

done 