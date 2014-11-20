*************************************************
*
* ./cex/build/create_real_expenditure_categories.do
*
* Aggregates the BLS Data to N Expenditure 
* 	categories and creates budget share varaibles
*
*************************************************

* Create 5 Expenditure Categories

gen real_food = 1/saf * ( ///
			  EXP23 /* Food Off-Premise */ ///
			+ EXP24 /* Food On-Premise */ ///
			+ EXP25 /* Food Furnished Employees */ ///
			+ EXP27 /* Alcohol Off-Premise */ ///
			+ EXP28 /* Alcohol On-Premise */ ///
			+ EXP26 /* Tobacco Products */ ///
			)

gen real_gas_util = 1/sehf01_price * ( ///
			  EXP38 /* Electricity */ ///
			) + ///
			 1/ sehf02_price * ( ///
			  EXP39 /* Heating Gas */ ///
			) + ///
			1/ setb_price * ( ///
			 EXP55 /* Motor Vehicle Gas */ ///
			)

gen real_trans = 1/seta_price * ( ///
			  EXP52 /* New and Used Motor Vehicles */ ///
			)

gen real_housing = 1/seha_price * ( ///
			  EXP34 /* Rent -- Tenant-occupied non-farm */ ///
			+ EXP35 /* Other Rent */ ///
			) + ///
			1/sehc_price * ( ///
			  EXP75 /* Rental Equivalent of Owned Home */ ///
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

/*
gas_util
			1/ sehg_price * ( /// 
			  EXP40 /* Water */ ///
			) + ///
			1/sehe01_price * ( ///
			 EXP41 /* Fuel Oil */ ///
			) + ///

trans
 + ///
			1/ setc_price * ( ///
			  EXP53 /* Motor Vehicle Parts */ ///
			) + ///
			1/setd_price * ( ///
			  EXP54 /* Motor Vehicle Repair */ ///
			) + ///
			1/sete_price * ( ///
			  EXP57 /* Auto Insurance */ ///
			) + ///
			1/ setg_price * ( 
			  EXP58 /* Mass Transit */ ///
			) + ///
			1/ setg01_price * (
			 EXP60 /* Airline Fares */ ///
			)
