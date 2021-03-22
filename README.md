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
1. Data process
- Download market.dta and market_size.do from Lin et al. on OSF (https://osf.io/3grmn/).
- Run market_size.do to generate market_aggregate_large.dta and market_aggregate_large.dta.   
- Run market_large.do to create the DTA file, market_large_configurations.dta. This file can be found in the folder "data" as well.  


2. Zero-intelligence Simulation
- Run ZI_default.ipynb for results in raw 1 of Table 6 and row 2 of Table 9 (Default), saved at simulation_output.dta.    
- Run ZI_small.ipynb for results in row 2 of Table 6 (Small Market), saved at simulation_output_small.dta.    
- Run ZI_large_1.ipynb for results in row 3 of Table 6 (Large Market 1), saved at simulation_output_large_1.dta. 
- Run ZI_large_comp.ipynb for results in rest of the rows of Table 6 (Large Market 2, 3, 4, 5), saved at simulation_output_large_2.dta, simulation_output_large_3.dta, simulation_output_large_4.dta, and simulation_output_large_5.dta.    
    
- Run ZI_unsorted.ipynb for results in row 3 of Table 9 (Unsorted v & c), saved at simulation_output_unsorted.dta.    
- Run ZI_random_draw.ipynb for results in row 4 of Table 9 (Redraw v & c), saved at simulation_output_random_draw.dta.     
- Run ZI_iteration.ipynb for results in row 5 of Table 9 (Iterate 200 & Iterate 100), saved at simulation_output_iteration200.dta & simulation_output_iteration100.dta.  
- Run ZI_uniform.ipynb for results row 7 of in Table 9 (Uniform), saved at simulation_output_unform.dta.      

3. Data visualization  
- Run viz.Rmd for all the figures in the report, which requires: 
  > packages_functions.R: package setting and functions
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


## Refferences  
1. Lin, P.-H., Brown, A. L., Imai, T., Wang, J. T.-y., Wang, S. W. & Camerer, C. F. (2020), ‘Evidence of general economic principles of bargaining and trade from 2,000 classroom ex-periments’, Nature Human Behaviour4(9), 917–927.    
2. Cason, T. N. & Friedman, D. (1996), ‘Price formation in double auction markets’, Journal of Economic Dynamics and Control 20(8), 1307–1337.    
3. Friedman, D. (1991), ‘A simple testable model of double auction markets’, Journal of EconomicBehavior & Organization 15(1), 47–70.    
4. LeBaron, B. (2020), ‘Zero Intelligence Traders: Gode and Sunder (1993)’ [Online]. Available at: http://people.brandeis.edu/~blebaron/classes/agentfin/GodeSunder.html (Accessed: 22 March 2021).    

