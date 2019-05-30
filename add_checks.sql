/*actions*/
/*ALTER TABLE delivery ALTER  COLUMN time_order type timestamp without time zone
using current_date + time_order;
ALTER TABLE delivery ALTER  COLUMN time_sending type timestamp without time zone
using current_date + time_sending;
ALTER TABLE delivery ALTER  COLUMN time_getting type timestamp without time zone
using current_date + time_getting;

DELETE FROM delivery WHERE id_operation IN (SELECT id_operation FROM operation WHERE id_consumer IN (SELECT id_user FROM consumer WHERE delivery_adress is null));
DELETE FROM operation WHERE id_consumer IN (SELECT id_user FROM consumer WHERE delivery_adress is null);
DELETE FROM consumer WHERE delivery_adress is null;

ALTER TABLE charge ADD COLUMN money_code INT;
UPDATE charge SET money_code = 1;

DELETE FROM money_course WHERE course_value=0;
UPDATE money_course SET factor = 1/course_value;
*/

/*checks*/
ALTER TABLE used_bill ADD CHECK(status in ('in use','payed'));
ALTER TABLE delivery ADD CHECK(status in ('ordered','sended','delivered'));
ALTER TABLE auction ADD CHECK(status in ('active' ,'not active'));

