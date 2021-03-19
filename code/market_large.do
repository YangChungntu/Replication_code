clear
capture log close
set more off
cd "<YOUR WORK DIRECTION>"
* market.dta is provided by Lin et al. on OSF
use "data`c(dirsep)'market.dta" 

drop if userid_profile ==.
drop transactionid sellorderid bidorderid selleruserid buyeruserid time sideinitiated sellercost buyervalue price userid player playerrole unit orderid buysell bidask offer_time status transactedprice
drop optimalconsumersurplus optimalproducersurplus optimal_surplus mean_experience_robot mean_experience_nonrobot ConsumerSurplus ProducerSurplus surplus efficiency location_label type_label fund_label class_label time_label
drop if Number_players < 36
split valuecost, p(-) destring

unab vc:valuecost1 valuecost2 valuecost3 valuecost4 valuecost5 valuecost6 valuecost7 valuecost8 valuecost9 valuecost10 valuecost11 valuecost12 valuecost13 valuecost14 valuecost15

quietly foreach x of local vc {
	replace `x' = -1 if `x' == .
}

unab vc:valuecost1 valuecost2 valuecost3 valuecost4 valuecost5 valuecost6 valuecost7 valuecost8 valuecost9 valuecost10 valuecost11 valuecost12 valuecost13 valuecost14 valuecost15
/* max cost */
gen max_cost = 0
quietly foreach x of local vc {
	replace max_cost = `x' if `x' > max_cost
}
replace max_cost =. if role == "buyer"

/* min cost */
gen min_cost = valuecost1
replace min_cost =. if role == "buyer"

/* max value */
gen max_value = valuecost1
replace max_value =. if role == "seller"

/* min value */
gen min_value = 100000
quietly foreach x of local vc {
	replace min_value = `x' if `x' < min_value & `x' != -1
}
replace min_value =. if role == "seller"

/* #of goods per trader */
egen goods_per_trader = noccur(valuecost), string("-")
replace goods_per_trader = goods_per_trader + 1

/* #of buyer/seller */
gen buyer = (role == "buyer")
gen seller = (role == "seller")

gen more_than_two = ((role == "buyer" & valuecost2 >= eq_price)|(role == "seller" & valuecost2 <= eq_price))

collapse (sum) buyer seller more_than_two (mean) MarketID goods_per_trader eq_price eq_quantity (max) max_value max_cost (min) min_value min_cost, by(MarketID_period)

save "data/market_large_configuration", replace
