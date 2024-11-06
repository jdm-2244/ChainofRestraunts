-- Create Address table
CREATE TABLE public."Address" (
    id BIGINT PRIMARY KEY,
    address VARCHAR NOT NULL,
    zip VARCHAR NOT NULL
);

-- Create Customer table
CREATE TABLE public."Customer" (
    username VARCHAR NOT NULL,
    email VARCHAR NOT NULL UNIQUE,
    phone_number VARCHAR NOT NULL,
    member BOOLEAN NOT NULL,
    user_id BIGINT PRIMARY KEY,
    "First_name" VARCHAR NOT NULL,
    "Last_name" VARCHAR NOT NULL,
    CONSTRAINT check_phone_number CHECK (phone_number ~ '^[0-9]{10}$')
);

-- Create Franchise table
CREATE TABLE public."Franchise" (
    id BIGINT PRIMARY KEY,
    "City" VARCHAR NOT NULL,
    "State" VARCHAR NOT NULL,
    "Address_id" BIGINT NOT NULL,
    FOREIGN KEY ("Address_id") REFERENCES public."Address"(id)
);

-- Create menu_item table
CREATE TABLE public.menu_item (
    menu_item_id BIGINT PRIMARY KEY,
    item_name VARCHAR NOT NULL,
    type_of_menu_item VARCHAR NOT NULL,
    price BIGINT[]
);

-- Create Orders table with cust_id as foreign key to link to Customer table
CREATE TABLE public."Orders" (
    id BIGINT PRIMARY KEY,
    "Menu_items_id" BIGINT NOT NULL,
    "Franchise_id" BIGINT NOT NULL,
    cust_id BIGINT NOT NULL,  -- Added this field to link Orders to Customer
    FOREIGN KEY ("Menu_items_id") REFERENCES public.menu_item(menu_item_id),
    FOREIGN KEY ("Franchise_id") REFERENCES public."Franchise"(id),
    FOREIGN KEY (cust_id) REFERENCES public."Customer"(user_id)
);

-- Create Order_Summary table
CREATE TABLE public."Order_Summary" (
    overall_order_id BIGINT PRIMARY KEY,
    order_id BIGINT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES public."Orders"(id)
);

-- Create Payment_cards table
CREATE TABLE public."Payment_cards" (
    id BIGINT PRIMARY KEY,
    card_num CHAR(16) NOT NULL,
    user_id BIGINT NOT NULL,
    date_exp CHAR(5) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES public."Customer"(user_id)
);

-- Create Payments table
CREATE TABLE public."Payments" (
    payment_id BIGINT PRIMARY KEY,
    card_id CHAR(16) NOT NULL,
    amount BIGINT NOT NULL CHECK (amount > 0),
    cust_id BIGINT NOT NULL,
    FOREIGN KEY (cust_id) REFERENCES public."Customer"(user_id)
);

-- Create Pricing table
CREATE TABLE public."Pricing" (
    id SERIAL PRIMARY KEY,
    menu_item_id BIGINT NOT NULL,
    price BIGINT,
    FOREIGN KEY (menu_item_id) REFERENCES public.menu_item(menu_item_id)
);

-- Create Special_Menu_Items table
CREATE TABLE public."Special_Menu_Items" (
    id BIGINT PRIMARY KEY,
    entree VARCHAR,
    side_1 VARCHAR,
    side_2 VARCHAR
);

-- Create Transactions table
CREATE TABLE public."Transactions" (
    transaction_id BIGINT PRIMARY KEY,
    "Payment_id" BIGINT,
    "Cash" BOOLEAN NOT NULL,
    "Amount" BIGINT NOT NULL,
    "Order_id" BIGINT NOT NULL,
    cust_id BIGINT NOT NULL,
    FOREIGN KEY ("Order_id") REFERENCES public."Orders"(id),
    FOREIGN KEY (cust_id) REFERENCES public."Customer"(user_id)
);

-- Create Menu_Items table for additional relationship between menu and items
CREATE TABLE public."Menu_Items" (
    menu_id BIGINT PRIMARY KEY,
    menu_item_id BIGINT NOT NULL,
    FOREIGN KEY (menu_item_id) REFERENCES public.menu_item(menu_item_id)
);

-- Populate tables

