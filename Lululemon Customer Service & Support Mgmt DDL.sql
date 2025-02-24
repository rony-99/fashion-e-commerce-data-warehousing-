BEGIN
   FOR t IN (SELECT table_name FROM user_tables) LOOP
      EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
   END LOOP;
END;

--------------------------------------------------------------------------------

CREATE TABLE Products (
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR2(50) NOT NULL,
    Product_Category VARCHAR2(20),
    Product_Size VARCHAR2(10),
    Product_Color VARCHAR2(10),
    Product_SKU VARCHAR2(15)
);


CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR2(100) NOT NULL,
    Customer_Email VARCHAR2(100) NOT NULL,
    Customer_Phone VARCHAR2(15),
    Customer_Address_Line_1 VARCHAR2(50),
    Customer_Address_Line_2 VARCHAR2(50),
    Customer_City VARCHAR2(50),
    Customer_State VARCHAR2(20),
    Customer_Zip_Code INT,
    Customer_Segment VARCHAR2(20)
);


CREATE TABLE Product_Returns (
    Return_ID INT PRIMARY KEY,
    Product_ID INT NOT NULL,
    Customer_ID INT NOT NULL,
    Order_ID INT,
    Return_Date DATE NOT NULL,
    Return_Reason VARCHAR2(30),
    Return_Status VARCHAR2(20),
    FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);


CREATE TABLE Product_Issues (
    Issue_ID INT PRIMARY KEY,
    Product_ID INT NOT NULL,
    Customer_ID INT NOT NULL,
    Issue_Reported_Date DATE NOT NULL,
    Issue_Description VARCHAR2(200),
    Resolution_Status VARCHAR2(20),
    Issue_Last_Updated DATE,
    FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);


CREATE TABLE Returns_Issues_Link (
    Link_ID INT PRIMARY KEY,
    Return_ID INT NOT NULL,
    Issue_ID INT NOT NULL,
    Link_Date DATE,
    FOREIGN KEY (Return_ID) REFERENCES Product_Returns(Return_ID),
    FOREIGN KEY (Issue_ID) REFERENCES Product_Issues(Issue_ID)
);


CREATE TABLE Tickets (
    Ticket_ID INT PRIMARY KEY,
    Customer_ID INT NOT NULL,
    Ticket_Category VARCHAR2(50),
    Ticket_Description VARCHAR2(200),
    Priority VARCHAR2(10),
    Status VARCHAR2(20),
    Creation_Date DATE,
    Resolution_Date DATE,
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);


CREATE TABLE Agents (
    Agent_ID INT PRIMARY KEY,
    Agent_Name VARCHAR2(100),
    Agent_Email VARCHAR2(50),
    Department VARCHAR2(10),
    Agent_Level VARCHAR2(20)
);


CREATE TABLE Customer_Interactions (
    Interaction_ID INT PRIMARY KEY,
    Ticket_ID INT NOT NULL,
    Agent_ID INT NOT NULL,
    Interaction_Date DATE,
    Interaction_Content VARCHAR2(200),
    FOREIGN KEY (Ticket_ID) REFERENCES Tickets(Ticket_ID),
    FOREIGN KEY (Agent_ID) REFERENCES Agents(Agent_ID)
);


CREATE TABLE Memberships (
    Membership_ID INT PRIMARY KEY,
    Customer_ID INT NOT NULL,
    Tier VARCHAR2(10) NOT NULL,
    Membership_Start DATE NOT NULL,
    Membership_End DATE NOT NULL,
    Points_Balance INT DEFAULT 0,
    Status VARCHAR2(20),
    Last_Updated DATE,
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);


CREATE TABLE Transactions (
    Transaction_ID INT PRIMARY KEY,
    Membership_ID INT NOT NULL,
--    Sale_ID INT,
--    Order_ID INT,
    Points_Earned INT,
    Points_Redeemed INT,
    Transaction_Date DATE,
--    FOREIGN KEY (Sale_ID) REFERENCES In_Store_Sales(Sale_ID),
--    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID),
    FOREIGN KEY (Membership_ID) REFERENCES Memberships(Membership_ID)
);


