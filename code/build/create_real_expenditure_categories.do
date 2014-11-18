*************************************************
*
* ./cex/build/create_real_expenditure_categories.do
*
* Aggregates the BLS Data to N Expenditure 
* 	categories and creates budget share varaibles
*
*************************************************

* Create 5 Expenditure Categories

gen real_food = 1/saf_price * ( ///
			  EXP23 /* Food Off-Premise */ ///
			+ EXP24 /* Food On-Premise */ ///
			+ EXP25 /* Food Furnished Employees */ ///
			+ EXP26 /* Tobacco Products */ ///
			+ EXP27 /* Alcohol Off-Premise */ ///
			+ EXP28 /* Alcohol On-Premise */ ///
			)

gen real_gas_util = 1/sah2_price * ( ///
			  EXP38 /* Electricity */ ///
			+ EXP39 /* Heating Gas */ ///
			+ EXP40 /* Water */ ///
			+ EXP41 /* Fuel Oil */ ///
			+ EXP55 /* Motor Vehicle Gas */ ///
			)

gen real_trans = 1/sat_price * ( ///
			  EXP52 /* New and Used Motor Vehicles */ ///
			+ EXP53 /* Motor Vehicle Parts */ ///
			+ EXP54 /* Motor Vehicle Repair */ ///
			+ EXP56 /* Tolls */ ///
			+ EXP57 /* Auto Insurance */ ///
			+ EXP58 /* Mass Transit */ ///
			+ EXP59 /* Taxi & Misc Travel */ ///
			+ EXP60 /* Airline Fares */ ///
			)

gen real_housing = 1/sah1_price * ( ///
			  EXP34 /* Rent -- Tenant-occupied non-farm */ ///
			+ EXP35 /* Other Rent */ ///
			+ EXP75 /* Rental Equivalent of Owned Home */ ///
			) + ///
			1/sah3_price * ( ///
			  EXP36 /* Durable HH Equipment */ ///
			+ EXP37 /* Non-durable HH Equipment */ ///
			+ EXP42 /* Telephone */ ///
			+ EXP43 /* Domestic Service & Misc HH Operation */ ///
			)


gen real_outside_good = 1/saa_price * ( ///
			  EXP29 /* Clothing and Shoes */ ///
			+ EXP30 /* Clothing Services */ ///
			+ EXP31 /* Jewlery and Watches */ ///
			) + ///
			1/sag_price * ( ///
			  EXP32 /* Toiletries */ ///
			+ EXP33 /* Barbershops & Beauty Parlors */ ///
			) + ///
			1/sam_price * ( ///
			  EXP44 /* Drug Preparations */ ///
			+ EXP45 /* Orthopedic Appliance */ ///
			+ EXP46 /* Medical Professionals */ ///
			+ EXP47 /* Hospitals */ ///
			+ EXP48 /* Nursing Homes */ ///
			+ EXP49 /* Health Insurance */ ///
			) + ///
			1/sar_price * ( ///
			  EXP61 /* Books and Maps */ ///
			+ EXP62 /* Magazines */ ///
			+ EXP63 /* Sporting Goods */ ///
			+ EXP64 /* Other Rec. Services */ ///
			) + ///
			1/sae_price * ( ///
			  EXP66 /* Higher Edu. */ ///
			+ EXP67 /* Primary & Secondary Education */ ///
			+ EXP68 /* Other Education */ ///
			+ EXP69 /* Religions Activities */ ///
			)
