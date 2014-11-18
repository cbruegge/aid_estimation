
**************************************************************************
// Estimate a Nonlinear 5-good Almost Ideal Demand System

// Chris Bruegge 
// Updated October 8, 2014
**************************************************************************

clear
global local_directory = "/Users/chris.bruegge/workspace/aid_estimation"

* Import Function Files
do "${local_directory}/code/analysis/nlsuraids.do"
do "${local_directory}/code/analysis/elasticity_functions.do"


use "${local_directory}/data/output/cleaned_data.dta"

keep if INC ~= . & INC > 0 & FAMSIZE ~= .

global num_demographic_vars = 3
local n_eqns = 3

local demographic_var_coeffs = ""
local num_demographic_var_coeffs = ${num_demographic_vars} * `n_eqns'
forvalues ii = 1/`num_demographic_var_coeffs' {
		local demographic_var_coeffs = "`demographic_var_coeffs' d`ii'"
	}


nlsur aids @ share_food share_trans share_housing ///
	lprice_food lprice_trans lprice_housing lprice_outside_good lexp ///
	RACE1 INC FAMSIZE, ///
	parameters(a1 a2 a3 b1 b2 b3 ///
		g11 g12 g13 g22 g23 g33 ///
		`demographic_var_coeffs') neq(`n_eqns') ifgnls

* Calculate Elasticities

* For a Person with the Average Characteristics
egen avg_share_food = mean(share_food)
egen avg_share_trans = mean(share_trans)
egen avg_share_housing = mean(share_housing)
egen avg_share_outside_good = mean(share_outside_good)

mkmat avg_share* in 1, matrix(W)
mkmat lp* in 1, matrix(lnP)

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
/*
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