CREATE TABLE Rewards (
    Reward_ID INT PRIMARY KEY,
    Reward_Name VARCHAR2(50) NOT NULL,
    Point_Cost INT NOT NULL,
    Reward_Description VARCHAR2(200),
    Reward_Expiry_Date DATE
);


CREATE TABLE Reward_Redemptions (
    Redemption_ID INT PRIMARY KEY,
    Membership_ID INT NOT NULL,
    Reward_ID INT NOT NULL,
    Redemption_Date DATE,
    FOREIGN KEY (Membership_ID) REFERENCES Memberships(Membership_ID),
    FOREIGN KEY (Reward_ID) REFERENCES Rewards(Reward_ID)
);

--------------------------------------------------------------------------------

INSERT INTO Products (Product_ID, Product_Name, Product_Category, Product_Size, Product_Color, Product_SKU)
VALUES (1, 'Wunder Train High-Rise Tight', 'Apparel', 'M', 'Black', 'WTHT001');

INSERT INTO Products (Product_ID, Product_Name, Product_Category, Product_Size, Product_Color, Product_SKU)
VALUES (2, 'Swiftly Tech Long Sleeve Shirt 2.0', 'Apparel', 'L', 'Gray', 'STLS002');

INSERT INTO Products (Product_ID, Product_Name, Product_Category, Product_Size, Product_Color, Product_SKU)
VALUES (3, 'Power Pivot Tank Top', 'Apparel', 'S', 'White', 'PPTT003');

INSERT INTO Products (Product_ID, Product_Name, Product_Category, Product_Size, Product_Color, Product_SKU)
VALUES (4, 'Align High-Rise Pant', 'Apparel', 'M', 'Black', 'AHRP004');

INSERT INTO Products (Product_ID, Product_Name, Product_Category, Product_Size, Product_Color, Product_SKU)
VALUES (5, 'Energy Bra Long Line', 'Apparel', 'M', 'Pink', 'EBLL005');

INSERT INTO Products (Product_ID, Product_Name, Product_Category, Product_Size, Product_Color, Product_SKU)
VALUES (6, 'The Reversible Mat 5mm', 'Accessories', 'N/A', 'Black', 'TRM005');

INSERT INTO Products (Product_ID, Product_Name, Product_Category, Product_Size, Product_Color, Product_SKU)
VALUES (7, 'Fast and Free Running Belt', 'Accessories', 'N/A', 'Black', 'FFRB006');

INSERT INTO Products (Product_ID, Product_Name, Product_Category, Product_Size, Product_Color, Product_SKU)
VALUES (8, 'New Crew Backpack 22L', 'Accessories', 'N/A', 'Graphite', 'NCB022');

INSERT INTO Products (Product_ID, Product_Name, Product_Category, Product_Size, Product_Color, Product_SKU)
VALUES (9, 'Metal Vent Tech Short Sleeve Shirt', 'Apparel', 'XL', 'Navy', 'MVTSS007');

INSERT INTO Products (Product_ID, Product_Name, Product_Category, Product_Size, Product_Color, Product_SKU)
VALUES (10, 'Pace Breaker Linerless Shorts 7"', 'Apparel', 'L', 'Obsidian', 'PBLS008');

--------------------------------------------------------------------------------

INSERT INTO Customers (Customer_ID, Customer_Name, Customer_Email, Customer_Phone, Customer_Address_Line_1, Customer_City, Customer_State, Customer_Zip_Code)
VALUES (101, 'John Doe', 'john.doe@example.com', '5551234567', '123 Elm Street', 'New York', 'NY', 10001);

INSERT INTO Customers (Customer_ID, Customer_Name, Customer_Email, Customer_Phone, Customer_Address_Line_1, Customer_City, Customer_State, Customer_Zip_Code)
VALUES (102, 'Jane Smith', 'jane.smith@example.com', '5559876543', '456 Oak Avenue', 'Los Angeles', 'CA', 90001);

INSERT INTO Customers (Customer_ID, Customer_Name, Customer_Email, Customer_Phone, Customer_Address_Line_1, Customer_City, Customer_State, Customer_Zip_Code)
VALUES (103, 'Emily Brown', 'emily.brown@example.com', '5551112222', '789 Birch Lane', 'Chicago', 'IL', 60601);

