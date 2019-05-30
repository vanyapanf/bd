DO $$
    DECLARE r text;
BEGIN
     for r in select data from input_data where status='c' and table_name='market'  loop
         insert into market (id_market, ip_addr)    select
           ((xpath('//id_market/text()', x))[1]::text)::int as id_market,
           ((xpath('//ip_addr/text()', x))[1]::text)::varchar(40) as ip_addr
         from unnest(xpath('/soap:Envelope/soap:Body', cast(r as xml), ARRAY[ARRAY['soap', 'http://schemas.xmlsoap.org/soap/envelope/']])) x;
     end loop;
     update input_data  set status='o' where table_name='market' and status='c';

     for r in select data from input_data where status='c' and table_name='charge'  loop
         insert into charge (id_charge,charge_size,id_user,id_market)     select
           ((xpath('//id_charge/text()', x))[1]::text)::int as id_charge,
           ((xpath('//charge_size/text()', x))[1]::text)::float as charge_size,
           ((xpath('//id_user/text()', x))[1]::text)::int as id_user,
           ((xpath('//id_market/text()', x))[1]::text)::int as id_market
         from unnest(xpath('/soap:Envelope/soap:Body', cast(r as xml), ARRAY[ARRAY['soap', 'http://schemas.xmlsoap.org/soap/envelope/']])) x;
     end loop;
     update input_data  set status='o' where table_name='charge' and status='c';

      for r in select data from input_data where status='c' and table_name='used_bill'  loop
         insert into used_bill (serial_num, bill_size, status, id_market)      select
           ((xpath('//serial_num/text()', x))[1]::text)::int as serial_num,
           ((xpath('//bill_size/text()', x))[1]::text)::int as bill_size,
           ((xpath('//status/text()', x))[1]::text)::varchar(20) as status,
           ((xpath('//id_market/text()', x))[1]::text)::int as id_market
         from unnest(xpath('/soap:Envelope/soap:Body', cast(r as xml), ARRAY[ARRAY['soap', 'http://schemas.xmlsoap.org/soap/envelope/']])) x;
      end loop;
     update input_data  set status='o' where table_name='used_bill' and status='c';

     for r in select data from input_data where status='c' and table_name='money_course'  loop
         insert into money_course (money_code, date_course_change, factor, course_value, id_market)     select
           ((xpath('//money_code/text()', x))[1]::text)::int as money_code,
           ((xpath('//date_course_change/text()', x))[1]::text)::timestamp as date_course_change,
           ((xpath('//factor/text()', x))[1]::text)::float as factor,
           ((xpath('//course_value/text()', x))[1]::text)::float as course_value,
           ((xpath('//id_market/text()', x))[1]::text)::int as id_market
         from unnest(xpath('/soap:Envelope/soap:Body', cast(r as xml), ARRAY[ARRAY['soap', 'http://schemas.xmlsoap.org/soap/envelope/']])) x;
     end loop;
     update input_data  set status='o' where table_name='money_course' and status='c';

     for r in select data from input_data where status='c' and table_name='protocol'  loop
         insert into protocol (id_protocol, protocol_num, user_level, date_protoc_change, id_market)      select
           ((xpath('//id_protocol/text()', x))[1]::text)::int as id_protocol,
           ((xpath('//protocol_num/text()', x))[1]::text)::int as protocol_num,
           ((xpath('//user_level/text()', x))[1]::text)::int as user_level,
           ((xpath('//date_protoc_change/text()', x))[1]::text)::timestamp as date_protoc_change,
           ((xpath('//id_market/text()', x))[1]::text)::int as id_market
         from unnest(xpath('/soap:Envelope/soap:Body', cast(r as xml), ARRAY[ARRAY['soap', 'http://schemas.xmlsoap.org/soap/envelope/']])) x;
     end loop;
     update input_data  set status='o' where table_name='protocol' and status='c';

    for r in select data from input_data where status='c' and table_name='customer'  loop
         insert into customer (id_user, secret_key, account_balance, id_protocol)       select
           ((xpath('//id_user/text()', x))[1]::text)::int as id_user,
           ((xpath('//secret_key/text()', x))[1]::text)::int as secret_key,
           ((xpath('//account_balance/text()', x))[1]::text)::int as account_balance,
           ((xpath('//id_protocol/text()', x))[1]::text)::int as id_protocol
         from unnest(xpath('/soap:Envelope/soap:Body', cast(r as xml), ARRAY[ARRAY['soap', 'http://schemas.xmlsoap.org/soap/envelope/']])) x;
     end loop;
     update input_data  set status='o' where table_name='customer' and status='c';

     for r in select data from input_data where status='c' and table_name='seller'  loop
         insert into seller (id_user)      select
           ((xpath('//id_user/text()', x))[1]::text)::int as id_user
         from unnest(xpath('/soap:Envelope/soap:Body', cast(r as xml), ARRAY[ARRAY['soap', 'http://schemas.xmlsoap.org/soap/envelope/']])) x;
     end loop;
     update input_data  set status='o' where table_name='seller' and status='c';

     for r in select data from input_data where status='c' and table_name='consumer'  loop
         insert into consumer (id_user, delivery_adress)       select
           ((xpath('//id_user/text()', x))[1]::text)::int as id_user,
           ((xpath('//delivery_adress/text()', x))[1]::text)::varchar(30) as delivery_adress
         from unnest(xpath('/soap:Envelope/soap:Body', cast(r as xml), ARRAY[ARRAY['soap', 'http://schemas.xmlsoap.org/soap/envelope/']])) x;
     end loop;
     update input_data  set status='o' where table_name='consumer' and status='c';

     for r in select data from input_data where status='c' and table_name='bill'  loop
         insert into bill (serial_num, bill_size, ecp, id_user, id_market)       select
           ((xpath('//serial_num/text()', x))[1]::text)::int as serial_num,
           ((xpath('//bill_size/text()', x))[1]::text)::int as bill_size,
           ((xpath('//ecp/text()', x))[1]::text)::varchar(20) as ecp,
           ((xpath('//id_user/text()', x))[1]::text)::int as id_user,
           ((xpath('//id_market/text()', x))[1]::text)::int as id_market
         from unnest(xpath('/soap:Envelope/soap:Body', cast(r as xml), ARRAY[ARRAY['soap', 'http://schemas.xmlsoap.org/soap/envelope/']])) x;
     end loop;
     update input_data  set status='o' where table_name='bill' and status='c';

     for r in select data from input_data where status='c' and table_name='product'  loop
         insert into product (id_product, name, weight, size, description, id_user)       select
           ((xpath('//id_product/text()', x))[1]::text)::int as id_product,
           ((xpath('//name/text()', x))[1]::text)::varchar(20) as name,
           ((xpath('//weight/text()', x))[1]::text)::float as weight,
           ((xpath('//size/text()', x))[1]::text)::varchar(20) as size,
           ((xpath('//description/text()', x))[1]::text)::varchar(100) as description,
           ((xpath('//id_user/text()', x))[1]::text)::int as id_user
         from unnest(xpath('/soap:Envelope/soap:Body', cast(r as xml), ARRAY[ARRAY['soap', 'http://schemas.xmlsoap.org/soap/envelope/']])) x;
     end loop;
     update input_data  set status='o' where table_name='product' and status='c';

     for r in select data from input_data where status='c' and table_name='vitrine'  loop
         insert into vitrine (id_vitr, price, id_product)        select
           ((xpath('//id_vitr/text()', x))[1]::text)::int as id_vitr,
           ((xpath('//price/text()', x))[1]::text)::float as price,
           ((xpath('//id_product/text()', x))[1]::text)::int as id_product
         from unnest(xpath('/soap:Envelope/soap:Body', cast(r as xml), ARRAY[ARRAY['soap', 'http://schemas.xmlsoap.org/soap/envelope/']])) x;
     end loop;
     update input_data  set status='o' where table_name='vitrine' and status='c';

      for r in select data from input_data where status='c' and table_name='auction'  loop
         insert into auction (id_auction, first_price, step_auction, time_ending, status, id_product)   select
           ((xpath('//id_auction/text()', x))[1]::text)::int as id_auction,
           ((xpath('//first_price/text()', x))[1]::text)::int as first_price,
           ((xpath('//step_auction/text()', x))[1]::text)::int as step_auction,
           ((xpath('//time_ending/text()', x))[1]::text)::timestamp as time_ending,
           ((xpath('//status/text()', x))[1]::text)::varchar(20) as status,
           ((xpath('//id_product/text()', x))[1]::text)::int as id_product
         from unnest(xpath('/soap:Envelope/soap:Body', cast(r as xml), ARRAY[ARRAY['soap', 'http://schemas.xmlsoap.org/soap/envelope/']])) x;
     end loop;
     update input_data  set status='o' where table_name='auction' and status='c';

     for r in select data from input_data where status='c' and table_name='operation'  loop
         insert into operation (id_operation, id_seller, id_consumer, id_product, id_market)        select
           ((xpath('//id_operation/text()', x))[1]::text)::int as id_operation,
           ((xpath('//id_seller/text()', x))[1]::text)::int as id_seller,
           ((xpath('//id_consumer/text()', x))[1]::text)::int as id_consumer,
           ((xpath('//id_product/text()', x))[1]::text)::int as id_product,
           ((xpath('//id_market/text()', x))[1]::text)::int as id_market
         from unnest(xpath('/soap:Envelope/soap:Body', cast(r as xml), ARRAY[ARRAY['soap', 'http://schemas.xmlsoap.org/soap/envelope/']])) x;
     end loop;
     update input_data  set status='o' where table_name='operation' and status='c';

     for r in select data from input_data where status='c' and table_name='delivery'  loop
         insert into delivery (id_delivery, status, time_order, time_sending, time_getting, id_operation)        select
           ((xpath('//id_delivery/text()', x))[1]::text)::int as id_delivery,
           ((xpath('//status/text()', x))[1]::text)::varchar(20) as status,
           ((xpath('//time_order/text()', x))[1]::text)::timestamp as time_order,
           ((xpath('//time_sending/text()', x))[1]::text)::timestamp as time_sending,
           ((xpath('//time_getting/text()', x))[1]::text)::timestamp as time_getting,
           ((xpath('//id_operation/text()', x))[1]::text)::int as id_operation
         from unnest(xpath('/soap:Envelope/soap:Body', cast(r as xml), ARRAY[ARRAY['soap', 'http://schemas.xmlsoap.org/soap/envelope/']])) x;
     end loop;
     update input_data  set status='o' where table_name='delivery' and status='c';

     for r in select data from input_data where status='c' and table_name='auction_user'  loop
         insert into auction_user (id_user, id_auction)        select
           ((xpath('//id_user/text()', x))[1]::text)::int as id_user,
           ((xpath('//id_auction/text()', x))[1]::text)::int as id_auction
         from unnest(xpath('/soap:Envelope/soap:Body', cast(r as xml), ARRAY[ARRAY['soap', 'http://schemas.xmlsoap.org/soap/envelope/']])) x;
     end loop;
     update input_data  set status='o' where table_name='auction_user' and status='c';

     for r in select data from input_data where status='c' and table_name='bet'  loop
         insert into bet (id_bet, bet_value, id_user, id_auction)        select
           ((xpath('//id_bet/text()', x))[1]::text)::int as id_bet,
           ((xpath('//bet_value/text()', x))[1]::text)::int as bet_value,
           ((xpath('//id_user/text()', x))[1]::text)::int as id_user,
           ((xpath('//id_auction/text()', x))[1]::text)::int as id_auction
         from unnest(xpath('/soap:Envelope/soap:Body', cast(r as xml), ARRAY[ARRAY['soap', 'http://schemas.xmlsoap.org/soap/envelope/']])) x;
     end loop;
     update input_data  set status='o' where table_name='bet' and status='c';

     for r in select data from input_data where status='c' and table_name='storage'  loop
         insert into storage (coordinates, id_seller_owner)        select
           ((xpath('//coordinates/text()', x))[1]::text)::varchar(30) as coordinates,
           ((xpath('//id_seller_owner/text()', x))[1]::text)::int as id_seller_owner
         from unnest(xpath('/soap:Envelope/soap:Body', cast(r as xml), ARRAY[ARRAY['soap', 'http://schemas.xmlsoap.org/soap/envelope/']])) x;
     end loop;
     update input_data  set status='o' where table_name='storage' and status='c';

     for r in select data from input_data where status='c' and table_name='storage_cell'  loop
         insert into storage_cell (id_product, coordinates)         select
           ((xpath('//id_product/text()', x))[1]::text)::int as id_product,
           ((xpath('//coordinates/text()', x))[1]::text)::varchar(30) as coordinates
         from unnest(xpath('/soap:Envelope/soap:Body', cast(r as xml), ARRAY[ARRAY['soap', 'http://schemas.xmlsoap.org/soap/envelope/']])) x;
     end loop;
     update input_data  set status='o' where table_name='storage_cell' and status='c';

END $$;