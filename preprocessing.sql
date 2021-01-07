--create INDEX idx_orderdate on ORDERS(o_orderdate);
create index idx_part on PART(p_size, p_type);
create index idx_order on ORDERS(o_custkey, o_orderdate);
create INDEX idx_line on LINEITEM(l_orderkey, l_shipdate, l_commitdate, l_receiptdate);
create index idx_cust on CUSTOMER(c_mktsegment);