INSERT INTO Customers (Customer_ID, Customer_Name, Customer_Email, Customer_Phone, Customer_Address_Line_1, Customer_City, Customer_State, Customer_Zip_Code)
VALUES (104, 'Michael Johnson', 'michael.johnson@example.com', '5553334444', '321 Pine Street', 'Boston', 'MA', 02108);

INSERT INTO Customers (Customer_ID, Customer_Name, Customer_Email, Customer_Phone, Customer_Address_Line_1, Customer_City, Customer_State, Customer_Zip_Code)
VALUES (105, 'Chris Lee', 'chris.lee@example.com', '5552223333', '789 Pine Road', 'Houston', 'TX', 77001);

INSERT INTO Customers (Customer_ID, Customer_Name, Customer_Email, Customer_Phone, Customer_Address_Line_1, Customer_City, Customer_State, Customer_Zip_Code)
VALUES (106, 'Sophia Green', 'sophia.green@example.com', '5554445555', '123 Maple Lane', 'Seattle', 'WA', 98101);

INSERT INTO Customers (Customer_ID, Customer_Name, Customer_Email, Customer_Phone, Customer_Address_Line_1, Customer_City, Customer_State, Customer_Zip_Code)
VALUES (107, 'Olivia White', 'olivia.white@example.com', '5556667777', '456 Cedar Street', 'Denver', 'CO', 80201);

INSERT INTO Customers (Customer_ID, Customer_Name, Customer_Email, Customer_Phone, Customer_Address_Line_1, Customer_City, Customer_State, Customer_Zip_Code)
VALUES (108, 'James Black', 'james.black@example.com', '5558889999', '321 Birch Drive', 'Atlanta', 'GA', 30301);

INSERT INTO Customers (Customer_ID, Customer_Name, Customer_Email, Customer_Phone, Customer_Address_Line_1, Customer_City, Customer_State, Customer_Zip_Code)
VALUES (109, 'Liam Davis', 'liam.davis@example.com', '5557778888', '654 Spruce Road', 'Phoenix', 'AZ', 85001);

INSERT INTO Customers (Customer_ID, Customer_Name, Customer_Email, Customer_Phone, Customer_Address_Line_1, Customer_City, Customer_State, Customer_Zip_Code)
VALUES (110, 'Amelia Brown', 'amelia.brown@example.com', '5559991111', '987 Willow Way', 'Orlando', 'FL', 32801);

--------------------------------------------------------------------------------

INSERT INTO Product_Returns (Return_ID, Product_ID, Customer_ID, Order_ID, Return_Date, Return_Reason, Return_Status)
VALUES (1, 1, 101, 5001, TO_DATE('2024-11-01', 'YYYY-MM-DD'), 'Wrong Size', 'Processed');

INSERT INTO Product_Returns (Return_ID, Product_ID, Customer_ID, Order_ID, Return_Date, Return_Reason, Return_Status)
VALUES (2, 2, 102, 5002, TO_DATE('2024-11-05', 'YYYY-MM-DD'), 'Defective', 'Pending');

INSERT INTO Product_Returns (Return_ID, Product_ID, Customer_ID, Order_ID, Return_Date, Return_Reason, Return_Status)
VALUES (3, 6, 103, 5003, TO_DATE('2024-11-10', 'YYYY-MM-DD'), 'Color mismatch', 'Pending');

INSERT INTO Product_Returns (Return_ID, Product_ID, Customer_ID, Order_ID, Return_Date, Return_Reason, Return_Status)
VALUES (4, 4, 104, 5004, TO_DATE('2024-11-12', 'YYYY-MM-DD'), 'Fabric tore', 'Processed');

--------------------------------------------------------------------------------

INSERT INTO Product_Issues (Issue_ID, Product_ID, Customer_ID, Issue_Reported_Date, Issue_Description, Resolution_Status, Issue_Last_Updated)
VALUES (1, 1, 101, TO_DATE('2024-11-01', 'YYYY-MM-DD'), 'Fabric wore out after three washes.', 'Resolved', TO_DATE('2024-11-03', 'YYYY-MM-DD'));

