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
build_data="NO"
run_analysis="YES"

# Define Variables
local_directory="/Users/chris.bruegge/workspace/aid_estimation"
data_url="http://nber.org/ces_cbo"
start_year=1980
end_year=2002

# Pull Data 
if [ "$pull_data" == "YES" ]; then
    # Pull CEX Data
    #rm -rf "${local_directory}/data/cex_series/"
    #mkdir "${local_directory}/data/cex_series/"
    #${local_directory}/code/fetch/fetch_cex.sh ${start_year} ${end_year} ${local_directory} ${data_url}
 
    rm -rf "${local_directory}/data/cpi_series/"
    mkdir "${local_directory}/data/cpi_series/"
    # Pull CPI Data -- Can I modify this so the variables are configured here?
    python ${local_directory}/code/fetch/fetch_cpi.py
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
        unzip "${local_directory}/data/cex_series/ffile${year}" -d "${local_directory}/data/temp"
        unzip "${local_directory}/data/cex_series/mfile${year}" -d "${local_directory}/data/temp"

        for quarter in `seq 1 4`;
        do

                # Create ffile stata Datasets
                sed -e "s?\${input_file}?ffile${year}${quarter}?g" ${local_directory}/code/build/ffile.dct > ${local_directory}/code/build/ffile${year}${quarter}.dct 
                sed -ie "s?\${local_directory}?${local_directory}?g" ${local_directory}/code/build/ffile${year}${quarter}.dct 

                sed -e "s?\${input_file}?ffile${year}${quarter}?g" ${local_directory}/code/build/infix_file.do > ${local_directory}/code/build/infix_file_temp.do 
                sed -ie "s?\${output_file}?ffile${year}${quarter}?g" ${local_directory}/code/build/infix_file_temp.do 
                sed -ie "s?\${local_directory}?${local_directory}?g" ${local_directory}/code/build/infix_file_temp.do 

                mv "${local_directory}/data/temp/ffile${year}${quarter}" "${local_directory}/data/temp/ffile${year}${quarter}.raw"

                statase -b do ${local_directory}/code/build/infix_file_temp.do 

                rm ${local_directory}/code/build/ffile${year}${quarter}.dct* 
                rm ${local_directory}/code/build/infix_file_temp.do*
                rm ${local_directory}/code/infix_file_temp.log*                

                # Create mfile stata datasets
                sed -e "s?\${input_file}?mfile${year}${quarter}?g" ${local_directory}/code/build/mfile.dct > ${local_directory}/code/build/mfile${year}${quarter}.dct 
                sed -ie "s?\${local_directory}?${local_directory}?g" ${local_directory}/code/build/mfile${year}${quarter}.dct 

                sed -e "s?\${input_file}?mfile${year}${quarter}?g" ${local_directory}/code/build/infix_file.do > ${local_directory}/code/build/infix_file_temp.do 
                sed -ie "s?\${output_file}?mfile${year}${quarter}?g" ${local_directory}/code/build/infix_file_temp.do 
                sed -ie "s?\${local_directory}?${local_directory}?g" ${local_directory}/code/build/infix_file_temp.do 

                mv "${local_directory}/data/temp/mfile${year}${quarter}" "${local_directory}/data/temp/mfile${year}${quarter}.raw"

                statase do ${local_directory}/code/build/infix_file_temp.do 

                rm ${local_directory}/code/build/mfile${year}${quarter}.dct* 
                rm ${local_directory}/code/build/infix_file_temp.do*
                rm ${local_directory}/code/infix_file_temp.log*                
       done
      
done

sed -e "s?\${start_year}?${start_year}?g" ${local_directory}/code/build/build.do > ${local_directory}/code/build/build_temp.do 
sed -ie "s?\${end_year}?${end_year}?g" ${local_directory}/code/build/build_temp.do 
sed -ie "s?\${local_directory}?${local_directory}?g" ${local_directory}/code/build/build_temp.do 

statase -b do ${local_directory}/code/build/build_temp.do
rm ${local_directory}/code/build/build_temp.*
rm ${local_directory}/code/build_temp.log

fi

# Run Estimation
if [ "$run_analysis" == "YES" ]; then

    # Set Variables
    sed -e "s?\${local_directory}?${local_directory}?g" ${local_directory}/code/analysis/analysis.do > ${local_directory}/code/analysis/analysis_temp.do 

    # Run Analysis Program
    statase -b do "${local_directory}/code/analysis/analysis_temp.do"

    # Clean Up
    rm ${local_directory}/code/analyis/analysis_temp.do*
fi
