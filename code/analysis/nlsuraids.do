cap program drop nlsuraids
program nlsuraids
  version 13
  syntax varlist(min=8) [if], at(name)
  tokenize `varlist'

  * Change lenght_varlist - 2 later ... right now I'm using 2 demographic attributes
  local length_varlist : word count `varlist' 

  local n_goods = (`length_varlist'-${num_demographic_vars}) / 2
  local n_eqns = `n_goods' - 1

  local alpha0 = 5
  local g_index = 2*(`n_eqns')
        
  tempname a`n_goods'
  tempname b`n_goods' 
  tempname g`n_goods'`n_goods'
  tempvar lnpindex         

  scalar `a`n_goods'' = 1
  scalar `b`n_goods'' = 0
  scalar `g`n_goods'`n_goods'' = 0
  qui gen double `lnpindex' = `alpha0' 

  * Set locals for the input args
  forvalues arg = 1/`n_eqns' {
    local w`arg' = "``arg''"
  }
           
  forvalues arg = 1/`n_goods' {
    local ii = `arg' + `n_eqns'
    local lnp`arg' = "``ii''"
  }

  local lnm_index = `n_goods' + `n_eqns' + 1
  local lnm = "``lnm_index''"

  * Demographic Variables are the last elements of varlist
  forvalues arg = 1/${num_demographic_vars} {
    local dem_var`arg'_index = `lnm_index' + `arg'
    local dem_var`arg' = "`dem_var`arg'_index'"
  }

  forvalues ii = 1/`n_eqns' {

    local a_index = `ii'
    local b_index = `n_eqns' + `ii'

    tempname a`ii' b`ii'
    scalar `a`ii'' = `at'[1,`a_index']
    scalar `b`ii'' = `at'[1,`b_index']

    scalar `a`n_goods'' = `a`n_goods'' - `a`ii''
    scalar `b`n_goods'' = `b`n_goods'' - `b`ii''

    * Update the price index with the alpha parameters
    qui replace `lnpindex' = `lnpindex' + `a`ii''*`lnp`ii'' `if'  

    * The last g in the i'th row is given by sum_i g_ij = 0
    tempname g`ii'`n_goods'
    scalar `g`ii'`n_goods'' = 0

    forvalues jj = 1/`n_goods' {

      if `jj' < `ii' {
        tempname g`ii'`jj'
        scalar `g`ii'`jj'' = `g`jj'`ii''
       * Get the last element in the column
        scalar `g`ii'`n_goods'' = `g`ii'`n_goods'' - `g`ii'`jj''
      }
      else if `jj' >= `ii' & `jj' < `n_goods' {
        local g_index = `g_index' + 1
        tempname g`ii'`jj'
        scalar `g`ii'`jj'' = `at'[1,`g_index']
        * Get the last element in the column
        scalar `g`ii'`n_goods'' = `g`ii'`n_goods'' - `g`ii'`jj''
      } 
      else {
        * Define the bottom row of the g matrix
        tempname g`jj'`ii'
        scalar `g`jj'`ii'' = `g`ii'`jj''
        * Get the last element in the g matrix
        scalar `g`n_goods'`n_goods'' = `g`n_goods'`n_goods'' - `g`ii'`n_goods''
      } 

      * Update the Price Index
      qui replace `lnpindex' = `lnpindex' + 0.5*`g`ii'`jj''*`lnp`ii''*`lnp`jj'' `if'

    }

  }

  * Demographic Variables are the last elements of varlist
  local num_demographic_coefficients = ${num_demographic_vars} * `n_eqns'
  forvalues arg = 1/`num_demographic_coefficients' {
    local d`arg'_index = `g_index' + `arg'
    tempname d`arg'
    scalar `d`arg'' = `at'[1,`d`arg'_index']
  }

  quietly {
    local d_index = 0
    forvalues ii = 1/`n_eqns' {
      replace `w`ii'' = `a`ii'' + `b`ii''*(`lnm' - `lnpindex') `if'
      
      * Price Coefficients
      forvalues jj = 1/`n_goods' {
        replace `w`ii'' = `w`ii'' + `g`ii'`jj''*`lnp`jj''
      }

      * Demographic Coefficients
      forvalues kk = 1/${num_demographic_vars} {
          local d_index = `d_index' + 1
          replace `w`ii'' = `w`ii'' + `d`d_index''*`dem_var`kk'' 
      }


    }
	} 

end                    