INSERT INTO Product_Issues (Issue_ID, Product_ID, Customer_ID, Issue_Reported_Date, Issue_Description, Resolution_Status, Issue_Last_Updated)
VALUES (2, 2, 102, TO_DATE('2024-11-03', 'YYYY-MM-DD'), 'Seam came undone.', 'Pending', NULL);

INSERT INTO Product_Issues (Issue_ID, Product_ID, Customer_ID, Issue_Reported_Date, Issue_Description, Resolution_Status, Issue_Last_Updated)
VALUES (3, 6, 103, TO_DATE('2024-11-10', 'YYYY-MM-DD'), 'Slippery surface while in use.', 'In Progress', TO_DATE('2024-11-12', 'YYYY-MM-DD'));

INSERT INTO Product_Issues (Issue_ID, Product_ID, Customer_ID, Issue_Reported_Date, Issue_Description, Resolution_Status, Issue_Last_Updated)
VALUES (4, 9, 104, TO_DATE('2024-11-15', 'YYYY-MM-DD'), 'Thread unraveling at the sleeves.', 'Pending', NULL);

--------------------------------------------------------------------------------

INSERT INTO Returns_Issues_Link (Link_ID, Return_ID, Issue_ID, Link_Date)
VALUES (1, 1, 1, TO_DATE('2024-11-02', 'YYYY-MM-DD'));

INSERT INTO Returns_Issues_Link (Link_ID, Return_ID, Issue_ID, Link_Date)
VALUES (2, 2, 2, TO_DATE('2024-11-05', 'YYYY-MM-DD'));

INSERT INTO Returns_Issues_Link (Link_ID, Return_ID, Issue_ID, Link_Date)
VALUES (3, 3, 3, TO_DATE('2024-11-11', 'YYYY-MM-DD'));

INSERT INTO Returns_Issues_Link (Link_ID, Return_ID, Issue_ID, Link_Date)
VALUES (4, 4, 4, TO_DATE('2024-11-16', 'YYYY-MM-DD'));

--------------------------------------------------------------------------------

INSERT INTO Tickets (Ticket_ID, Customer_ID, Ticket_Category, Ticket_Description, Priority, Status, Creation_Date, Resolution_Date)
VALUES (1, 101, 'Product Issue', 'Requested size unavailable for Wunder Train.', 'High', 'Resolved', TO_DATE('2024-11-01', 'YYYY-MM-DD'), TO_DATE('2024-11-02', 'YYYY-MM-DD'));

INSERT INTO Tickets (Ticket_ID, Customer_ID, Ticket_Category, Ticket_Description, Priority, Status, Creation_Date, Resolution_Date)
VALUES (2, 102, 'Delivery Issue', 'Swiftly Tech Long Sleeve not delivered.', 'Medium', 'Pending', TO_DATE('2024-11-03', 'YYYY-MM-DD'), NULL);

INSERT INTO Tickets (Ticket_ID, Customer_ID, Ticket_Category, Ticket_Description, Priority, Status, Creation_Date, Resolution_Date)
VALUES (3, 103, 'Quality Complaint', 'Slippery yoga mat makes it unsafe for use.', 'High', 'In Progress', TO_DATE('2024-11-10', 'YYYY-MM-DD'), NULL);

INSERT INTO Tickets (Ticket_ID, Customer_ID, Ticket_Category, Ticket_Description, Priority, Status, Creation_Date, Resolution_Date)
VALUES (4, 104, 'Order Cancellation', 'Requested cancellation not processed.', 'Medium', 'Resolved', TO_DATE('2024-11-10', 'YYYY-MM-DD'), TO_DATE('2024-11-12', 'YYYY-MM-DD'));

--------------------------------------------------------------------------------

