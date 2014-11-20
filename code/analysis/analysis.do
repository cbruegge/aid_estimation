
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


global num_demographic_vars = 4

nlsur aids @ share_food share_gas_util share_trans share_housing ///
	lprice_food lprice_gas_util lprice_trans lprice_housing lprice_outside_good lexp ///
	RACE1 FAMSIZE AGE INC, ///
	parameters(a1 a2 a3 a4 b1 b2 b3 b4 ///
		g11 g12 g13 g14 g22 g23 g24 g33 g34 g44 ///
		d1 d2 d3 d4) neq(4) ifgnls

* Calculate Elasticities

* For a Person with the Average Characteristics
egen avg_share_food = mean(share_food)
egen avg_share_gas_util = mean(share_gas_util)
egen avg_share_trans = mean(share_trans)
egen avg_share_housing = mean(share_housing)
egen avg_share_outside_good = mean(share_outside_good)

mkmat avg_share* in 1, matrix(W)
mkmat lp* in 1, matrix(lnP)

matrix coeffs = e(b)
matrix vce_mat = e(V)

matrix Beta = coeffs[1,1..18]
matrix Sigma = vce_mat[1..18,1..18]


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
