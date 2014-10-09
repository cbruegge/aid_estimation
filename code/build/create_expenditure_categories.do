*************************************************
*
* ./build/create_expenditure_categories.do
*
* Aggregates the BLS Data to N Expenditure 
* 	categories and creates budget share varaibles
*
*************************************************

* Create 5 Expenditure Categories

gen food = EXP23 /* Food Off-Premise */ ///
			+ EXP24 /* Food On-Premise */ ///
			+ EXP25 /* Food Furnished Employees */ ///
			+ EXP26 /* Tobacco Products */ ///
			+ EXP27 /* Alcohol Off-Premise */ ///
			+ EXP28 /* Alcohol On-Premise */ 


gen gas_util = EXP38 /* Electricity */ ///
			+ EXP39 /* Heating Gas */ ///
			+ EXP40 /* Water */ ///
			+ EXP41 /* Fuel Oil */ ///
			+ EXP55 /* Motor Vehicle Gas */ 


gen trans = EXP52 /* New and Used Motor Vehicles */ ///
			+ EXP53 /* Motor Vehicle Parts */ ///
			+ EXP54 /* Motor Vehicle Repair */ ///
			+ EXP56 /* Tolls */ ///
			+ EXP57 /* Auto Insurance */ ///
			+ EXP58 /* Mass Transit */ ///
			+ EXP59 /* Taxi & Misc Travel */ ///
			+ EXP60 /* Airline Fares */ 


gen housing = EXP34 /* Rent -- Tenant-occupied non-farm */ ///
			+ EXP35 /* Other Rent */ ///
			+ EXP36 /* Durable HH Equipment */ ///
			+ EXP37 /* Non-durable HH Equipment */ ///
			+ EXP42 /* Telephone */ ///
			+ EXP43 /* Domestic Service & Misc HH Operation */ ///
			+ EXP75 /* Rental Equivalent of Owned Home */ 


gen outside_good = EXP29 /* Clothing and Shoes */ ///
			+ EXP30 /* Clothing Services */ ///
			+ EXP31 /* Jewlery and Watches */ ///
			+ EXP32 /* Toiletries */ ///
			+ EXP33 /* Barbershops & Beauty Parlors */ ///
			+ EXP44 /* Drug Preparations */ ///
			+ EXP45 /* Orthopedic Appliance */ ///
			+ EXP46 /* Medical Professionals */ ///
			+ EXP47 /* Hospitals */ ///
			+ EXP48 /* Nursing Homes */ ///
			+ EXP49 /* Health Insurance */ ///
			+ EXP61 /* Books and Maps */ ///
			+ EXP62 /* Magazines */ ///
			+ EXP63 /* Sporting Goods */ ///
			+ EXP64 /* Other Rec. Services */ ///
			+ EXP66 /* Higher Edu. */ ///
			+ EXP67 /* Primary & Secondary Education */ ///
			+ EXP68 /* Other Education */ ///
			+ EXP69 /* Religions Activities */ 

			/*+ EXP50 /* Business Services */ /// */
			/*+ EXP51 /* Expense of Handilng Life Insurance */ /// */

* Create Budget Shares
gen tot_expenditure = food + gas_util + trans + housing + outside_good
gen lexp = log(tot_expenditure)
gen share_food = food / tot_expenditure
gen share_gas_util = gas_util / tot_expenditure
gen share_trans = trans / tot_expenditure
gen share_housing = housing / tot_expenditure
gen share_outside_good = outside_good / tot_expenditure

/*

food = EXP23 + EXP24 + EXP25
clothing = EXP29
rent_utilities = EXP34 + EXP38 + EXP39 + EXP40 + EXP41 + EXP42
medical = EXP44 + EXP45 + EXP46 + EXP47 + EXP48 + EXP49
motor_vehicle = EXP52 + EXP53 
furniture = EXP36
housing_interest = EXP76
housing_tax = EXP77
housing_goods = EXP78
life_insurance = EXP51
gifts_contributions = EXP69
personal_interest = EXP71 + EXP72
other_goods = EXP26 + EXP27 + EXP28 + EXP31 + EXP32 + EXP37 + EXP55 ///
	+ EXP61 + EXP62 + EXP63
other_services = EXP30 + EXP33 + EXP35 + EXP43 + EXP50 + EXP54 + EXP56 ///
	+ EXP57 + EXP58 + EXP59 + EXP60 + EXP64