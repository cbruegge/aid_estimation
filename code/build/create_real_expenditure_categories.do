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
			+ EXP27 /* Alcohol Off-Premise */ ///
			+ EXP28 /* Alcohol On-Premise */ ///
			+ EXP26 /* Tobacco Products */ ///
			)

gen real_trans = 1/sat * ( ///
			  EXP52 /* New and Used Motor Vehicles */ ///
			+ EXP53 /* Motor Vehicle Parts */ ///
			+ EXP54 /* Motor Vehicle Repair */ ///
			+ EXP55 /* Motor Vehicle Gas */ ///			
			+ EXP57 /* Auto Insurance */ ///
			+ EXP58 /* Mass Transit */ ///
			+ EXP60 /* Airline Fares */ ///
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
