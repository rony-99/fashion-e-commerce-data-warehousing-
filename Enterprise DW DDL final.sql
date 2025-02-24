--  Drop Tables Script
 BEGIN
     FOR rec IN (SELECT table_name FROM user_tables) LOOP
         EXECUTE IMMEDIATE 'DROP TABLE ' || rec.table_name || ' CASCADE CONSTRAINTS';
     END LOOP;

     -- Confirm all tables are dropped
     dbms_output.put_line('All tables dropped successfully.');
 END;
 /


CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR2(100) NOT NULL,
    customer_email VARCHAR2(100) NOT NULL,
    customer_phone VARCHAR2(15),
    customer_address_line_1 VARCHAR2(50),
    customer_address_line_2 VARCHAR2(50),
    customer_city VARCHAR2(50),
    customer_state VARCHAR2(20),
    customer_zip_code INT
);

-- Create finished products table
CREATE TABLE finished_products ( 
    product_id INT PRIMARY KEY,
    present_stock_quantity INT,
    product_name VARCHAR(50),
    product_category VARCHAR(20),
    product_sales_price FLOAT
);

-- Create table for production_batch
CREATE TABLE production_batch (
    batch_id INT PRIMARY KEY,
    product_id INT,
    start_date DATE,
    end_date DATE,
    quantity_produced INT,
    FOREIGN KEY (product_id) REFERENCES finished_products(product_id)
);

-- Create table for material_usage_log
CREATE TABLE material_usage_log (
    usage_id INT PRIMARY KEY,
    batch_id INT,
    raw_material_id INT,
    quantity_used FLOAT,
    FOREIGN KEY (batch_id) REFERENCES production_batch(batch_id)
);

-- Create table for inventory
CREATE TABLE inventory (
    raw_material_id INT PRIMARY KEY,
    last_stocked_invoice_id INT,
    raw_material_name VARCHAR(50),
    current_quantity FLOAT,
    last_stocked_date DATE,
    last_used_date DATE
);

-- Create table for cog_payment 
CREATE TABLE cog_payment ( 
    invoice_id INT PRIMARY KEY,
    payment_status VARCHAR(20),
    payment_id INT,
    payment_amount FLOAT,
    payment_mode VARCHAR(20),
    payment_due_on DATE,
    payment_date DATE,
    payment_type VARCHAR(20)
);

-- Create table for supplier
CREATE TABLE supplier (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(50),
    supplier_address VARCHAR(100),
    phone VARCHAR(15),
    email VARCHAR(50)
);

-- Create table for Purchase_order
CREATE TABLE purchase_order ( 
    invoice_id INT PRIMARY KEY,
    supplier_id INT,
    order_date DATE,
    status VARCHAR(20),
    amount FLOAT,
    FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id)
);

-- Create table for delivery
CREATE TABLE delivery (
    supplier_id INT,
    invoice_id INT,
    lineitem_id INT,
    date_of_arrival DATE,
    quantity FLOAT,
    quantity_type VARCHAR(20),
    warehouse_location VARCHAR(50),
    shipment_status VARCHAR(20),
    procurement_type VARCHAR(20),
    PRIMARY KEY (supplier_id, invoice_id, lineitem_id),
    FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id),
    FOREIGN KEY (invoice_id) REFERENCES purchase_order(invoice_id)
);

-- Create table for raw_materials 
CREATE TABLE raw_materials ( 
    invoice_id INT,
    lineitem_id INT,
    quantity FLOAT,
    quantity_name VARCHAR(50),
    unit_price FLOAT,
    total_price FLOAT,
    PRIMARY KEY (invoice_id, lineitem_id),
    FOREIGN KEY (invoice_id) REFERENCES purchase_order(invoice_id)
);

CREATE TABLE discounts (
  discount_id INT PRIMARY KEY,
  discount_code VARCHAR2(20),
  discount_type VARCHAR2(20),
  discount_value FLOAT,
  start_date DATE,
  end_date DATE
);

CREATE TABLE stores (
  store_id INT PRIMARY KEY,
  store_name VARCHAR2(30),
  store_location VARCHAR2(50)
);

CREATE TABLE agents (
    agent_id INT PRIMARY KEY,
    agent_name VARCHAR2(100),
    agent_email VARCHAR2(50),
    department VARCHAR2(10),
    agent_level VARCHAR2(20)
);

CREATE TABLE rewards (
    reward_id INT PRIMARY KEY,
    reward_name VARCHAR2(50) NOT NULL,
    point_cost INT NOT NULL,
    reward_description VARCHAR2(200),
    reward_expiry_date DATE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    product_category VARCHAR(20),
    product_description VARCHAR(200),
    price FLOAT,
    FOREIGN KEY (product_id) REFERENCES finished_products(product_id)
);

