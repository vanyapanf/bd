/*1 select*/
WITH T(id_product,Q) AS (SELECT T1.id_product,count(id_operation) FROM (SELECT *
FROM vitrine WHERE id_product NOT IN (SELECT id_product FROM auction)) AS T1 join operation on T1.id_product=operation.id_product
GROUP BY T1.id_product),
     TT(id_product,Q1) AS (SELECT T1.id_product,T1.price FROM (SELECT * FROM vitrine WHERE id_product NOT IN (SELECT id_product FROM auction))
AS T1)
SELECT avg(sqrt(((delivery_adress::point)[0]-(coordinates::point)[0])^2+((delivery_adress::point)[1]-(coordinates::point)[1])^2))
FROM operation join storage_cell on operation.id_product=storage_cell.id_product join consumer on operation.id_consumer = consumer.id_user
WHERE operation.id_product IN (SELECT T.id_product FROM T join TT on T.id_product=TT.id_product WHERE T.Q*TT.Q1=(SELECT max(T.Q*TT.Q1)
FROM T join TT on T.id_product=TT.id_product));
/*2 select*/
WITH T(id_user,Q1) AS (SELECT id_sender,count(id_sender) FROM bill WHERE message='true_coin' GROUP BY id_sender),
     T1(id_user,Q2) AS (SELECT id_reciever,count(id_reciever) FROM bill WHERE message='true_coin' GROUP BY id_reciever)
SELECT * FROM ((SELECT T.id_user FROM T ORDER BY T.Q1 DESC LIMIT 3)UNION ALL(SELECT T1.id_user FROM T1 ORDER BY T1.Q2 DESC LIMIT 3)) as a;
/*3 select*/
WITH T(id_auction,Q) AS (SELECT auction.*,COALESCE(count(id_bet),0) FROM bet left join auction on bet.id_auction=auction.id_auction
GROUP BY auction.id_auction) SELECT * FROM T WHERE Q<(SELECT avg(Q) FROM T);
/*4 select*/
WITH T(id_user,Q) AS (SELECT id_user, count(*) FROM auction join product on auction.id_product = product.id_product
WHERE status='not active' GROUP BY product.id_user),
     T1(id_user,Q1) AS ( WITH T2(id_auction,Q2) AS (SELECT id_auction,max(bet_value) FROM bet GROUP BY id_auction)
       SELECT id_user,count(*) FROM bet join auction on bet.id_auction=auction.id_auction join T2 on bet.id_auction=T2.id_auction
       WHERE status = 'not active' AND bet_value=Q2 GROUP BY id_user)
SELECT T.id_user FROM T join T1 on T.id_user=T1.id_user WHERE Q=Q1 AND Q>0;
/*5 select*/
WITH T(Q) AS (SELECT pg_column_size(serial_num)+pg_column_size(bill_size)+pg_column_size(ecp)+pg_column_size(id_sender)+
pg_column_size(id_reciever)+pg_column_size(message) as rowsize FROM bill WHERE message<>'true_coin'),
     T1(Q) AS (SELECT pg_column_size(id_auction)+pg_column_size(first_price)+pg_column_size(step_auction)+pg_column_size(time_ending)+
pg_column_size(status)+pg_column_size(id_product) as rowsize FROM auction WHERE status='not active'),
     T2(Q) AS (SELECT pg_column_size(id_bet)+pg_column_size(bet_value)+pg_column_size(id_user)+pg_column_size(id_auction)
as rowsize FROM bet WHERE id_auction IN (SELECT id_auction FROM auction WHERE status='not active')),
     T3(Q) AS (SELECT pg_column_size(coordinates)+pg_column_size(id_seller_owner) as rowsize FROM storage WHERE coordinates NOT
IN (SELECT coordinates FROM storage_cell))
SELECT sum(Q) FROM (SELECT * FROM T UNION ALL SELECT * FROM T1 UNION ALL SELECT * FROM T2 UNION ALL SELECT * FROM T3) AS A;