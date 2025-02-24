
-- BEGIN
--     FOR rec IN (SELECT table_name FROM user_tables) LOOP
--         EXECUTE IMMEDIATE 'DROP TABLE ' || rec.table_name || ' CASCADE CONSTRAINTS';
--     END LOOP;

--     -- Confirm all tables are dropped
--     DBMS_OUTPUT.PUT_LINE('All tables dropped successfully.');
-- END;
-- /

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


-- Insert data into finished_products
INSERT INTO finished_products (product_id, present_stock_quantity, product_name, product_category, product_sales_price)
VALUES
(1, 500, 'Product A', 'Category 1', 25.99);
INSERT INTO finished_products VALUES (2, 300, 'Product B', 'Category 2', 15.49);
INSERT INTO finished_products VALUES (3, 200, 'Product C', 'Category 3', 45.00);
INSERT INTO finished_products VALUES (4, 150, 'Product D', 'Category 4', 30.25);
INSERT INTO finished_products VALUES (5, 100, 'Product E', 'Category 1', 60.75);


-- Insert data into production_batch
INSERT INTO production_batch (batch_id, product_id, start_date, end_date, quantity_produced)
VALUES
(1, 1, TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2024-01-05', 'YYYY-MM-DD'), 500);
INSERT INTO production_batch VALUES (2, 2, TO_DATE('2024-01-06', 'YYYY-MM-DD'), TO_DATE('2024-01-10', 'YYYY-MM-DD'), 300);
INSERT INTO production_batch VALUES (3, 3, TO_DATE('2024-01-11', 'YYYY-MM-DD'), TO_DATE('2024-01-15', 'YYYY-MM-DD'), 200);
INSERT INTO production_batch VALUES (4, 4, TO_DATE('2024-01-16', 'YYYY-MM-DD'), TO_DATE('2024-01-20', 'YYYY-MM-DD'), 150);
INSERT INTO production_batch VALUES (5, 5, TO_DATE('2024-01-21', 'YYYY-MM-DD'), TO_DATE('2024-01-25', 'YYYY-MM-DD'), 100);

-- Insert data into material_usage_log
INSERT INTO material_usage_log (usage_id, batch_id, raw_material_id, quantity_used)
VALUES
(1, 1, 101, 50.5);
INSERT INTO material_usage_log VALUES (2, 2, 102, 30.0);
INSERT INTO material_usage_log VALUES (3, 3, 103, 20.0);
INSERT INTO material_usage_log VALUES (4, 4, 104, 15.5);
INSERT INTO material_usage_log VALUES (5, 5, 105, 10.0);

-- Insert data into inventory
INSERT INTO inventory (raw_material_id, last_stocked_invoice_id, raw_material_name, current_quantity, last_stocked_date, last_used_date)
VALUES
(101, 201, 'Material A', 1000, TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2024-01-05', 'YYYY-MM-DD'));
INSERT INTO inventory VALUES (102, 202, 'Material B', 800, TO_DATE('2024-01-02', 'YYYY-MM-DD'), TO_DATE('2024-01-06', 'YYYY-MM-DD'));
INSERT INTO inventory VALUES (103, 203, 'Material C', 600, TO_DATE('2024-01-03', 'YYYY-MM-DD'), TO_DATE('2024-01-07', 'YYYY-MM-DD'));
INSERT INTO inventory VALUES (104, 204, 'Material D', 400, TO_DATE('2024-01-04', 'YYYY-MM-DD'), TO_DATE('2024-01-08', 'YYYY-MM-DD'));
INSERT INTO inventory VALUES (105, 205, 'Material E', 200, TO_DATE('2024-01-05', 'YYYY-MM-DD'), TO_DATE('2024-01-09', 'YYYY-MM-DD'));

-- Insert data into cog_payment
INSERT INTO cog_payment (invoice_id, payment_status, payment_id, payment_amount, payment_mode, payment_due_on, payment_date, payment_type)
VALUES
(1, 'Paid', 1001, 500.00, 'Credit Card', TO_DATE('2024-02-01', 'YYYY-MM-DD'), TO_DATE('2024-01-30', 'YYYY-MM-DD'), 'Full Payment');
INSERT INTO cog_payment VALUES (2, 'Pending', 1002, 300.00, 'Bank Transfer', TO_DATE('2024-02-05', 'YYYY-MM-DD'), NULL, 'Partial Payment');
INSERT INTO cog_payment VALUES (3, 'Paid', 1003, 200.00, 'Cash', TO_DATE('2024-02-10', 'YYYY-MM-DD'), TO_DATE('2024-02-09', 'YYYY-MM-DD'), 'Full Payment');
INSERT INTO cog_payment VALUES (4, 'Pending', 1004, 150.00, 'Credit Card', TO_DATE('2024-02-15', 'YYYY-MM-DD'), NULL, 'Installment');
INSERT INTO cog_payment VALUES (5, 'Paid', 1005, 100.00, 'Bank Transfer', TO_DATE('2024-02-20', 'YYYY-MM-DD'), TO_DATE('2024-02-18', 'YYYY-MM-DD'), 'Full Payment');

-- Insert data into supplier
INSERT INTO supplier (supplier_id, supplier_name, supplier_address, phone, email)
VALUES
(1, 'Supplier A', '123 Elm St', '1231231234', 'supplierA@example.com');
INSERT INTO supplier VALUES (2, 'Supplier B', '456 Walnut St', '2342342345', 'supplierB@example.com');
INSERT INTO supplier VALUES (3, 'Supplier C', '789 Cherry St', '3453453456', 'supplierC@example.com');
INSERT INTO supplier VALUES (4, 'Supplier D', '101 Maple Ave', '4564564567', 'supplierD@example.com');
INSERT INTO supplier VALUES (5, 'Supplier E', '202 Pine Rd', '5675675678', 'supplierE@example.com');

-- Insert data into purchase_order
INSERT INTO purchase_order (invoice_id, supplier_id, order_date, status, amount)
VALUES
(1, 1, TO_DATE('2024-01-01', 'YYYY-MM-DD'), 'Completed', 500.00);
INSERT INTO purchase_order VALUES (2, 2, TO_DATE('2024-01-02', 'YYYY-MM-DD'), 'Pending', 300.00);
INSERT INTO purchase_order VALUES (3, 3, TO_DATE('2024-01-03', 'YYYY-MM-DD'), 'Completed', 200.00);
INSERT INTO purchase_order VALUES (4, 4, TO_DATE('2024-01-04', 'YYYY-MM-DD'), 'Pending', 150.00);
INSERT INTO purchase_order VALUES (5, 5, TO_DATE('2024-01-05', 'YYYY-MM-DD'), 'Completed', 100.00);

-- Insert data into delivery
INSERT INTO delivery (supplier_id, invoice_id, lineitem_id, date_of_arrival, quantity, quantity_type, warehouse_location, shipment_status, procurement_type)
VALUES
(1, 1, 1, TO_DATE('2024-01-06', 'YYYY-MM-DD'), 500, 'Units', 'Warehouse A', 'Delivered', 'Standard');
INSERT INTO delivery VALUES (2, 2, 2, TO_DATE('2024-01-07', 'YYYY-MM-DD'), 300, 'Units', 'Warehouse B', 'In Transit', 'Express');
INSERT INTO delivery VALUES (3, 3, 3, TO_DATE('2024-01-08', 'YYYY-MM-DD'), 200, 'Units', 'Warehouse C', 'Delivered', 'Standard');
INSERT INTO delivery VALUES (4, 4, 4, TO_DATE('2024-01-09', 'YYYY-MM-DD'), 150, 'Units', 'Warehouse D', 'In Transit', 'Express');
INSERT INTO delivery VALUES (5, 5, 5, TO_DATE('2024-01-10', 'YYYY-MM-DD'), 100, 'Units', 'Warehouse E', 'Delivered', 'Standard');

-- Insert data into raw_materials
INSERT INTO raw_materials (invoice_id, lineitem_id, quantity, quantity_name, unit_price, total_price)
VALUES
(1, 1, 1000, 'Kg', 5.00, 5000.00);
INSERT INTO raw_materials VALUES (2, 2, 800, 'Kg', 4.50, 3600.00);
INSERT INTO

 raw_materials VALUES (3, 3, 600, 'Kg', 6.00, 3600.00);
INSERT INTO raw_materials VALUES (4, 4, 400, 'Kg', 7.50, 3000.00);
INSERT INTO raw_materials VALUES (5, 5, 200, 'Kg', 10.00, 2000.00);


