DROP TABLE IF EXISTS a;
DROP TABLE IF EXISTS b;


create table a 
    DISTKEY (surrogate_key) 
    SORTKEY (surrogate_key) 
as
select
    *,
    catgroup || sold || eventid || venueid || eventname || dateid as surrogate_key
from (
    select
        catgroup,
        s.qtysold as sold,
        e.eventid,
        e.venueid,
        e.eventname,
        l.dateid
    from
        category c
        inner join event as e on c.catid = e.catid
        inner join sales as s on e.eventid = s.eventid
        inner join listing as l on s.listid = l.listid
) as t
;


create table b 
    DISTKEY (surrogate_key) 
    SORTKEY (surrogate_key) 
as
select
    *,
    catgroup || sold || eventid || venueid || eventname || dateid as surrogate_key
from(
    select
        catgroup,
        s.qtysold as sold,
        e.eventid,
        e.venueid,
        e.eventname,
        l.dateid
    from
        category c
        inner join event as e on c.catid = e.catid
        inner join sales as s on e.eventid = s.eventid
        inner join listing as l on s.listid = l.listid
) as t
;


explain
select
    *
from
    a
    inner join b on a.surrogate_key = b.surrogate_key
;