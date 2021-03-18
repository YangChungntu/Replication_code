# Replication_code

## Content  
code:  
> packages_functions.R  
> viz.Rmd  
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

## Enviroment  
Python 3.8.5  
R      4.0.3  

## Discribtion

1. Zero-intelligence simulation  
    Go to the folder "code/simulation_code".   
    
    Results in Table 6: 
    - ZI_default.ipynb...default  
    - ZI_small.ipynb...small market  
    - ZI_large_1.ipynb...large market 1  
    - ZI_large_comp.ipynb...large market 2, 3, 4, 5
    
    Results in Table 9:  
    - ZI_unsorted.ipynb...row 3  
    - ZI_random_draw.ipynb...row 4  
    - ZI_iteration.ipynb...row 5  
    - ZI_uniform.ipynb...row 6  

2. data visualization  
Run viz.Rmd for all the figures in the report.  
packages_functions.R...packege setting and functions for viz.Rmd

The folder "data" contains data needed in viz.Rmd. "market_large_configurations.dta" is a processed version of data from Lin et al. All other data are ZI simulation results that can be generate using our code.  

Refferences:  
http://people.brandeis.edu/~blebaron/classes/agentfin/GodeSunder.html
