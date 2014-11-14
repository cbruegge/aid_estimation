
**************************************************************************
// Estimate a Nonlinear 5-good Almost Ideal Demand System

// Chris Bruegge 
// Updated October 8, 2014
**************************************************************************

use "${local_directory}/data/output/cleaned_data.dta"

global num_demographic_vars = 2

do "${local_directory}/code/analysis/nlsuraids.do"

nlsur aids @ share_food share_trans share_housing ///
	lprice_food lprice_trans lprice_housing lprice_outside_good lexp ///
	FAMSIZE INC, ///
	parameters(a1 a2 a3 b1 b2 b3 ///
		g11 g12 g13 g22 g23 g33 ///
		d1 d2) neq(3) ifgnls

do "${local_directory}/code/analysis/coeffs_to_elasticities.do"
