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

gen trans =   EXP52 /* New and Used Motor Vehicles */ ///
			+ EXP53 /* Motor Vehicle Parts */ ///
			+ EXP54 /* Motor Vehicle Repair */ ///
			+ EXP55 /* Motor Vehicle Gas */ ///
			+ EXP57 /* Auto Insurance */ ///
			+ EXP58 /* Mass Transit */ ///
			+ EXP60 /* Airline Fares */ 

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
			/* 			+ EXP56 /* Tolls */ /// */ 
			/* 			+ EXP59 /* Taxi & Misc Travel */ /// */ 


* Create Budget Shares
gen tot_expenditure = food + trans + outside_good
gen lexp = log(tot_expenditure)
gen share_food = food / tot_expenditure
gen share_trans = trans / tot_expenditure
gen share_outside_good = outside_good / tot_expenditure

