CREATE DATABASE IMS;
USE IMS;

--  CREATE TABLES

-- Stores brand information (e.g., Apple, Samsung)
CREATE TABLE brands (
  bid INT PRIMARY KEY,              -- Brand ID (Unique identifier)
  bname VARCHAR(50)                 -- Brand Name (e.g., 'Nike')
);

-- Stores user accounts for system access
CREATE TABLE inv_user (
  user_id VARCHAR(50) PRIMARY KEY,  -- User email (used as login ID)
  name VARCHAR(50),                 -- Full name of user
  password VARCHAR(50),             -- Login password (plaintext for demo only - should be hashed)
  last_login DATETIME,              -- Timestamp of last successful login
  user_type VARCHAR(20)             -- Role: 'admin', 'manager', etc.
);

-- Product classification categories
CREATE TABLE categories (
  cid INT PRIMARY KEY,              -- Category ID
  category_name VARCHAR(50)         -- Name (e.g., 'Electronics', 'Clothing')
);

-- Physical store locations
CREATE TABLE stores (
  sid INT PRIMARY KEY,              -- Store ID
  sname VARCHAR(50),                -- Store owner/manager name
  address VARCHAR(100),             -- Full store address
  mobno BIGINT                      -- Contact mobile number
);


-- All products in inventory
CREATE TABLE product (
  pid INT PRIMARY KEY,              -- Product ID
  cid INT,                          -- Category ID (links to categories table)
  bid INT,                          -- Brand ID (links to brands table)
  sid INT,                          -- Store ID (where product is located)
  pname VARCHAR(50),                -- Product name (e.g., 'iPhone 13')
  p_stock INT,                      -- Current stock quantity
  price INT,                        -- Selling price per unit
  added_date DATE,                  -- Date product was added to inventory
  FOREIGN KEY (cid) REFERENCES categories(cid),
  FOREIGN KEY (bid) REFERENCES brands(bid),
  FOREIGN KEY (sid) REFERENCES stores(sid)
);


-- Discounts offered by brands at specific stores
CREATE TABLE provides (
  bid INT,                          -- Brand ID
  sid INT,                          -- Store ID
  discount INT,                     -- Discount percentage (e.g., 10 = 10%)
  FOREIGN KEY (bid) REFERENCES brands(bid),
  FOREIGN KEY (sid) REFERENCES stores(sid),
  PRIMARY KEY (bid, sid)            -- Composite key (each brand-store combo is unique)
);

-- Customer shopping carts
CREATE TABLE customer_cart (
  cust_id INT PRIMARY KEY,          -- Customer ID
  name VARCHAR(50),                 -- Customer name
  mobno BIGINT                      -- Customer mobile number
);

-- Products added to customer carts
CREATE TABLE select_product (
  cust_id INT,                      -- Customer ID (links to customer_cart)
  pid INT,                          -- Product ID (links to product table)
  quantity INT,                     -- Quantity selected
  FOREIGN KEY (cust_id) REFERENCES customer_cart(cust_id),
  FOREIGN KEY (pid) REFERENCES product(pid),
  PRIMARY KEY (cust_id, pid)        -- Prevent duplicate products in cart
);

-- Sales transactions
CREATE TABLE transaction_table (
  id INT PRIMARY KEY,               -- Transaction ID
  total_amount INT,                 -- Total bill amount
  paid INT,                         -- Amount paid by customer
  due INT,                          -- Remaining balance (if partial payment)
  gst INT,                          -- GST tax amount
  discount INT,                     -- Total discount applied
  payment_method VARCHAR(20),       -- 'cash', 'card', 'upi'
  cart_id INT,                      -- Customer cart ID (links to customer_cart)
  FOREIGN KEY (cart_id) REFERENCES customer_cart(cust_id)
);

-- Line items for each transaction
CREATE TABLE invoice (
  item_no INT,                      -- Line item number (1, 2, 3...)
  product_name VARCHAR(50),         -- Product name at time of sale
  quantity INT,                     -- Quantity sold
  net_price INT,                    -- Price after discounts
  transaction_id INT,               -- Links to transaction_table
  FOREIGN KEY (transaction_id) REFERENCES transaction_table(id)
);
select * from invoice;
-- =============================================
-- 2. SAMPLE DATA INSERTION
-- =============================================