CREATE TABLE cashiers (
  cashier_id INT PRIMARY KEY,
  cashier_name VARCHAR2(50),
  store_id INT,
  CONSTRAINT fk_cashiers_stores FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

CREATE TABLE product_returns (
    return_id INT PRIMARY KEY,
    product_id INT NOT NULL,
    customer_id INT NOT NULL,
    order_id INT,
    return_date DATE NOT NULL,
    return_reason VARCHAR2(30),
    return_status VARCHAR2(20),
    FOREIGN KEY (product_id) REFERENCES finished_products(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE product_issues (
    issue_id INT PRIMARY KEY,
    product_id INT NOT NULL,
    customer_id INT NOT NULL,
    issue_reported_date DATE NOT NULL,
    issue_description VARCHAR2(200),
    resolution_status VARCHAR2(20),
    issue_last_updated DATE,
    FOREIGN KEY (product_id) REFERENCES finished_products(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE memberships (
    membership_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    TIER VARCHAR2(10) NOT NULL,
    membership_start DATE NOT NULL,
    membership_end DATE NOT NULL,
    points_balance INT DEFAULT 0,
    status VARCHAR2(20),
    last_updated DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  total_quantity INT,
  loyalty_points_earned FLOAT,
  order_type VARCHAR2(20),
  payment_method VARCHAR2(20),
  order_status VARCHAR2(20),
  shipping_address_line_1 VARCHAR2(30),
  shipping_address_line_2 VARCHAR2(20),
  shipping_address_city VARCHAR2(20),
  shipping_address_state VARCHAR2(20),
  shipping_address_zip_code INT,
  promo_code VARCHAR2(20),
  CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE instoresales (
  sale_id INT PRIMARY KEY,
  store_id INT,
  cashier_id INT,
  customer_id INT,
  sale_date DATE,
  total_quantity FLOAT,
  loyalty_points_earned FLOAT,
  CONSTRAINT fk_instoresales_stores FOREIGN KEY (store_id) REFERENCES stores(store_id),
  CONSTRAINT fk_instoresales_cashiers FOREIGN KEY (cashier_id) REFERENCES cashiers(cashier_id),
  CONSTRAINT fk_instoresales_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE customerfeedback (
  feedback_id INT PRIMARY KEY,
  order_id INT,
  sale_id INT,
  feedback_date DATE,
  rating FLOAT,
  feedback_comment VARCHAR2(4000),
  purchase_reason VARCHAR2(400),
  CONSTRAINT fk_customerfeedback_orders FOREIGN KEY (order_id) REFERENCES orders(order_id),
  CONSTRAINT fk_customerfeedback_instoresales FOREIGN KEY (sale_id) REFERENCES instoresales(sale_id),
  CONSTRAINT ck_customerfeedback_oneid CHECK (
    (order_id IS NOT NULL AND sale_id IS NULL) OR 
    (order_id IS NULL AND sale_id IS NOT NULL)
)
);

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    membership_id INT NOT NULL,
    points_earned INT,
    points_redeemed INT,
    transaction_date DATE,
    FOREIGN KEY (membership_id) REFERENCES memberships(membership_id)
);

CREATE TABLE reward_redemptions (
    redemption_id INT PRIMARY KEY,
    membership_id INT NOT NULL,
    reward_id INT NOT NULL,
    redemption_date DATE,
    FOREIGN KEY (membership_id) REFERENCES memberships(membership_id),
    FOREIGN KEY (reward_id) REFERENCES rewards(reward_id)
);

CREATE TABLE returns_issues_link (
    link_id INT PRIMARY KEY,
    return_id INT NOT NULL,
    issue_id INT NOT NULL,
    link_date DATE,
    FOREIGN KEY (return_id) REFERENCES product_returns(return_id),
    FOREIGN KEY (issue_id) REFERENCES product_issues(issue_id)
);

CREATE TABLE onlineitems (
  order_item_id INT PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT,
  price FLOAT,
  discount_id INT,
  CONSTRAINT fk_onlineitems_orders FOREIGN KEY (order_id) REFERENCES orders(order_id),
  CONSTRAINT fk_onlineitems_products FOREIGN KEY (product_id) REFERENCES products(product_id),
  CONSTRAINT fk_onlineitems_discounts FOREIGN KEY (discount_id) REFERENCES discounts(discount_id)
);

CREATE TABLE instoresaleitems (
  sale_item_id INT PRIMARY KEY,
  sale_id INT,
  product_id INT,
  quantity INT,
  price FLOAT,
  discount_id INT,
  CONSTRAINT fk_instoresaleitems_sales FOREIGN KEY (sale_id) REFERENCES instoresales(sale_id),
  CONSTRAINT fk_instoresaleitems_products FOREIGN KEY (product_id) REFERENCES products(product_id),
  CONSTRAINT fk_instoresaleitems_discounts FOREIGN KEY (discount_id) REFERENCES discounts(discount_id)
);

-- A simpler fact table
--CREATE TABLE FactLineItems (
--    line_item_id INT PRIMARY KEY,
--    order_id INT,                  -- Nullable for in-store sales
--    sale_id INT,                   -- Nullable for online orders
--    product_id INT NOT NULL,
--    customer_id INT,
--    quantity INT NOT NULL,
--    price FLOAT NOT NULL,
--    total_price FLOAT GENERATED ALWAYS AS (quantity * price),
--    discount_id INT,
--    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
--    FOREIGN KEY (sale_id) REFERENCES InStoreSales(sale_id),
--    FOREIGN KEY (product_id) REFERENCES finished_products(product_id),
--    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
--    FOREIGN KEY (discount_id) REFERENCES Discounts(discount_id)
--);

CREATE TABLE fact_lineitems (
    line_item_id INT PRIMARY KEY,
    order_id INT,                  -- Nullable for in-store sales
    sale_id INT,                   -- Nullable for online orders
    product_id INT NOT NULL,
    customer_id INT,
    discount_id INT,
    quantity INT NOT NULL,
    price FLOAT NOT NULL,
    total_price FLOAT GENERATED ALWAYS AS (quantity * price),
--    gross_margin -- potential future implementation (we do not have ALL costs associated with production)
    shipping_costs FLOAT,
    return_rate FLOAT,
    payment_method VARCHAR2(20),
    payment_status VARCHAR2(20),
    sales_channel VARCHAR2(20),
    fulfillment_status VARCHAR2(20),
    discount_code VARCHAR2(20),
    discount_type VARCHAR2(20),
    discount_value FLOAT,
    customer_segment VARCHAR2(20),
    loyalty_tier VARCHAR2(10),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (sale_id) REFERENCES instoresales(sale_id),
    FOREIGN KEY (product_id) REFERENCES finished_products(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (discount_id) REFERENCES discounts(discount_id)
);

