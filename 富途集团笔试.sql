create database if not exists test;
use test;
drop table if exists order_info;
drop table if exists client;
CREATE TABLE order_info (
id int(4) NOT NULL,
user_id int(11) NOT NULL,
product_name varchar(256) NOT NULL,
status varchar(32) NOT NULL,
client_id int(4) NOT NULL,
date date NOT NULL,
is_group_buy varchar(32) NOT NULL,
PRIMARY KEY (id));

CREATE TABLE client(
id int(4) NOT NULL,
name varchar(32) NOT NULL,
PRIMARY KEY (id)
);

INSERT INTO order_info VALUES
(1,557336,'C++','no_completed',1,'2025-10-10','No'),
(2,230173543,'Python','completed',2,'2025-10-12','No'),
(3,57,'JS','completed',0,'2025-10-23','Yes'),
(4,57,'C++','completed',3,'2025-10-23','No'),
(5,557336,'Java','completed',0,'2025-10-23','Yes'),
(6,57,'Java','completed',1,'2025-10-24','No'),
(7,557336,'C++','completed',0,'2025-10-25','Yes');

INSERT INTO client VALUES
(1,'PC'),
(2,'Android'),
(3,'IOS'),
(4,'H5');

-- The first question:
-- select a.id, a.is_group_buy, case when b.name is not null then b.name
-- else 'None' end as client_name
-- from order_info a
-- left join client b
-- on a.client_id = b.id
-- where a.date >= '2025-10-15'
-- and a.user_id in (select user_id
--                from order_info
--                where date >= '2025-10-15'
-- 			and `status` = 'completed'
--                and product_name in ('C++','Java', 'Python')
--                group by user_id
--                having count(*)>=2)
-- and a.`status` = 'completed'
-- and a.product_name in ('C++','Java', 'Python')
-- order by a.id

-- The second question:
select a.user_id, fd, sd,cnt
from
(
select user_id, min(date) as sd
from order_info
where date >= '2025-10-15'
and user_id in (select user_id from order_info
where date >= '2025-10-15'
and`status` = 'completed'
and product_name in ('C++', 'Java', 'Python')
group by user_id
having count(*)>=2)
and  `status` = 'completed'
and product_name in ('C++', 'Java', 'Python')
and (user_id, date) not in (select user_id, min(date)
from order_info
where date >= '2025-10-15'
and user_id in (select user_id from order_info
where date >= '2025-10-15'
and`status` = 'completed'
and product_name in ('C++', 'Java', 'Python')
group by user_id
having count(*)>=2)
and  `status` = 'completed'
and product_name in ('C++', 'Java', 'Python')
group by user_id)
group by user_id
order by user_id
) a join 
(select user_id, min(date) as fd
from order_info
where date >= '2025-10-15'
and user_id in (select user_id from order_info
where date >= '2025-10-15'
and`status` = 'completed'
and product_name in ('C++', 'Java', 'Python')
group by user_id
having count(*)>=2)
and  `status` = 'completed'
and product_name in ('C++', 'Java', 'Python')
group by user_id) b
on a.user_id = b.user_id
join 
(select user_id, count(*) as cnt
from order_info
where date >= '2025-10-15'
and user_id in (select user_id from order_info
where date >= '2025-10-15'
and`status` = 'completed'
and product_name in ('C++', 'Java', 'Python')
group by user_id
having count(*)>=2)
and  `status` = 'completed'
and product_name in ('C++', 'Java', 'Python')
group by user_id
)c
on a.user_id = c.user_id