-- Address table
INSERT INTO public."Address" (id, address, zip)
VALUES
    (1, '123 Maple St', '54321'),
    (2, '789 Elm St', '65432'),
    (3, '456 Oak St', '32154'),
    (4, '951 Pine St', '12345'),
    (5, '147 Cedar St', '67890');

-- Customer table
INSERT INTO public."Customer" (username, email, phone_number, member, user_id, "First_name", "Last_name")
VALUES
    ('bsmith', 'bsmith@example.com', '1234567890', true, 1, 'Brian', 'Smith'),
    ('jdoe', 'jdoe@example.com', '9876543210', false, 2, 'John', 'Doe'),
    ('awhite', 'awhite@example.com', '5647382910', true, 3, 'Amy', 'White'),
    ('cjohnson', 'cjohnson@example.com', '1928374650', true, 4, 'Chris', 'Johnson'),
    ('tlee', 'tlee@example.com', '0987654321', false, 5, 'Tina', 'Lee');

-- Franchise table
INSERT INTO public."Franchise" (id, "City", "State", "Address_id")
VALUES
    (1, 'New York', 'NY', 1),
    (2, 'Los Angeles', 'CA', 2),
    (3, 'Chicago', 'IL', 3),
    (4, 'Houston', 'TX', 4),
    (5, 'Phoenix', 'AZ', 5);

-- menu_item table
INSERT INTO public.menu_item (menu_item_id, item_name, type_of_menu_item, price)
VALUES
    (1, 'Cheeseburger', 'Main Course', ARRAY[8, 10, 12]),
    (2, 'Veggie Pizza', 'Main Course', ARRAY[10, 12, 14]),
    (3, 'Chicken Tenders', 'Appetizer', ARRAY[6, 8, 10]),
    (4, 'Caesar Salad', 'Side', ARRAY[5, 7]),
    (5, 'French Fries', 'Side', ARRAY[3, 5]),
    (6, 'Chocolate Cake', 'Dessert', ARRAY[4, 6, 8]);

-- Menu_Items table
INSERT INTO public."Menu_Items" (menu_id, menu_item_id)
VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5),
    (6, 6);

-- Orders table with cust_id linking to Customer
INSERT INTO public."Orders" (id, "Menu_items_id", "Franchise_id", cust_id)
VALUES
    (1, 1, 1, 1),
    (2, 2, 2, 2),
    (3, 3, 3, 3),
    (4, 4, 4, 4),
    (5, 5, 5, 5);

-- Order_Summary table
INSERT INTO public."Order_Summary" (overall_order_id, order_id)
VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5);

-- Payment_cards table
INSERT INTO public."Payment_cards" (id, card_num, user_id, date_exp)
VALUES
    (1, '1234567812345678', 1, '12/25'),
    (2, '2345678923456789', 2, '11/26'),
    (3, '3456789034567890', 3, '10/27'),
    (4, '4567890145678901', 4, '09/28'),
    (5, '5678901256789012', 5, '08/29');

-- Payments table
INSERT INTO public."Payments" (payment_id, card_id, amount, cust_id)
VALUES
    (1, '1234', 75, 1),
    (2, '2345', 150, 2),
    (3, '3456', 200, 3),
    (4, '4567', 85, 4),
    (5, '5678', 100, 5);

-- Pricing table
INSERT INTO public."Pricing" (menu_item_id, price)
VALUES
    (1, 10),
    (2, 12),
    (3, 15),
    (4, 20),
    (5, 18);

-- Special_Menu_Items table
INSERT INTO public."Special_Menu_Items" (id, entree, side_1, side_2)
VALUES
    (1, 'Steak', 'Mashed Potatoes', 'Green Beans'),
    (2, 'Salmon', 'Rice', 'Broccoli'),
    (3, 'Pasta', 'Garlic Bread', 'Caesar Salad'),
    (4, 'Chicken Parmesan', 'Spaghetti', 'Salad'),
    (5, 'Burger', 'Fries', 'Onion Rings');

-- Transactions table
INSERT INTO public."Transactions" (transaction_id, "Payment_id", "Cash", "Amount", "Order_id", cust_id)
VALUES
    (1, 1, true, 75, 1, 1),
    (2, 2, false, 150, 2, 2),
    (3, 3, true, 200, 3, 3),
    (4, 4, false, 85, 4, 4),
    (5, 5, true, 100, 5, 5);
