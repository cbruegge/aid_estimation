
**************************************************************************
// Estimate a Nonlinear 5-good Almost Ideal Demand System

// Chris Bruegge 
// Updated October 8, 2014
**************************************************************************

use "/Users/chris.bruegge/workspace/aid_estimation/data/output/cleaned_data.dta"

keep if share_food ~= . & share_trans ~= . & share_housing ~= . & share_outside_good ~= . ///
	& lprice_food ~= . & lprice_trans ~= . & lprice_housing ~= . & lprice_outside_good ~= . & INC ~= . & INC > 0 & FAMSIZE ~= .

global num_demographic_vars = 2

do "/Users/chris.bruegge/workspace/aid_estimation/code/analysis/nlsuraids.do"

nlsur aids @ share_food share_trans share_housing ///
	lprice_food lprice_trans lprice_housing lprice_outside_good lexp ///
	FAMSIZE INC, ///
	parameters(a1 a2 a3 b1 b2 b3 ///
		g11 g12 g13 g22 g23 g33 ///
		d1 d2) neq(3) ifgnls

do "/Users/chris.bruegge/workspace/aid_estimation/code/analysis/elasticity_functions.do"

*mkmat share* in 105, matrix(W)
*mkmat lp* in 105, matrix(lnP)

matrix coeffs = e(b)
matrix vce_mat = e(V)

matrix Beta = coeffs[1,1..12]
matrix Sigma = vce_mat[1..12,1..12]


mata:
	Beta = st_matrix("Beta")
	Sigma = st_matrix("Sigma")
	alpha = get_alpha(Beta)
	beta = get_beta(Beta)
	gamma = get_gamma(Beta)
	W = st_matrix("W")
	lnP = st_matrix("lnP")
	
	calculate_eta(Beta,Sigma,W,lnP)
	eta_ij_t=calculate_eta_ij_t(Beta,Sigma,W,lnP)
	eta_ij_t
	n_goods = (-3 + sqrt(9 + 4*(4 + 2*length(Beta))))/2
	eta_t_readable = J(n_goods,n_goods,0)

	// Spot Chekc a Few Elasticities -- eta 11
	-1 + gamma[1,1]/W[1,1] - beta[1,1]*alpha[1,1]/W[1,1] - beta[1,1]/W[1,1]*(lnP*gamma[1..n_goods,1])

	// Spot Chekc a Few Elasticities -- eta 13
	gamma[1,3]/W[1,1] - beta[1,1]*alpha[3,1]/W[1,1] - beta[1,1]/W[1,1]*(lnP*gamma[1..n_goods,3])

	// Spot Chekc a Few Elasticities -- eta 42
	gamma[4,2]/W[1,4] - beta[4,1]*alpha[2,1]/W[1,4] - beta[4,1]/W[1,4]*(lnP*gamma[1..n_goods,2])

	for (ii=1;ii<=n_goods;ii++)
	{
		for (jj=1;jj<=n_goods;jj++)
		{
			if (abs(eta_ij_t[ii,jj]) > 1.96)
			{ 
				eta_t_readable[ii,jj] = 1 
			}
		}
	}
	eta_t_readable

end

local obs = _N

forvalues ii = 1/`obs' {

	disp "Row `ii':"
	
	mkmat share* in `ii', matrix(W)
	mkmat lp* in `ii', matrix(lnP)

	mata: Beta = st_matrix("Beta")
	mata: Sigma = st_matrix("Sigma")
	mata: alpha = get_alpha(Beta)
	mata: beta = get_beta(Beta)
	mata: gamma = get_gamma(Beta)
	mata: W = st_matrix("W")
	mata: lnP = st_matrix("lnP")

	if `ii' == 1 {
		mata: eta_ave = calculate_eta(Beta,Sigma,W,lnP)
	}
	else {
		mata: eta_ave = (`ii' - 1)/`ii' * eta_ave + 1/`ii' * calculate_eta(Beta,Sigma,W,lnP)
	}

	mata: eta_ave

}

disp "Average Eta:"
mata: eta_ave
