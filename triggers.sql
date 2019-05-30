/*1trigger*/
DROP TRIGGER IF EXISTS bet_up_trigger ON bet RESTRICT;
DROP FUNCTION IF EXISTS bet_up_func RESTRICT;

CREATE FUNCTION bet_up_func() RETURNS trigger AS $$
DECLARE balance INT;
DECLARE last_bet INT;
DECLARE step INT;
DECLARE first INT;
DECLARE activity VARCHAR(20);
DECLARE existence INT;
BEGIN
      SELECT INTO existence id_user FROM auction_user WHERE (id_auction=NEW.id_auction AND id_user=NEW.id_user);
      SELECT INTO activity status FROM auction WHERE id_auction=NEW.id_auction;
      IF ((existence is not null) AND (activity='active'))THEN
        SELECT INTO step step_auction FROM auction WHERE id_auction=NEW.id_auction;
        SELECT INTO balance account_balance FROM customer WHERE id_user=NEW.id_user;
        SELECT INTO last_bet bet_value FROM bet WHERE id_auction=NEW.id_auction ORDER BY bet_value DESC LIMIT 1;
        IF last_bet is null THEN
          SELECT INTO first first_price FROM auction WHERE id_auction=NEW.id_auction;
          last_bet := first-step;
        END IF;
        IF ((balance>=NEW.bet_value) AND (NEW.bet_value=(last_bet+step))) THEN
          RETURN NEW;
        END IF;
      END IF;
      RAISE EXCEPTION 'smth goes wrong';
END;
$$ LANGUAGE  plpgsql;

CREATE TRIGGER bet_up_trigger
BEFORE INSERT ON bet FOR EACH ROW
EXECUTE PROCEDURE bet_up_func();

/*2trigger*/
DROP TRIGGER IF EXISTS charge_up_trigger ON charge RESTRICT;
DROP FUNCTION IF EXISTS charge_up_func RESTRICT;

CREATE FUNCTION charge_up_func() RETURNS trigger AS $$
DECLARE last_date TIMESTAMP;
DECLARE  val INT;
DECLARE existense INT;
BEGIN
      SELECT INTO existense id_user FROM customer WHERE id_user=NEW.id_user;
      IF existense IS NOT NULL THEN
        SELECT INTO last_date date_course_change FROM money_course WHERE money_code=NEW.money_code ORDER BY date_course_change DESC LIMIT 1;
        SELECT INTO val course_value FROM money_course WHERE (money_code=NEW.money_code AND date_course_change=last_date);
        UPDATE customer SET account_balance=(account_balance+(val*NEW.charge_size)) WHERE id_user=NEW.id_user;
        RETURN NEW;
      END IF;
      RETURN NULL;
END;
$$ LANGUAGE  plpgsql;

CREATE TRIGGER charge_up_trigger
BEFORE INSERT ON charge FOR EACH ROW
EXECUTE PROCEDURE charge_up_func();