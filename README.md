# Read me

## Content  
code:  
> packages_functions.R  
> viz.Rmd  
> market_large.do   
> simulation_code:  
>> ZI_default.ipynb 
>> ZI_small.ipynb  
>> ZI_large_1.ipynb  
>> ZI_large_comp.ipynb  
>> ZI_unsorted.ipynb 
>> ZI_random_draw.ipynb 
>> ZI_iteration.ipynb 
>> ZI_uniform.ipynb.  

  
data:  
> simulation_output.dta  
> simulation_output_small.dta  
> simulation_output_large_1.dta  
> simulation_output_large_2.dta   
> simulation_output_large_3.dta  
> simulation_output_large_4.dta  
> simulation_output_large_5.dta  
> market_large_configurations.dta  
> market_aggregate_large.dta   
> market_aggregate_small.dta

## Enviroment  
- Python 3.8.5  
- R      4.0.3 
- Stata  14.1 

## Procedure
1. Zero-intelligence Simulation
- Run ZI_default.ipynb for results in Table 6, Raw 1, and Table 9, Raw 2 (Default)  
  - simulation_output.dta will be created.   
- Run ZI_small.ipynb for results in Table 6, Raw 2 (Small Market)   
  - simulation_output_small.dta will be created. 
- Run ZI_large_1.ipynb for results in Table 6, Raw 3 (Large Market 1)  
  - simulation_output_large_1.dta will be created. 
- Run ZI_large_comp.ipynb for results in rest of the raws of Table 6 (Large Market 2, 3, 4, 5)   
  - simulation_output_large_2.dta, simulation_output_large_3.dta, simulation_output_large_4.dta, and simulation_output_large_5.dta will be created.        
    

- Run ZI_unsorted.ipynb for results in Table 9, Raw 3 (Unsorted v & c)
  - simulation_output_unsorted.dta will be created.   
- Run ZI_random_draw.ipynb for results in Table 9, Raw 4 (Redraw v & c)  
  - simulation_output_random_draw.dta will be created.   
- Run ZI_iteration.ipynb for results in Table 9, Raw 5 & 6 (Iterate 200 & Iterate 100)  
  - simulation_output_iteration200.dta & simulation_output_iteration100.dta will be created.    
- Run ZI_uniform.ipynb for results in Table 9, Raw 7 (Uniform) 
  - simulation_output_unform.dta will be created.     

2. Data visualization  
- Run viz.Rmd for all the figures in the report.  
  - packages_functions.R helps packege setting and contains functions for viz.Rmd

3. Data process
- Run market_large.do to create the DTA file, market_large_configurations.dta. This file can be found in the folder "data" as well.  
  - Runing this do file requires the DTA file, market.dta from Lin et al. on OSF (https://osf.io/3grmn/).
- Two other DTA files, market_aggregate_large.dta and market_aggregate_large.dta, are created using the code from Lin et al.

Refferences:  
ZI simulation: http://people.brandeis.edu/~blebaron/classes/agentfin/GodeSunder.html
