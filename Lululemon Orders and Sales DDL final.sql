-- Drop Tables Script
 BEGIN
     FOR rec IN (SELECT table_name FROM user_tables) LOOP
         EXECUTE IMMEDIATE 'DROP TABLE ' || rec.table_name || ' CASCADE CONSTRAINTS';
     END LOOP;

     -- Confirm all tables are dropped
     dbms_output.put_line('All tables dropped successfully.');
 END;
 /


-- Table: Products
CREATE TABLE Products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR2(100),
  product_description VARCHAR2(4000),
  price FLOAT
);

-- Table: Discounts
CREATE TABLE Discounts (
  discount_id INT PRIMARY KEY,
  discount_code VARCHAR2(20),
  discount_type VARCHAR2(20),
  discount_value FLOAT,
  start_date DATE,
  end_date DATE
);

-- Table: Customers
CREATE TABLE Customers (
  customer_id INT PRIMARY KEY
);

-- Table: Stores
CREATE TABLE Stores (
  store_id INT PRIMARY KEY,
  store_name VARCHAR2(30),
  store_location VARCHAR2(50)
);

-- Table: Orders
CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  total_quantity INT,
  loyalty_points_earned FLOAT,
  order_type VARCHAR2(20),
  payment_method VARCHAR2(20),
  order_status VARCHAR2(20),
  shipping_address_line_1 VARCHAR2(30),
  shipping_address_line_2 VARCHAR2(20) DEFAULT NULL,
  shipping_address_city VARCHAR2(20),
  shipping_address_state VARCHAR2(20),
  shipping_address_zip_code INT,
  promo_code VARCHAR2(20),
  CONSTRAINT FK_Orders_Customers FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Table: Cashiers
CREATE TABLE Cashiers (
  cashier_id INT PRIMARY KEY,
  cashier_name VARCHAR2(50),
  store_id INT,
  CONSTRAINT FK_Cashiers_Stores FOREIGN KEY (store_id) REFERENCES Stores(store_id)
);