-- Insert brand data
INSERT INTO brands 
(bid, bname) VALUES 
(1, 'Apple'),      -- Electronics
(2, 'Samsung'),    -- Electronics
(3, 'Nike'),       -- Clothing
(4, 'Fortune'),    -- Grocery
(5, 'Sony'),       -- Electronics
(6, 'Adidas');     -- Clothing

-- Insert user accounts
INSERT INTO inv_user 
(user_id, name, password, last_login, user_type) VALUES 
('vidit@gmail.com', 'Vidit', '1234', '2024-04-24 10:30:00', 'admin'),
('harsh@gmail.com', 'Harsh', '1111', '2024-04-23 09:15:00', 'manager'),
('sneha@gmail.com', 'Sneha', 'abcd', '2024-04-20 08:00:00', 'admin'),
('rahul@gmail.com', 'Rahul', '2222', '2024-04-22 11:00:00', 'manager');

-- Insert product categories
INSERT INTO categories 
(cid, category_name) VALUES 
(1, 'Electronics'),  -- Phones, laptops
(2, 'Clothing'),     -- Shirts, shoes
(3, 'Grocery'),      -- Food items
(4, 'Appliances'),   -- Home appliances
(5, 'Accessories');  -- Headphones, cases

-- Insert store locations
INSERT INTO stores 
(sid, sname, address, mobno) VALUES 
(1, 'Ram Kumar', 'Katpadi, Vellore', 9876543210),  -- Electronics store
(2, 'Rakesh', 'Chennai', 9123456780),             -- Clothing store
(3, 'Suraj', 'Haryana', 9988776655),              -- Grocery store
(4, 'Vikram', 'Mumbai', 9011223344),              -- Multi-category
(5, 'Deepak', 'Delhi', 9090909090);               -- Electronics store

-- Insert products
INSERT INTO product 
(pid, cid, bid, sid, pname, p_stock, price, added_date) VALUES 
(1, 1, 1, 1, 'iPhone 13', 10, 75000, '2024-04-01'),          -- Apple phone
(2, 1, 1, 1, 'AirPods Pro', 15, 25000, '2024-04-01'),        -- Apple earphones
(3, 2, 3, 2, 'Nike Shoes', 20, 5000, '2024-04-01'),          -- Nike footwear
(4, 3, 4, 3, 'Sunflower Oil', 50, 180, '2024-04-01'),        -- Grocery item
(5, 5, 1, 4, 'Sony Headphones', 12, 9000, '2024-04-02'),     -- Audio accessory
(6, 2, 6, 2, 'Adidas T-shirt', 30, 1200, '2024-04-03'),      -- Clothing
(7, 1, 2, 1, 'Samsung Galaxy S22', 8, 68000, '2024-04-04'),  -- Samsung phone
(8, 3, 4, 3, 'Fortune Rice', 40, 200, '2024-04-05');         -- Grocery item

-- Insert brand-store discounts
INSERT INTO provides 
(bid, sid, discount) VALUES 
(1, 1, 10),   -- 10% discount on Apple at Store 1
(3, 2, 15),   -- 15% discount on Nike at Store 2
(4, 3, 20),   -- 20% discount on Fortune at Store 3
(5, 4, 5),    -- 5% discount on Sony at Store 4
(6, 2, 10);   -- 10% discount on Adidas at Store 2

-- Insert customer carts
INSERT INTO customer_cart 
(cust_id, name, mobno) VALUES 
(1, 'Amit', 9999911111),   -- Customer 1
(2, 'Suman', 8888811111),  -- Customer 2
(3, 'Ravi', 7777711111),   -- Customer 3
(4, 'Priya', 6666611111);  -- Customer 4

-- Insert products in carts
INSERT INTO select_product 
(cust_id, pid, quantity) VALUES 
(1, 1, 1),   -- Customer 1: 1x iPhone 13
(1, 2, 2),   -- Customer 1: 2x AirPods Pro
(2, 3, 1),   -- Customer 2: 1x Nike Shoes
(3, 4, 3),   -- Customer 3: 3x Sunflower Oil
(4, 5, 1),   -- Customer 4: 1x Sony Headphones
(4, 6, 2);   -- Customer 4: 2x Adidas T-shirt

