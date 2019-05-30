CREATE OR REPLACE FUNCTION userA_userC(id INT, price INT)
RETURNS void
AS $$
  DECLARE
    serial_n INT;
    dark_serial_n INT;
    el_sign VARCHAR(32);
    a_key INT;
BEGIN
  SELECT INTO serial_n serial_num FROM bill ORDER BY serial_num DESC LIMIT 1;
  serial_n := serial_n+1+floor(random()*10000)::int%100;
  a_key := 1+floor(random()*10000)::int%100;
  dark_serial_n := serial_n*a_key;
  el_sign := md5(to_char((dark_serial_n+price+id)%a_key,'9999999'));
  UPDATE customer SET secret_key=a_key WHERE id_user=id;
  INSERT INTO bill(serial_num, bill_size, ecp, id_sender, id_reciever, message) VALUES (dark_serial_n, price, el_sign, id, 1, 'create_coin');
END;
$$ LANGUAGE  plpgsql;
CREATE OR REPLACE FUNCTION userC_userA(id int)
RETURNS void
AS $$
DECLARE dark_serial_n INT;
DECLARE price INT;
DECLARE market_el_sign VARCHAR(32);
DECLARE client_el_sign VARCHAR(32);
DECLARE check_el_sign VARCHAR(32);
DECLARE market_key INT;
DECLARE client_key INT;
DECLARE client_balance INT;
BEGIN
  SELECT INTO dark_serial_n serial_num FROM bill WHERE id_reciever=1 and id_sender=id and message='create_coin';
  SELECT INTO price bill_size FROM bill WHERE serial_num=dark_serial_n;
  SELECT INTO client_el_sign ecp FROM bill WHERE serial_num=dark_serial_n;
  SELECT INTO client_key secret_key FROM customer WHERE id_user=id;
  check_el_sign := md5(to_char((dark_serial_n+price+id)%client_key,'9999999'));
  IF check_el_sign=client_el_sign THEN
    SELECT INTO client_balance account_balance FROM customer WHERE id_user=id;
    if client_balance>=price then
      market_key:=1+floor(random()*10000)::int%10000;
      UPDATE market SET secret_key=market_key WHERE id_market=1;
      market_el_sign := md5(to_char((dark_serial_n+price+1)%market_key,'9999999'));
      UPDATE bill SET ecp=market_el_sign,id_sender=1,id_reciever=id,message='coin_created' WHERE serial_num=dark_serial_n;
    end if;
  END IF;
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION userA_userB(idA int,idB int)
RETURNS void
AS $$
DECLARE serial_n INT;
DECLARE dark_serial_n INT;
DECLARE price INT;
DECLARE secret_k INT;
BEGIN
  SELECT INTO dark_serial_n serial_num FROM bill WHERE id_sender=1 and id_reciever=idA and message='coin_created';
  SELECT INTO price bill_size FROM bill WHERE serial_num=dark_serial_n;
  SELECT INTO secret_k secret_key FROM customer WHERE id_user=idA;
  serial_n := dark_serial_n/secret_k;
  UPDATE bill SET serial_num=serial_n,id_sender=idA,id_reciever=idB,message='coin_sended' WHERE serial_num=dark_serial_n;
  INSERT INTO used_bill(serial_num, bill_size, status, id_market) VALUES (serial_n, price,'in use',1);
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION userB_userC(idA int,idB int)
RETURNS void
AS $$
DECLARE serial_n INT;
BEGIN
  SELECT INTO serial_n serial_num FROM bill WHERE id_sender=idA and id_reciever=idB and message='coin_sended';
  UPDATE bill SET message='check_coin' WHERE serial_num=serial_n;
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION userC_userB(idB int)
RETURNS void
AS $$
DECLARE serial_n INT;
DECLARE price INT;
DECLARE activity VARCHAR(20);
DECLARE idA INT;
DECLARE a_balance INT;
DECLARE b_balance INT;
BEGIN
  SELECT INTO serial_n serial_num FROM bill WHERE id_reciever=idB and message='check_coin';
  SELECT INTO activity status FROM used_bill WHERE serial_num=serial_n;
  IF activity='in use' THEN
    SELECT INTO idA id_sender FROM bill WHERE serial_num=serial_n;
    SELECT INTO price bill_size FROM bill WHERE serial_num=serial_n;
    SELECT INTO a_balance account_balance FROM customer WHERE id_user=idA;
    SELECT INTO b_balance account_balance FROM customer WHERE id_user=idB;
    UPDATE customer SET account_balance=a_balance-price WHERE id_user=idA;
    UPDATE customer SET account_balance=b_balance+price WHERE id_user=idB;
    UPDATE used_bill SET status='payed' WHERE serial_num=serial_n;
    UPDATE bill SET message='true_coin' WHERE serial_num=serial_n;
    INSERT INTO
  end if;
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION operation(idA int,idB int,price int)
RETURNS void
AS $$
BEGIN
  PERFORM userA_userC(idA, price);
  PERFORM userC_userA(idA);
  PERFORM userA_userB(idA, idB);
  PERFORM userB_userC(idA, idB);
  PERFORM userC_userB(idB);
END;
$$ LANGUAGE plpgsql;
SELECT * FROM operation(2, 3, 10);
/*SELECT * FROM userA_userC(2,10);
SELECT * FROM userC_userA(2);
SELECT * FROM userA_userB(2, 3);
SELECT * FROM userB_userC(2, 3);
SELECT * FROM userC_userB(3);*/
CREATE OR REPLACE FUNCTION check_auction(id_auc INT)
RETURNS void
AS $$
  DECLARE
    auc_date TIMESTAMP;
    now_date TIMESTAMP;
    auc_stat VARCHAR(20);
    auc_user INT;
    auc_product INT;
    last_bet INT;
    last_user INT;
    success BOOLEAN;
    id_op INT;
BEGIN
  SELECT INTO auc_date,auc_stat,auc_product time_ending,status,id_product FROM auction WHERE id_auction=id_auc;
  SELECT INTO auc_user id_user FROM product WHERE id_product=auc_product;
  now_date := LOCALTIMESTAMP;
  IF auc_date <= now_date AND auc_stat='active' THEN
    UPDATE auction SET status='not active' WHERE id_auction=id_auc;
    SELECT INTO last_bet,last_user bet_value,id_user FROM bet WHERE id_auction=id_auc ORDER BY bet_value DESC LIMIT 1;
    SELECT INTO success operation(last_user,auc_user,last_bet);
    IF success=TRUE THEN
      SELECT INTO id_op id_operation FROM operation ORDER BY id_operation DESC LIMIT 1;
      INSERT INTO operation(id_operation, id_seller, id_consumer, id_product, id_market) VALUES (id_op+1,auc_user,last_user,auc_product,1);
    ELSE
      RAISE EXCEPTION 'smth goes wrong';
    end if;
  end if;
END;
$$ LANGUAGE  plpgsql;

SELECT check_auction(4);
/*CREATE OR REPLACE FUNCTION clear_old_auctions()
RETURNS void
AS $$
  DECLARE
    id_auc INT;
BEGIN
  FOR id_auc IN SELECT id_auction FROM auction LOOP
    PERFORM check_auction(id_auc);
  end loop;
END;
$$ LANGUAGE plpgsql;

SELECT clear_old_auctions();*/
