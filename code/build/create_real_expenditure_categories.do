*************************************************
*
* ./cex/build/create_real_expenditure_categories.do
*
* Aggregates the BLS Data to N Expenditure 
* 	categories and creates budget share varaibles
*
*************************************************

* Create 5 Expenditure Categories

gen real_food = 1/SAF_price * ( ///
			  EXP(23) /* Food Off-Premise */ ///
			+ EXP(24) /* Food On-Premise */ ///
			+ EXP(25) /* Food Furnished Employees */ ///
			+ EXP(26) /* Tobacco Products */ ///
			+ EXP(27) /* Alcohol Off-Premise */ ///
			+ EXP(28) /* Alcohol On-Premise */ ///
			)

gen real_gas_util = 1/SAH2_price * ( ///
			  EXP(38) /* Electricity */ ///
			+ EXP(39) /* Heating Gas */ ///
			+ EXP(40) /* Water */ ///
			+ EXP(41) /* Fuel Oil */ ///
			+ EXP(55) /* Motor Vehicle Gas */ 
			)

gen real_trans = 1/SAT_price * ( ///
			  EXP(52) /* New and Used Motor Vehicles */ ///
			+ EXP(53) /* Motor Vehicle Parts */ ///
			+ EXP(54) /* Motor Vehicle Repair */ ///
			+ EXP(56) /* Tolls */ ///
			+ EXP(57) /* Auto Insurance */ ///
			+ EXP(58) /* Mass Transit */ ///
			+ EXP(59) /* Taxi & Misc Travel */ ///
			+ EXP(60) /* Airline Fares */ 
			)

gen real_housing = 1/SAH1_price * ( ///
			  EXP(34) /* Rent -- Tenant-occupied non-farm */ ///
			+ EXP(35) /* Other Rent */ ///
			+ EXP(75) /* Rental Equivalent of Owned Home */ ///
			) + ///
			1/SAH3_price * ( ///
			  EXP(36) /* Durable HH Equipment */ ///
			+ EXP(37) /* Non-durable HH Equipment */ ///
			+ EXP(42) /* Telephone */ ///
			+ EXP(43) /* Domestic Service & Misc HH Operation */ 


gen real_outside_good = 1/SAA_price * (
			  EXP(29) /* Clothing and Shoes */ ///
			+ EXP(30) /* Clothing Services */ ///
			+ EXP(31) /* Jewlery and Watches */ ///
			) + ///
			1/SAG_price * (
			+ EXP(32) /* Toiletries */ ///
			+ EXP(33) /* Barbershops & Beauty Parlors */ ///
			) + ///
			1/SAM_price * ( ///
			  EXP(44) /* Drug Preparations */ ///
			+ EXP(45) /* Orthopedic Appliance */ ///
			+ EXP(46) /* Medical Professionals */ ///
			+ EXP(47) /* Hospitals */ ///
			+ EXP(48) /* Nursing Homes */ ///
			+ EXP(49) /* Health Insurance */ ///
			) + ///
			*+ EXP(50) /* Business Services */ ///
			*+ EXP(51) /* Expense of Handilng Life Insurance */ ///
			1/SAR_price * ( ///
			  EXP(61) /* Books and Maps */ ///
			+ EXP(62) /* Magazines */ ///
			+ EXP(63) /* Sporting Goods */ ///
			+ EXP(64) /* Other Rec. Services */ ///
			) + ///
			1/SAE_price * (
			  EXP(66) /* Higher Edu. */ ///
			+ EXP(67) /* Primary & Secondary Education */ ///
			+ EXP(68) /* Other Education */ ///
			+ EXP(69) /* Religions Activities */ 
			)