-- Table: InStoreSales
CREATE TABLE InStoreSales (
  sale_id INT PRIMARY KEY,
  store_id INT,
  cashier_id INT,
  customer_id INT,
  sale_date DATE,
  total_amount FLOAT,
  loyalty_points_earned FLOAT,
  CONSTRAINT FK_InStoreSales_Stores FOREIGN KEY (store_id) REFERENCES Stores(store_id),
  CONSTRAINT FK_InStoreSales_Cashiers FOREIGN KEY (cashier_id) REFERENCES Cashiers(cashier_id),
  CONSTRAINT FK_InStoreSales_Customers FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Table: ProductInventory
CREATE TABLE ProductInventory (
  product_id INT PRIMARY KEY,
  stock_quantity INT,
  restock_date DATE,
  CONSTRAINT FK_ProductInventory_Products FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Table: InStoreSaleItems
CREATE TABLE InStoreSaleItems (
  sale_item_id INT PRIMARY KEY,
  sale_id INT,
  product_id INT,
  quantity INT,
  price FLOAT,
  discount_id INT,
  CONSTRAINT FK_InStoreSaleItems_Sales FOREIGN KEY (sale_id) REFERENCES InStoreSales(sale_id),
  CONSTRAINT FK_InStoreSaleItems_Products FOREIGN KEY (product_id) REFERENCES Products(product_id),
  CONSTRAINT FK_InStoreSaleItems_Discounts FOREIGN KEY (discount_id) REFERENCES Discounts(discount_id)
);

-- Table: CustomerFeedback
CREATE TABLE CustomerFeedback (
  feedback_id INT PRIMARY KEY,
  order_id INT,                           -- For online orders
  sale_id INT,                            -- For in-store sales
  feedback_date DATE,
  rating FLOAT,
  feedback_comment VARCHAR2(4000),
  purchase_reason VARCHAR2(400),
  CONSTRAINT FK_CustomerFeedback_Orders FOREIGN KEY (order_id) REFERENCES Orders(order_id),
  CONSTRAINT FK_CustomerFeedback_InStoreSales FOREIGN KEY (sale_id) REFERENCES InStoreSales(sale_id),
  CONSTRAINT CK_CustomerFeedback_OneId CHECK (
    (order_id IS NOT NULL AND sale_id IS NULL) OR 
    (order_id IS NULL AND sale_id IS NOT NULL)
  )
);

-- Table: OnlineItems
CREATE TABLE OnlineItems (
  order_item_id INT PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT,
  price FLOAT,
  discount_id INT,
  CONSTRAINT FK_OnlineItems_Orders FOREIGN KEY (order_id) REFERENCES Orders(order_id),
  CONSTRAINT FK_OnlineItems_Products FOREIGN KEY (product_id) REFERENCES Products(product_id),
  CONSTRAINT FK_OnlineItems_Discounts FOREIGN KEY (discount_id) REFERENCES Discounts(discount_id)
);

-- Table: Payments
CREATE TABLE Payments (
  payment_id INT PRIMARY KEY,
  order_id INT,                        -- Nullable foreign key for online orders
  sale_id INT,                         -- Nullable foreign key for in-store sales
  payment_method VARCHAR2(20),
  payment_date DATE,
  payment_amount FLOAT,
  CONSTRAINT FK_Payments_Orders FOREIGN KEY (order_id) REFERENCES Orders(order_id),
  CONSTRAINT FK_Payments_InStoreSales FOREIGN KEY (sale_id) REFERENCES InStoreSales(sale_id),
  CONSTRAINT CK_Payments_OneId CHECK (
    (order_id IS NOT NULL AND sale_id IS NULL) OR 
    (order_id IS NULL AND sale_id IS NOT NULL)
  )
);

-- Seeding Products
INSERT INTO Products (product_id, product_name, product_description, price) VALUES 
(1, 'Align High-Rise Pant 25"', 'Buttery-soft yoga pants with a second-skin feel.', 98.00);

INSERT INTO Products (product_id, product_name, product_description, price) VALUES 
(2, 'Metal Vent Tech Short Sleeve Shirt', 'Lightweight, breathable workout shirt.', 78.00);

INSERT INTO Products (product_id, product_name, product_description, price) VALUES 
(3, 'Everywhere Belt Bag', 'Compact, versatile crossbody bag for essentials.', 38.00);

---- Seeding Discounts
INSERT INTO Discounts (discount_id, discount_code, discount_type, discount_value, start_date, end_date) VALUES 
(1, 'YOGAFLOW10', 'Percentage', 10.0, TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2024-06-30', 'YYYY-MM-DD'));

INSERT INTO Discounts (discount_id, discount_code, discount_type, discount_value, start_date, end_date) VALUES 
(2, 'HOLIDAY50', 'Flat', 50.0, TO_DATE('2024-11-01', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'));
--
---- Seeding Customers
INSERT INTO Customers (customer_id) VALUES (1);
INSERT INTO Customers (customer_id) VALUES (2);
INSERT INTO Customers (customer_id) VALUES (3);
--
---- Seeding Stores
INSERT INTO Stores (store_id, store_name, store_location) VALUES 
(1, 'Lululemon Flagship Store', '123 Yoga St');

INSERT INTO Stores (store_id, store_name, store_location) VALUES 
(2, 'Lululemon Outlet', '456 Fitness Blvd');

-- Seeding Cashiers
INSERT INTO Cashiers (cashier_id, cashier_name, store_id) VALUES 
(1, 'Jamie Lee', 1);

INSERT INTO Cashiers (cashier_id, cashier_name, store_id) VALUES 
(2, 'Taylor Smith', 2);

---- Seeding ProductInventory
INSERT INTO ProductInventory (product_id, stock_quantity, restock_date) VALUES 
(1, 100, TO_DATE('2024-11-20', 'YYYY-MM-DD'));

INSERT INTO ProductInventory (product_id, stock_quantity, restock_date) VALUES 
(2, 150, TO_DATE('2024-11-25', 'YYYY-MM-DD'));

INSERT INTO ProductInventory (product_id, stock_quantity, restock_date) VALUES 
(3, 300, TO_DATE('2024-11-30', 'YYYY-MM-DD'));

---- Seeding Orders
INSERT INTO Orders (order_id, customer_id, order_date, total_quantity, loyalty_points_earned, order_type, payment_method, order_status, shipping_address_line_1, shipping_address_line_2, shipping_address_city, shipping_address_state,
shipping_address_zip_code, promo_code) VALUES 
(1, 1, TO_DATE('2024-11-10', 'YYYY-MM-DD'), 116.00, 10, 'Online', 'Credit Card', 'Shipped', '789 Elm St', NULL, 'Austin', 'TX', '78750', 'YOGAFLOW10');

INSERT INTO Orders (order_id, customer_id, order_date, total_quantity, loyalty_points_earned, order_type, payment_method, order_status, shipping_address_line_1, shipping_address_line_2, shipping_address_city, shipping_address_state,
shipping_address_zip_code, promo_code) VALUES 
(2, 2, TO_DATE('2024-11-15', 'YYYY-MM-DD'), 78.00, 8, 'Online', 'Apple Pay', 'Processing', '321 Oak St',  NULL, 'Austin', 'TX', '78639', 'HOLIDAY50');

---- Seeding InStoreSales
INSERT INTO InStoreSales (sale_id, store_id, cashier_id, customer_id, sale_date, total_amount, loyalty_points_earned) VALUES 
(1, 1, 1, 1, TO_DATE('2024-11-12', 'YYYY-MM-DD'), 176.00, 15);

INSERT INTO InStoreSales (sale_id, store_id, cashier_id, customer_id, sale_date, total_amount, loyalty_points_earned) VALUES 
(2, 2, 2, 2, TO_DATE('2024-11-18', 'YYYY-MM-DD'), 38.00, 3);

---- Seeding InStoreSaleItems
INSERT INTO InStoreSaleItems (sale_item_id, sale_id, product_id, quantity, price, discount_id) VALUES 
(1, 1, 1, 1, 98.00, 1);

INSERT INTO InStoreSaleItems (sale_item_id, sale_id, product_id, quantity, price, discount_id) VALUES 
(2, 1, 2, 1, 78.00, NULL);

INSERT INTO InStoreSaleItems (sale_item_id, sale_id, product_id, quantity, price, discount_id) VALUES 
(3, 2, 3, 1, 38.00, NULL);

-- Seeding OnlineItems
INSERT INTO OnlineItems (order_item_id, order_id, product_id, quantity, price, discount_id) VALUES 
(1, 1, 1, 1, 98.00, 1);

INSERT INTO OnlineItems (order_item_id, order_id, product_id, quantity, price, discount_id) VALUES 
(2, 1, 3, 1, 38.00, NULL);

INSERT INTO OnlineItems (order_item_id, order_id, product_id, quantity, price, discount_id) VALUES 
(3, 2, 2, 1, 78.00, NULL);

---- Seeding Payments
INSERT INTO Payments (payment_id, order_id, sale_id, payment_method, payment_date, payment_amount) VALUES 
(1, 1, NULL, 'Credit Card', TO_DATE('2024-11-10', 'YYYY-MM-DD'), 116.00);

INSERT INTO Payments (payment_id, order_id, sale_id, payment_method, payment_date, payment_amount) VALUES 
(2, NULL, 1, 'Cash', TO_DATE('2024-11-12', 'YYYY-MM-DD'), 176.00);

INSERT INTO Payments (payment_id, order_id, sale_id, payment_method, payment_date, payment_amount) VALUES 
(3, 2, NULL, 'Apple Pay', TO_DATE('2024-11-15', 'YYYY-MM-DD'), 78.00);

INSERT INTO Payments (payment_id, order_id, sale_id, payment_method, payment_date, payment_amount) VALUES 
(4, NULL, 2, 'Credit Card', TO_DATE('2024-11-18', 'YYYY-MM-DD'), 38.00);

---- Seeding CustomerFeedback
INSERT INTO CustomerFeedback (feedback_id, order_id, sale_id, feedback_date, rating, feedback_comment, purchase_reason) VALUES 
(1, 1, NULL, TO_DATE('2024-11-11', 'YYYY-MM-DD'), 5.0, 'Align pants are so comfortable!', 'Personal Shopping');

INSERT INTO CustomerFeedback (feedback_id, order_id, sale_id, feedback_date, rating, feedback_comment, purchase_reason) VALUES 
(2, NULL, 1, TO_DATE('2024-11-13', 'YYYY-MM-DD'), 4.8, 'Amazing in-store service and quality!', 'Sales Special');

