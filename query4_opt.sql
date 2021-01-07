.timer on
select
	o_orderpriority,
	count(o_orderkey) as order_count
from
	orders
where
	o_orderdate >= "1993-07-01" --'[DATE]'
	and o_orderdate < "1993-10-01" --'[DATE]'
	and exists (
		select
			l_orderkey
		from
			lineitem
		where
			l_orderkey = o_orderkey
			and l_commitdate < l_receiptdate
			)
group by
	o_orderpriority
order by
	o_orderpriority;


-- opt time in report now is using query4.sql with index created in preprocessing
-- any possible modification can be done???
-- 11/21:03:04: opt(select single column instead of a row) + index on l_dates = 57% (0.62)