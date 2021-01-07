.timer on
select
	l_orderkey,
	revenue,
	o_orderdate,
	o_shippriority
from
	customer,
	(select o_custkey, o_orderdate, o_shippriority, l_shipdate, l_orderkey, sum(l_extendedprice*(1-l_discount)) as revenue
     from orders, LINEITEM
     where o_orderdate < "1995-03-15" --'[DATE]'
		and l_shipdate > "1995-03-15" --'[DATE]'
    	and l_orderkey = o_orderkey
     group by l_orderkey,
		o_orderdate,
		o_shippriority)
where
	c_mktsegment = 'BUILDING' --'[SEGMENT]'
    and c_custkey = o_custkey

order by
	revenue desc,
	o_orderdate;

-- optimization: push selections below joins - select rows 
-- from order and lineitem that meet the date predicates
-- and then join these rows with customer --> do selection of 
-- "BUILDING" only on these rows
-- 11/19:03:39: opt + index on o_orderdate, l_orderkey, c_custkey = ~25% faster (3.42)
-- 11/20:02:21: opt + index = ~40% faster (2.57)
--				opt: push most selection and group by in orders and lineitem 
--				below join with customer (different join order)