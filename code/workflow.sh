#!/bin/bash

#################################################
#
# workflow.sh
#
# Builds CEX dataset to estimate AID model
#
#################################################

#kinit cbruegge@stanford.edu

# Choose Modules to Run
pull_data="NO"
build_data="YES"

# Define Variables
local_directory="/Users/chris.bruegge/workspace/aid_estimation"
data_url="http://nber.org/ces_cbo"
start_year=1980
end_year=2002

# Pull Data 
if [ "$pull_data" == "YES" ]; then

rm -rf ${local_directory}/data/*

for year in `seq $start_year $end_year`;
do
        year=`expr $year % 100`
        if [ $year -lt 10 ]; then 
                year="0${year}"
        fi
        # Download Data to local directory
        echo "Pulling data for ${year}"        
        curl -o ${local_directory}/data/mfile${year}.zip ${data_url}/mfile${year}.zip
        curl -o ${local_directory}/data/ffile${year}.zip ${data_url}/ffile${year}.zip

done 
fi


# Build Data
if [ "$build_data" == "YES" ]; then

rm -rf "${local_directory}/data/temp/"
mkdir "${local_directory}/data/temp"

rm -rf "${local_directory}/data/output/"
mkdir "${local_directory}/data/output"

for year in `seq $start_year $end_year`;
do
        year=`expr $year % 100`
        if [ $year -lt 10 ]; then 
                year="0${year}"
        fi

        # Unzip mfile and ffile
        unzip "${local_directory}/data/ffile${year}" -d "${local_directory}/data"
        unzip "${local_directory}/data/mfile${year}" -d "${local_directory}/data"

        for quarter in `seq 1 4`;
        do

                # Build ffile
                sed -e "s?\${input_file}?ffile${year}${quarter}?g" ${local_directory}/code/cex/build/ffile.dct > ${local_directory}/code/cex/build/ffile${year}${quarter}.dct 
                sed -ie "s?\${local_directory}?${local_directory}?g" ${local_directory}/code/cex/build/ffile${year}${quarter}.dct 

                sed -e "s?\${input_file}?ffile${year}${quarter}?g" ${local_directory}/code/cex/build/infix_file.do > ${local_directory}/code/cex/build/infix_file_temp.do 
                sed -ie "s?\${output_file}?ffile${year}${quarter}?g" ${local_directory}/code/cex/build/infix_file_temp.do 
                sed -ie "s?\${local_directory}?${local_directory}?g" ${local_directory}/code/cex/build/infix_file_temp.do 

                mv "${local_directory}/data/ffile${year}${quarter}" "${local_directory}/data/ffile${year}${quarter}.raw"

                statase -b do ${local_directory}/code/cex/build/infix_file_temp.do 

                rm ${local_directory}/code/cex/build/ffile${year}${quarter}.dct* 
                rm ${local_directory}/code/cex/build/infix_file_temp.do*
                rm ${local_directory}/code/infix_file_temp.log*                
                rm ${local_directory}/data/ffile${year}${quarter}.raw


                # Build mfile
                sed -e "s?\${input_file}?mfile${year}${quarter}?g" ${local_directory}/code/cex/build/mfile.dct > ${local_directory}/code/cex/build/mfile${year}${quarter}.dct 
                sed -ie "s?\${local_directory}?${local_directory}?g" ${local_directory}/code/cex/build/mfile${year}${quarter}.dct 

                sed -e "s?\${input_file}?mfile${year}${quarter}?g" ${local_directory}/code/cex/build/infix_file.do > ${local_directory}/code/cex/build/infix_file_temp.do 
                sed -ie "s?\${output_file}?mfile${year}${quarter}?g" ${local_directory}/code/cex/build/infix_file_temp.do 
                sed -ie "s?\${local_directory}?${local_directory}?g" ${local_directory}/code/cex/build/infix_file_temp.do 

                mv "${local_directory}/data/mfile${year}${quarter}" "${local_directory}/data/mfile${year}${quarter}.raw"

                statase do ${local_directory}/code/cex/build/infix_file_temp.do 

                rm ${local_directory}/code/cex/build/mfile${year}${quarter}.dct* 
                rm ${local_directory}/code/cex/build/infix_file_temp.do*
                rm ${local_directory}/code/infix_file_temp.log*                
                rm ${local_directory}/data/mfile${year}${quarter}.raw
       done
      
done

sed -e "s?\${start_year}?${start_year}?g" ${local_directory}/code/cex/build/build.do > ${local_directory}/code/cex/build/build_temp.do 
sed -ie "s?\${end_year}?${end_year}?g" ${local_directory}/code/cex/build/build_temp.do 
sed -ie "s?\${local_directory}?${local_directory}?g" ${local_directory}/code/cex/build/build_temp.do 

statase -b do ${local_directory}/code/cex/build/build_temp.do
rm ${local_directory}/code/cex/build/build_temp.*
rm ${local_directory}/code/build_temp.log


fi



# Run Estimation
