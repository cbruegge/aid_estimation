
**************************************************************************
// Estimate a Nonlinear 5-good Almost Ideal Demand System

// Chris Bruegge 
// Updated October 8, 2014
**************************************************************************

use "${local_directory}/data/output/cleaned_data.dta"

global num_demographic_vars = 19

do "${local_directory}/code/analysis/nlsuraids.do"

nlsur aids @ share_food share_gas_util share_trans share_housing ///
	lprice_food lprice_gas_util lprice_trans lprice_housing lprice_outside_good lexp ///
	CUTENUR1 CUTENUR4 CUTENUR6 RACE1 RACE2 RACE3 RACE4 MALE ///
	MARITAL1 MARITAL2 MARITAL3 MARITAL4 EMPSTAT1 EMPSTAT2 EMPSTAT3 EMPSTAT4 ///
	FAMSIZE AGE INC, ///
	parameters(a1 a2 a3 a4 b1 b2 b3 b4 ///
		g11 g12 g13 g14 g22 g23 g24 g33 g34 g44 ///
		d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12 d13 ///
		d14 d15 d16 d17 d18 d19) neq(4) ifgnls

do "${local_directory}/code/analysis/coeffs_to_elasticities.do"
