*************************************************
*
* ./cex/build/create_expenditure_categories.do
*
* Aggregates the BLS Data to N Expenditure 
* 	categories and creates budget share varaibles
*
*************************************************

* Create 5 Expenditure Categories

gen food = EXP(23) /* Food Off-Premise */ ///
			+ EXP(24) /* Food On-Premise */ ///
			+ EXP(25) /* Food Furnished Employees */ ///
			+ EXP(26) /* Tobacco Products */ ///
			+ EXP(27) /* Alcohol Off-Premise */ ///
			+ EXP(28) /* Alcohol On-Premise */ 


gen gas_util = EXP(38) /* Electricity */ ///
			+ EXP(39) /* Heating Gas */ ///
			+ EXP(40) /* Water */ ///
			+ EXP(41) /* Fuel Oil */ ///
			+ EXP(55) /* Motor Vehicle Gas */ 


gen trans = EXP(52) /* New and Used Motor Vehicles */ ///
			+ EXP(53) /* Motor Vehicle Parts */ ///
			+ EXP(54) /* Motor Vehicle Repair */ ///
			+ EXP(56) /* Tolls */ ///
			+ EXP(57) /* Auto Insurance */ ///
			+ EXP(58) /* Mass Transit */ ///
			+ EXP(59) /* Taxi & Misc Travel */ ///
			+ EXP(60) /* Airline Fares */ 


gen housing = EXP(34) /* Rent -- Tenant-occupied non-farm */ ///
			+ EXP(35) /* Other Rent */ ///
			+ EXP(36) /* Durable HH Equipment */ ///
			+ EXP(37) /* Non-durable HH Equipment */ ///
			+ EXP(42) /* Telephone */ ///
			+ EXP(43) /* Domestic Service & Misc HH Operation */ ///
			+ EXP(75) /* Rental Equivalent of Owned Home */ 


gen outside_good = EXP(29) /* Clothing and Shoes */ ///
			+ EXP(30) /* Clothing Services */ ///
			+ EXP(31) /* Jewlery and Watches */ ///
			+ EXP(32) /* Toiletries */ ///
			+ EXP(33) /* Barbershops & Beauty Parlors */ ///
			+ EXP(44) /* Drug Preparations */ ///
			+ EXP(45) /* Orthopedic Appliance */ ///
			+ EXP(46) /* Medical Professionals */ ///
			+ EXP(47) /* Hospitals */ ///
			+ EXP(48) /* Nursing Homes */ ///
			+ EXP(49) /* Health Insurance */ ///
			*+ EXP(50) /* Business Services */ ///
			*+ EXP(51) /* Expense of Handilng Life Insurance */ ///
			+ EXP(61) /* Books and Maps */ ///
			+ EXP(62) /* Magazines */ ///
			+ EXP(63) /* Sporting Goods */ ///
			+ EXP(64) /* Other Rec. Services */ ///
			+ EXP(66) /* Higher Edu. */ ///
			+ EXP(67) /* Primary & Secondary Education */ ///
			+ EXP(68) /* Other Education */ ///
			+ EXP(69) /* Religions Activities */ 


* Create Budget Shares
gen tot_expenditure = food + gas_util + trans + housing + outside_good
gen lexp = log(tot_expenditure)
gen share_food = food / tot_expenditure
gen share_gas_util = gas_util / tot_expenditure
gen share_trans = trans / tot_expenditure
gen share_housing = housing / tot_expenditure
gen share_outside_good = outside_good / tot_expenditure

/*

food = EXP(23) + EXP(24) + EXP(25)
clothing = EXP(29)
rent_utilities = EXP(34) + EXP(38) + EXP(39) + EXP(40) + EXP(41) + EXP(42)
medical = EXP(44) + EXP(45) + EXP(46) + EXP(47) + EXP(48) + EXP(49)
motor_vehicle = EXP(52) + EXP(53) 
furniture = EXP(36)
housing_interest = EXP(76)
housing_tax = EXP(77)
housing_goods = EXP(78)
life_insurance = EXP(51)
gifts_contributions = EXP(69)
personal_interest = EXP(71) + EXP(72)
other_goods = EXP(26) + EXP(27) + EXP(28) + EXP(31) + EXP(32) + EXP(37) + EXP(55) ///
	+ EXP(61) + EXP(62) + EXP(63)
other_services = EXP(30) + EXP(33) + EXP(35) + EXP(43) + EXP(50) + EXP(54) + EXP(56) ///
	+ EXP(57) + EXP(58) + EXP(59) + EXP(60) + EXP(64)