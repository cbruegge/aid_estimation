******************************************************
* 
*	Calculates Elasticities from AID Coefficients
*
******************************************************

// Create a matrix of Budget Shares
mkmat w*, matrix(W)
mkmat lnp*, matrix(lnP)

matrix Beta = e(b)
matrix Sigma = e(V)

mata: mata clear

mata:
function get_gamma(Beta)
{
	// From the larger root to the quadratic equation
	n_goods = (-3 + sqrt(9 + 4*(4 + 2*length(Beta))))/2
	n_eqns = n_goods - 1

	// Extract Coefficients
	gamma = J(n_goods,n_goods,0)

	gamma_index = 2*n_goods - 2

	for (ii=1; ii<n_goods; ii++)
	{
		for (jj=1; jj<n_goods; jj++)
		{
			
			if (jj >= ii)
			{
				gamma_index++
				gamma[ii,jj] = Beta[1,gamma_index]	
			}
			else
			{
				gamma[ii,jj] = gamma[jj,ii]
			}
		}
		gamma[ii,n_goods] = -sum(gamma[ii,1..n_eqns])
	}
	gamma[n_goods,1..n_eqns] = gamma[1..n_eqns,n_goods]'
	gamma[n_goods,n_goods] = -sum(gamma[n_goods,1..n_eqns])

	return(gamma)
}

function get_alpha(Beta)
{
	// From the larger root to the quadratic equation
	n_goods = (-3 + sqrt(9 + 4*(4 + 2*length(Beta))))/2
	n_eqns = n_goods - 1

	// Extract Coefficients
	alpha = J(n_goods,1,0)

	for (ii=1; ii<n_goods; ii++)
	{
		alpha[ii,1] = Beta[1,ii]

	}
	alpha[n_goods,1] = 1-sum(alpha[1..n_eqns,1])
	return(alpha)
}

function get_beta(Beta)
{

	// From the larger root to the quadratic equation
	n_goods = (-3 + sqrt(9 + 4*(4 + 2*length(Beta))))/2
	n_eqns = n_goods - 1

	// Extract Coefficients
	beta = J(n_goods,1,0)

	for (ii=1; ii<n_goods; ii++)
	{
		beta[ii,1] = Beta[1,ii + n_eqns]

	}
	beta[n_goods,1] = -sum(beta[1..n_eqns,1])
	return(beta)
}
end


mata:
function calculate_eta(Beta, Sigma, W, lnP)
{

	W = W[rows(W),1..cols(W)]
	lnP = lnP[rows(lnP),1..cols(lnP)]

	// From the larger root to the quadratic equation
	n_goods = (-3 + sqrt(9 + 4*(4 + 2*length(Beta))))/2
	n_eqns = n_goods - 1

	// Extract Coefficients
	alpha = get_alpha(Beta)
	beta = get_beta(Beta)
	gamma = get_gamma(Beta)

	// Calculate Elasticities
	eta = cholinv(diag(W))*(gamma-beta*(alpha' + lnP*gamma)) - I(rows(gamma),cols(gamma))
	return(eta)
}
end

mata:
function calculate_eta_se(Beta, Sigma, W, lnP)
{
	n_goods = (-3 + sqrt(9 + 4*(4 + 2*length(Beta))))/2
	del_g = J(length(Beta),n_goods,0)
	
	for (ii=1; ii<=length(Beta); ii++)
	{
		del_Beta = Beta
		del_Beta[1,ii] = del_Beta[1,ii] + .0001

		del_g[ii,1..n_goods] = /*
			*/ (diagonal(calculate_eta(del_Beta, Sigma, W, lnP))' /*
			*/ - diagonal(calculate_eta(Beta, Sigma, W, lnP))') / .0001
	}	
	
	own_price_eta_se = sqrt(diagonal(del_g' * Sigma * del_g))
	return(own_price_eta_se)
}
end

mata:
function calculate_eta_se_ij(Beta, Sigma, W, lnP,row_i, col_j)
{
	n_goods = (-3 + sqrt(9 + 4*(4 + 2*length(Beta))))/2
	del_g = J(length(Beta),1,0)
	
	for (ii=1; ii<=length(Beta); ii++)
	{
		del_Beta = Beta
		del_Beta[1,ii] = del_Beta[1,ii] + .0001

		del_eta = /*
			*/ (calculate_eta(del_Beta, Sigma, W, lnP) /*
			*/ - calculate_eta(Beta, Sigma, W, lnP)') / .0001

		del_g[ii,1] = del_eta[row_i,col_j]
	}	
	
	own_price_eta_se = sqrt(del_g' * Sigma * del_g)
	return(own_price_eta_se)
}
end

mata:
function calculate_eta_t(Beta,Sigma,W,lnP)
{
	return(diagonal(calculate_eta(Beta, Sigma, W, lnP)) /*
		*/ :/ calculate_eta_se(Beta, Sigma, W, lnP))
}
end

mata:
function calculate_eta_ij_t(Beta,Sigma,W,lnP)
{
	n_goods = (-3 + sqrt(9 + 4*(4 + 2*length(Beta))))/2
	eta = calculate_eta(Beta,Sigma,W,lnP)
	eta_t = J(n_goods,n_goods,0)
	for (ii=1;ii<=n_goods;ii++)
	{
		for (jj=1;jj<=n_goods;jj++)
		{
			eta_t[ii,jj] = eta[ii,jj]/calculate_eta_se_ij(Beta,Sigma,W,lnP,ii,jj)		
		}
	}

	return(eta_t)
}
end

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