INSERT INTO Memberships (Membership_ID, Customer_ID, Tier, Membership_Start, Membership_End, Points_Balance, Status, Last_Updated)
VALUES (1, 101, 'Gold', TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'), 1500, 'Active', TO_DATE('2024-11-01', 'YYYY-MM-DD'));

INSERT INTO Memberships (Membership_ID, Customer_ID, Tier, Membership_Start, Membership_End, Points_Balance, Status, Last_Updated)
VALUES (2, 102, 'Silver', TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'), 800, 'Active', TO_DATE('2024-11-02', 'YYYY-MM-DD'));

INSERT INTO Memberships (Membership_ID, Customer_ID, Tier, Membership_Start, Membership_End, Points_Balance, Status, Last_Updated)
VALUES (3, 103, 'Gold', TO_DATE('2024-01-15', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'), 2000, 'Active', TO_DATE('2024-11-09', 'YYYY-MM-DD'));

INSERT INTO Memberships (Membership_ID, Customer_ID, Tier, Membership_Start, Membership_End, Points_Balance, Status, Last_Updated)
VALUES (4, 104, 'Bronze', TO_DATE('2024-05-01', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'), 300, 'Active', TO_DATE('2024-11-10', 'YYYY-MM-DD'));

--------------------------------------------------------------------------------

INSERT INTO Transactions (Transaction_ID, Membership_ID, Points_Earned, Points_Redeemed, Transaction_Date)
VALUES (1, 1, 500, 0, TO_DATE('2024-11-01', 'YYYY-MM-DD'));

INSERT INTO Transactions (Transaction_ID, Membership_ID, Points_Earned, Points_Redeemed, Transaction_Date)
VALUES (2, 2, 300, 200, TO_DATE('2024-11-02', 'YYYY-MM-DD'));

INSERT INTO Transactions (Transaction_ID, Membership_ID, Points_Earned, Points_Redeemed, Transaction_Date)
VALUES (3, 3, 700, 0, TO_DATE('2024-11-10', 'YYYY-MM-DD'));

INSERT INTO Transactions (Transaction_ID, Membership_ID, Points_Earned, Points_Redeemed, Transaction_Date)
VALUES (4, 4, 100, 50, TO_DATE('2024-11-12', 'YYYY-MM-DD'));

--------------------------------------------------------------------------------

INSERT INTO Rewards (Reward_ID, Reward_Name, Point_Cost, Reward_Description, Reward_Expiry_Date)
VALUES (1, 'Free Wunder Train Tight', 1500, 'Redeem for one pair of Wunder Train High-Rise Tight.', TO_DATE('2025-01-31', 'YYYY-MM-DD'));

INSERT INTO Rewards (Reward_ID, Reward_Name, Point_Cost, Reward_Description, Reward_Expiry_Date)
VALUES (2, 'Discount on Yoga Mat', 800, 'Get $20 off The Reversible Mat 5mm.', TO_DATE('2024-12-31', 'YYYY-MM-DD'));

INSERT INTO Rewards (Reward_ID, Reward_Name, Point_Cost, Reward_Description, Reward_Expiry_Date)
VALUES (3, 'Free Backpack', 1200, 'Redeem for the New Crew Backpack 22L.', TO_DATE('2025-03-31', 'YYYY-MM-DD'));

INSERT INTO Rewards (Reward_ID, Reward_Name, Point_Cost, Reward_Description, Reward_Expiry_Date)
VALUES (4, 'Energy Bra Discount', 700, '$10 off on Energy Bra Long Line.', TO_DATE('2024-12-31', 'YYYY-MM-DD'));

--------------------------------------------------------------------------------

INSERT INTO Reward_Redemptions (Redemption_ID, Membership_ID, Reward_ID, Redemption_Date)
VALUES (1, 1, 1, TO_DATE('2024-11-02', 'YYYY-MM-DD'));

INSERT INTO Reward_Redemptions (Redemption_ID, Membership_ID, Reward_ID, Redemption_Date)
VALUES (2, 2, 2, TO_DATE('2024-11-03', 'YYYY-MM-DD'));

INSERT INTO Reward_Redemptions (Redemption_ID, Membership_ID, Reward_ID, Redemption_Date)
VALUES (3, 3, 3, TO_DATE('2024-11-12', 'YYYY-MM-DD'));

INSERT INTO Reward_Redemptions (Redemption_ID, Membership_ID, Reward_ID, Redemption_Date)
VALUES (4, 4, 4, TO_DATE('2024-11-15', 'YYYY-MM-DD'));

--------------------------------------------------------------------------------

