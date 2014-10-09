
**************************************************************************
// Estimate a Nonlinear 5-good Almost Ideal Demand System

// Chris Bruegge 
// Updated October 8, 2014
**************************************************************************

use "${local_directory}/data/output/cleaned_data.dta"

do "${local_directory}/code/analysis/nlsuraids.do"

nlsur aids @ share_food share_gas_util share_trans share_housing ///
	lprice_food lprice_gas_util lprice_trans lprice_housing lprice_outside_good lexp, ///
	parameters(a1 a2 a3 a4 b1 b2 b3 b4 ///
		g11 g12 g13 g14 g22 g23 g24 g33 g34 g44) neq(4) ifgnls



