DROP TABLE IF EXISTS a;
DROP TABLE IF EXISTS b;

create table a 
    DISTKEY (catgroup) 
    SORTKEY (catgroup) 
as
select
    catgroup,
    s.qtysold as sold,
    e.eventid,
    e.venueid,
    e.eventname,
    l.dateid
from
    category c
    inner join  event as e o n c.catid = e.catid
    inner join sales as s on e.eventid = s.eventid
    inner join listing as l on s.listid = l.listid
;

create table b 
    DISTKEY (catgroup) 
    SORTKEY (catgroup) 
as
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
;

explain
select
    *
from
    a
    inner join b on a.catgroup = b.catgroup
        and a.sold = b.sold
        and a.eventid = b.eventid
        and a.venueid = b.venueid
        and a.eventname = b.eventname
        and a.dateid = b.dateid;