DROP TABLE IF EXISTS input_data;
CREATE TABLE input_data(
  id SERIAL NOT NULL PRIMARY KEY,
  type VARCHAR(50) NOT NULL,
  table_name VARCHAR(50) NOT NULL,
  status CHAR(1) NOT NULL CHECK ( status in ('c', 'p', 'o', 'a', 'e') ),
  data TEXT NOT NULL,
  countTry INT DEFAULT(0) NULL,
  status_comment VARCHAR(500),
  date_add DATE DEFAULT (CURRENT_DATE)
);

DO $$
      DECLARE doc text;
BEGIN
     doc := pg_read_file('soap_files\market.txt');
     INSERT INTO input_data (type, table_name, status,data)  VALUES ('soap', 'market', 'c',doc);

     doc := pg_read_file('soap_files\charge.txt');
     INSERT INTO input_data (type, table_name, status,data)  VALUES ('soap', 'charge', 'c',doc);

     doc := pg_read_file('soap_files\used_bill.txt');
     INSERT INTO input_data (type, table_name, status,data)  VALUES ('soap', 'used_bill', 'c',doc);

     doc := pg_read_file('soap_files\money_course.txt');
     INSERT INTO input_data (type, table_name, status,data)  VALUES ('soap', 'money_course', 'c',doc);

     doc := pg_read_file('soap_files\protocol.txt');
     INSERT INTO input_data (type, table_name, status,data)  VALUES ('soap', 'protocol', 'c',doc);

     doc := pg_read_file('soap_files\customer.txt');
     INSERT INTO input_data (type, table_name, status,data)  VALUES ('soap', 'customer', 'c',doc);

     doc := pg_read_file('soap_files\seller.txt');
     INSERT INTO input_data (type, table_name, status,data)  VALUES ('soap', 'seller', 'c',doc);

     doc := pg_read_file('soap_files\consumer.txt');
     INSERT INTO input_data (type, table_name, status,data)  VALUES ('soap', 'consumer', 'c',doc);

     doc := pg_read_file('soap_files\bill.txt');
     INSERT INTO input_data (type, table_name, status,data)  VALUES ('soap', 'bill', 'c',doc);

     doc := pg_read_file('soap_files\product.txt');
     INSERT INTO input_data (type, table_name, status,data)  VALUES ('soap', 'product', 'c',doc);

     doc := pg_read_file('soap_files\vitrine.txt');
     INSERT INTO input_data (type, table_name, status,data)  VALUES ('soap', 'vitrine', 'c',doc);

     doc := pg_read_file('soap_files\auction.txt');
     INSERT INTO input_data (type, table_name, status,data)  VALUES ('soap', 'auction', 'c',doc);

     doc := pg_read_file('soap_files\operation.txt');
     INSERT INTO input_data (type, table_name, status,data)  VALUES ('soap', 'operation', 'c',doc);

     doc := pg_read_file('soap_files\delivery.txt');
     INSERT INTO input_data (type, table_name, status,data)  VALUES ('soap', 'delivery', 'c',doc);

     doc := pg_read_file('soap_files\auction_user.txt');
     INSERT INTO input_data (type, table_name, status,data)  VALUES ('soap', 'auction_user', 'c',doc);

     doc := pg_read_file('soap_files\bet.txt');
     INSERT INTO input_data (type, table_name, status,data)  VALUES ('soap', 'bet', 'c',doc);

     doc := pg_read_file('soap_files\storage.txt');
     INSERT INTO input_data (type, table_name, status,data)  VALUES ('soap', 'storage', 'c',doc);

     doc := pg_read_file('soap_files\storage_cell.txt');
     INSERT INTO input_data (type, table_name, status,data)  VALUES ('soap', 'storage_cell', 'c',doc);


END $$;