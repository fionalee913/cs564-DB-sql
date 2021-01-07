.timer on
select s_acctbal, s_name, n_name, p_partkey, p_mfgr, s_address, s_phone, s_comment
from(
SELECT 
	s_acctbal, s_name, n_name, p_partkey, p_mfgr, s_address, s_phone, s_comment, min(ps_supplycost)
FROM 
	part, supplier, partsupp, nation, region
WHERE 
	p_partkey = ps_partkey 
	AND s_suppkey = ps_suppkey
	AND p_size = 11 -- [SIZE]
	AND p_type like 'MEDIUM BRUSHED COPPER' -- '%[TYPE]'
	AND s_nationkey = n_nationkey
	AND n_regionkey = r_regionkey
	AND r_name = 'ASIA' -- '[REGION]'
group by ps_partkey
ORDER BY
	s_acctbal DESC,
	n_name,
	s_name,
	p_partkey
  );

-- instead of scanning part, supplier, nation and region twice, 
-- this optimized query scans all these tables and partsupp in the same query
-- and do the selection based on all predicates, producing a wanted table
-- but with the minimum ps_supplycost, and then select again to get rid of
-- that unwanted column
-- 11/20:08:54: create index on p_size and p_type = 99% improvement
--				opt: flatten the nested query so only scan all tables once