-- Insert transactions
INSERT INTO transaction_table 
(id, total_amount, paid, due, gst, discount, payment_method, cart_id) VALUES 
(1, 125000, 125000, 0, 6250, 5000, 'card', 1),   -- Full payment (card)
(2, 5000, 3000, 2000, 250, 500, 'cash', 2),     -- Partial payment (cash)
(3, 540, 500, 40, 25, 20, 'upi', 3),            -- UPI payment
(4, 12000, 10800, 1200, 600, 400, 'card', 4);   -- Partial payment (card)

-- Insert invoice line items
INSERT INTO invoice 
(item_no, product_name, quantity, net_price, transaction_id) VALUES 
(1, 'iPhone 13', 1, 75000, 1),         -- Transaction 1, Item 1
(2, 'AirPods Pro', 2, 50000, 1),       -- Transaction 1, Item 2
(3, 'Nike Shoes', 1, 5000, 2),         -- Transaction 2, Item 1
(4, 'Sunflower Oil', 3, 540, 3),       -- Transaction 3, Item 1
(5, 'Sony Headphones', 1, 9000, 4),    -- Transaction 4, Item 1
(6, 'Adidas T-shirt', 2, 2400, 4);     -- Transaction 4, Item 2

-- -------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------

-- This query shows all products along with their brand names and categories
SELECT 
    p.pname AS 'Product',  -- Select product name and label column as 'Product'
    b.bname AS 'Brand',    -- Select brand name and label column as 'Brand'
    c.category_name AS 'Category'  -- Select category name and label column as 'Category'
FROM 
    product p  -- Start with the product table (aliased as 'p')
JOIN 
    brands b ON p.bid = b.bid  -- Connect to brands table where brand IDs match
JOIN 
    categories c ON p.cid = c.cid;  -- Connect to categories table where category IDs match

-- -------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------

-- This query finds products that are running low in stock
SELECT 
    pname AS 'Product',  -- Show product name
    p_stock AS 'Stock'   -- Show current stock quantity
FROM 
    product  -- From the product table
WHERE 
    p_stock < 15  -- Only include products with less than 15 items in stock
ORDER BY 
    p_stock;  -- Sort results from lowest to highest stock

    
-- -------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------

-- This query finds the highest-priced item in each category
SELECT 
    c.category_name AS 'Category',  -- Show category name
    MAX(p.price) AS 'Max Price'     -- Find the maximum price in each category
FROM 
    product p  -- From product table (aliased as 'p')
JOIN 
    categories c ON p.cid = c.cid  -- Connect to categories table
GROUP BY 
    c.category_name;  -- Group results by category
    
-- -------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------

-- This query shows what items a specific customer bought
SELECT 
    p.pname AS 'Product',  -- Product name
    sp.quantity AS 'Qty'   -- How many they bought
FROM 
    select_product sp  -- From the 'selected products' table (what's in carts)
JOIN 
    product p ON sp.pid = p.pid  -- Connect to product details
JOIN 
    customer_cart c ON sp.cust_id = c.cust_id  -- Connect to customer info
WHERE 
    c.name = 'Amit';  -- Only show purchases by customer named Amit
    
-- -------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------

-- This query calculates the store's total earnings
SELECT 
    SUM(total_amount) AS 'Total Revenue'  -- Add up all transaction amounts
FROM 
    transaction_table;  -- From the sales records

-- -------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------

-- This query shows customers who haven't fully paid their bills
SELECT 
    c.name AS 'Customer',  -- Customer name
    t.due AS 'Pending Amount'  -- How much they still owe
FROM 
    customer_cart c  -- From customer list
JOIN 
    transaction_table t ON c.cust_id = t.cart_id  -- Connect to their transactions
WHERE 
    t.due > 0;  -- Only show if they owe money (due amount > 0)
    
-- -------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------
    
    
DELIMITER //

CREATE TRIGGER update_stock_after_sale
AFTER INSERT ON invoice  -- Runs after new invoice entry
FOR EACH ROW
BEGIN
    -- Reduce stock for the sold product
    UPDATE product
    SET p_stock = p_stock - NEW.quantity  -- NEW = newly inserted invoice row
    WHERE pname = NEW.product_name;  -- Match product by name
END//

DELIMITER ;

INSERT INTO invoice VALUES (7, 'iPhone 13', 2, 150000, 101);
    