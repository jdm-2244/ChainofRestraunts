-- Populate Address Table
INSERT INTO public."Address" (id, address, zip)
VALUES
    (1, '123 Maple St', '54321'),
    (2, '789 Elm St', '65432'),
    (3, '456 Oak St', '32154'),
    (4, '951 Pine St', '12345'),
    (5, '147 Cedar St', '67890');

-- Populate Customer Table
INSERT INTO public."Customer" (username, email, phone_number, member, user_id, "First_name", "Last_name")
VALUES
    ('bsmith', 'bsmith@example.com', '1234567890', true, 1, 'Brian', 'Smith'),
    ('jdoe', 'jdoe@example.com', '9876543210', false, 2, 'John', 'Doe'),
    ('awhite', 'awhite@example.com', '5647382910', true, 3, 'Amy', 'White'),
    ('cjohnson', 'cjohnson@example.com', '1928374650', true, 4, 'Chris', 'Johnson'),
    ('tlee', 'tlee@example.com', '0987654321', false, 5, 'Tina', 'Lee');

-- Populate Franchise Table
INSERT INTO public."Franchise" (id, "City", "State", "Address_id")
VALUES
    (1, 'New York', 'NY', 1),
    (2, 'Los Angeles', 'CA', 2),
    (3, 'Chicago', 'IL', 3),
    (4, 'Houston', 'TX', 4),
    (5, 'Phoenix', 'AZ', 5);

-- Populate Menu_Items Table
INSERT INTO public."Menu_Items" (menu_id, menu_item_id)
VALUES
    (1, 1),
    (1, 2),
    (2, 3),
    (3, 4),
    (4, 5),
    (5, 6);

-- Populate Orders Table
INSERT INTO public."Orders" (id, "Menu_items_id", "Franchise_id")
VALUES
    (1, 1, 1),
    (2, 2, 2),
    (3, 3, 3),
    (4, 4, 4),
    (5, 5, 5);

-- Populate Order_Summary Table
INSERT INTO public."Order_Summary" (overall_order_id, order_id)
VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5);

-- Populate Payment_cards Table
INSERT INTO public."Payment_cards" (id, card_num, user_id, date_exp)
VALUES
    (1, '1234567812345678', 1, '12/25'),
    (2, '2345678923456789', 2, '11/26'),
    (3, '3456789034567890', 3, '10/27'),
    (4, '4567890145678901', 4, '09/28'),
    (5, '5678901256789012', 5, '08/29');

-- Populate Payments Table
INSERT INTO public."Payments" (payment_id, card_id, amount, cust_id)
VALUES
    (1, '1234', 75, 1),
    (2, '2345', 150, 2),
    (3, '3456', 200, 3),
    (4, '4567', 85, 4),
    (5, '5678', 100, 5);

-- Populate Pricing Table
INSERT INTO public."Pricing" (id, menu_item_id, price)
VALUES
    (1, 1, 10),
    (2, 2, 12),
    (3, 3, 15),
    (4, 4, 20),
    (5, 5, 18);

-- Populate Special_Menu_Items Table
INSERT INTO public."Special_Menu_Items" (id, entree, side_1, side_2)
VALUES
    (1, 'Steak', 'Mashed Potatoes', 'Green Beans'),
    (2, 'Salmon', 'Rice', 'Broccoli'),
    (3, 'Pasta', 'Garlic Bread', 'Caesar Salad'),
    (4, 'Chicken Parmesan', 'Spaghetti', 'Salad'),
    (5, 'Burger', 'Fries', 'Onion Rings');

-- Populate Transactions Table
INSERT INTO public."Transactions" (transaction_id, "Payment_id", "Cash", "Amount", "Order_id", cust_id)
VALUES
    (1, 1, true, 75, 1, 1),
    (2, 2, false, 150, 2, 2),
    (3, 3, true, 200, 3, 3),
    (4, 4, false, 85, 4, 4),
    (5, 5, true, 100, 5, 5);

-- Populate menu_item Table
INSERT INTO public.menu_item (menu_item_id, item_name, type_of_menu_item, price)
VALUES
    (1, 'Cheeseburger', 'Main Course', ARRAY[8, 10, 12]),
    (2, 'Veggie Pizza', 'Main Course', ARRAY[10, 12, 14]),
    (3, 'Chicken Tenders', 'Appetizer', ARRAY[6, 8, 10]),
    (4, 'Caesar Salad', 'Side', ARRAY[5, 7]),
    (5, 'French Fries', 'Side', ARRAY[3, 5]),
    (6, 'Chocolate Cake', 'Dessert', ARRAY[4, 6, 8]);
