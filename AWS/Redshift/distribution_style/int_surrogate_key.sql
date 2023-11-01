DROP TABLE IF EXISTS a;
DROP TABLE IF EXISTS b;

create table a
    DISTKEY (ds_surrogate_key)
    SORTKEY (ds_surrogate_key)
as 
select 
    *
    , catgroup||sold||eventid||venueid||eventname||dateid as surrogate_key
    , dense_rank() OVER(order by surrogate_key) as ds_surrogate_key
from (
    select 
        catgroup
        , s.qtysold as sold
        , e.eventid
        , e.venueid
        , e.eventname
        , l.dateid
    from category c
        inner join event as e on c.catid = e.catid
        inner join sales as s on e.eventid = s.eventid
        inner join listing as l on s.listid = l.listid
) as t
;

create table b
    DISTKEY (ds_surrogate_key)
    SORTKEY (ds_surrogate_key)
as 
select 
    *
    , catgroup||sold||eventid||venueid||eventname||dateid as surrogate_key
    , dense_rank() OVER(order by surrogate_key) as ds_surrogate_key
from (
    select 
        catgroup
        , s.qtysold as sold
        , e.eventid
        , e.venueid
        , e.eventname
        , l.dateid
    from category c
        inner join event as e on c.catid = e.catid
        inner join sales as s on e.eventid = s.eventid
        inner join listing as l on s.listid = l.listid    
) as t
;

explain
select *
from a 
inner join b on a.ds_surrogate_key = b.ds_surrogate_key
;

