
**************************************************************************
// Estimate a Nonlinear 5-good Almost Ideal Demand System

// Chris Bruegge 
// Updated October 8, 2014
**************************************************************************

use "${local_directory}/data/output/cleaned_data.dta"

global num_demographic_vars = 10

do "${local_directory}/code/analysis/nlsuraids.do"

nlsur aids @ share_food share_trans share_housing ///
	lprice_food lprice_trans lprice_housing lprice_outside_good lexp ///
	CUTENUR1 CUTENUR4 CUTENUR6 RACE1 RACE2 RACE3 RACE4 ///
	FAMSIZE AGE INC, ///
	parameters(a1 a2 a3 b1 b2 b3 ///
		g11 g12 g13 g22 g23 g33 ///
		d1 d2 d3 d4 d5 d6 d7 d8 d9 d10) neq(3) ifgnls

do "${local_directory}/code/analysis/coeffs_to_elasticities.do"
