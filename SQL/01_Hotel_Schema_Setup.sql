-- ============================================================
-- Hotel Management System - Schema Setup & Sample Data
-- ============================================================

CREATE TABLE users (
    user_id       VARCHAR(50) PRIMARY KEY,
    name          VARCHAR(100),
    phone_number  VARCHAR(20),
    mail_id       VARCHAR(100),
    billing_address TEXT
);

CREATE TABLE bookings (
    booking_id   VARCHAR(50) PRIMARY KEY,
    booking_date DATETIME,
    room_no      VARCHAR(50),
    user_id      VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE items (
    item_id   VARCHAR(50) PRIMARY KEY,
    item_name VARCHAR(100),
    item_rate DECIMAL(10,2)
);

CREATE TABLE booking_commercials (
    id            VARCHAR(50) PRIMARY KEY,
    booking_id    VARCHAR(50),
    bill_id       VARCHAR(50),
    bill_date     DATETIME,
    item_id       VARCHAR(50),
    item_quantity DECIMAL(10,2),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (item_id)    REFERENCES items(item_id)
);

-- ============================================================
-- Sample Data
-- ============================================================

INSERT INTO users VALUES
('usr-001', 'John Doe',   '9700000001', 'john.doe@example.com',   '10, Street A, Mumbai'),
('usr-002', 'Jane Smith', '9700000002', 'jane.smith@example.com', '20, Street B, Delhi'),
('usr-003', 'Raj Kumar',  '9700000003', 'raj.kumar@example.com',  '30, Street C, Pune');

INSERT INTO items VALUES
('itm-a9e8-q8fu',  'Tawa Paratha', 18.00),
('itm-a07vh-aer8', 'Mix Veg',      89.00),
('itm-w978-23u4',  'Butter Naan',  35.00),
('itm-b123-xy45',  'Paneer Curry', 150.00),
('itm-c456-zw89',  'Cold Coffee',  60.00);

INSERT INTO bookings VALUES
('bk-001', '2021-09-15 10:00:00', 'rm-101', 'usr-001'),
('bk-002', '2021-10-05 11:00:00', 'rm-102', 'usr-001'),
('bk-003', '2021-11-10 09:30:00', 'rm-103', 'usr-002'),
('bk-004', '2021-11-20 14:00:00', 'rm-104', 'usr-003'),
('bk-005', '2021-10-25 16:00:00', 'rm-105', 'usr-002'),
('bk-006', '2021-12-01 08:00:00', 'rm-101', 'usr-003');

INSERT INTO booking_commercials VALUES
-- bk-001 -> bill bl-001 (Sep 2021)
('bc-001', 'bk-001', 'bl-001', '2021-09-15 12:00:00', 'itm-a9e8-q8fu',  3),
('bc-002', 'bk-001', 'bl-001', '2021-09-15 12:00:00', 'itm-a07vh-aer8', 2),

-- bk-002 -> bill bl-002 (Oct 2021)
('bc-003', 'bk-002', 'bl-002', '2021-10-06 13:00:00', 'itm-b123-xy45',  5),
('bc-004', 'bk-002', 'bl-002', '2021-10-06 13:00:00', 'itm-c456-zw89',  3),

-- bk-003 -> bill bl-003 (Nov 2021)
('bc-005', 'bk-003', 'bl-003', '2021-11-11 09:00:00', 'itm-a07vh-aer8', 4),
('bc-006', 'bk-003', 'bl-003', '2021-11-11 09:00:00', 'itm-w978-23u4',  6),

-- bk-004 -> bill bl-004 (Nov 2021)
('bc-007', 'bk-004', 'bl-004', '2021-11-21 10:00:00', 'itm-b123-xy45',  2),
('bc-008', 'bk-004', 'bl-004', '2021-11-21 10:00:00', 'itm-c456-zw89',  4),

-- bk-005 -> bill bl-005 (Oct 2021)
('bc-009', 'bk-005', 'bl-005', '2021-10-26 11:00:00', 'itm-a9e8-q8fu',  10),
('bc-010', 'bk-005', 'bl-005', '2021-10-26 11:00:00', 'itm-w978-23u4',  8),

-- bk-006 -> bill bl-006 (Dec 2021)
('bc-011', 'bk-006', 'bl-006', '2021-12-02 12:00:00', 'itm-b123-xy45',  3),
('bc-012', 'bk-006', 'bl-006', '2021-12-02 12:00:00', 'itm-c456-zw89',  2);
