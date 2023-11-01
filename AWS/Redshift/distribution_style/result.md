* exe_plan_multi_join_key
```
XN Hash Join DS_DIST_NONE  (cost=4311.40..236264.73 rows=87630 width=76)	
  Hash Cond: (("outer".eventid = "inner".eventid) AND (("outer".eventname)::text = ("inner".eventname)::text) AND ("outer".dateid = "inner".dateid) AND ("outer".venueid = "inner".venueid) AND ("outer".sold = "inner".sold) AND (("outer".catgroup)::text = ("inner".catgroup)::text))	
  ->  XN Seq Scan on a  (cost=0.00..1724.56 rows=172456 width=38)	
  ->  XN Hash  (cost=1724.56..1724.56 rows=172456 width=38)	
        ->  XN Seq Scan on b  (cost=0.00..1724.56 rows=172456 width=38)	
```

* exe_plan_string_surrogate_key
```
XN Merge Join DS_DIST_NONE  (cost=0.00..6138.73 rows=183355 width=144)	
  Merge Cond: (("outer".surrogate_key)::text = ("inner".surrogate_key)::text)	
  ->  XN Seq Scan on a  (cost=0.00..1724.56 rows=172456 width=72)	
  ->  XN Seq Scan on b  (cost=0.00..1724.56 rows=172456 width=72)	
```

* exe_plan_int_surrogate_key
```
XN Merge Join DS_DIST_NONE  (cost=0.00..6157.27 rows=184676 width=160)	
  Merge Cond: ("outer".ds_surrogate_key = "inner".ds_surrogate_key)	
  ->  XN Seq Scan on a  (cost=0.00..1724.56 rows=172456 width=80)	
  ->  XN Seq Scan on b  (cost=0.00..1724.56 rows=172456 width=80)	
```