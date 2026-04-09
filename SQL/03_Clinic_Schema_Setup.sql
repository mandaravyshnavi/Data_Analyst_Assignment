-- ============================================================
-- Clinic Management System - Schema Setup & Sample Data
-- ============================================================

CREATE TABLE clinics (
    cid         VARCHAR(50) PRIMARY KEY,
    clinic_name VARCHAR(100),
    city        VARCHAR(100),
    state       VARCHAR(100),
    country     VARCHAR(100)
);

CREATE TABLE customer (
    uid    VARCHAR(50) PRIMARY KEY,
    name   VARCHAR(100),
    mobile VARCHAR(20)
);

CREATE TABLE clinic_sales (
    oid          VARCHAR(50) PRIMARY KEY,
    uid          VARCHAR(50),
    cid          VARCHAR(50),
    amount       DECIMAL(10,2),
    datetime     DATETIME,
    sales_channel VARCHAR(50),
    FOREIGN KEY (uid) REFERENCES customer(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

CREATE TABLE expenses (
    eid         VARCHAR(50) PRIMARY KEY,
    cid         VARCHAR(50),
    description VARCHAR(200),
    amount      DECIMAL(10,2),
    datetime    DATETIME,
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

-- ============================================================
-- Sample Data
-- ============================================================

INSERT INTO clinics VALUES
('cnc-001', 'HealthFirst Clinic', 'Mumbai',    'Maharashtra', 'India'),
('cnc-002', 'CureAll Clinic',     'Pune',      'Maharashtra', 'India'),
('cnc-003', 'WellnessHub',        'Bangalore', 'Karnataka',   'India'),
('cnc-004', 'MedCare Centre',     'Mysore',    'Karnataka',   'India'),
('cnc-005', 'QuickHeal',          'Chennai',   'Tamil Nadu',  'India');

INSERT INTO customer VALUES
('cst-001', 'Arjun Sharma',  '9800000001'),
('cst-002', 'Priya Mehta',   '9800000002'),
('cst-003', 'Kiran Rao',     '9800000003'),
('cst-004', 'Sunita Verma',  '9800000004'),
('cst-005', 'Manoj Nair',    '9800000005');

INSERT INTO clinic_sales VALUES
('ord-001', 'cst-001', 'cnc-001', 24999, '2021-09-05 10:00:00', 'online'),
('ord-002', 'cst-002', 'cnc-001', 15000, '2021-09-12 11:00:00', 'offline'),
('ord-003', 'cst-003', 'cnc-002', 8000,  '2021-09-20 09:00:00', 'online'),
('ord-004', 'cst-001', 'cnc-002', 12000, '2021-10-03 14:00:00', 'offline'),
('ord-005', 'cst-004', 'cnc-003', 5000,  '2021-10-15 15:00:00', 'online'),
('ord-006', 'cst-005', 'cnc-003', 9500,  '2021-10-22 16:00:00', 'referral'),
('ord-007', 'cst-002', 'cnc-004', 20000, '2021-11-01 10:00:00', 'online'),
('ord-008', 'cst-003', 'cnc-004', 11000, '2021-11-14 11:00:00', 'offline'),
('ord-009', 'cst-004', 'cnc-005', 7500,  '2021-11-25 13:00:00', 'referral'),
('ord-010', 'cst-001', 'cnc-001', 30000, '2021-12-10 09:00:00', 'online'),
('ord-011', 'cst-005', 'cnc-002', 4500,  '2021-12-20 10:00:00', 'online'),
('ord-012', 'cst-002', 'cnc-003', 16000, '2021-12-28 11:00:00', 'offline');

INSERT INTO expenses VALUES
('exp-001', 'cnc-001', 'First-aid supplies',   5000, '2021-09-06 08:00:00'),
('exp-002', 'cnc-001', 'Staff salary',         20000,'2021-09-30 08:00:00'),
('exp-003', 'cnc-002', 'Equipment maintenance',3000, '2021-09-22 08:00:00'),
('exp-004', 'cnc-002', 'Utilities',            2000, '2021-10-05 08:00:00'),
('exp-005', 'cnc-003', 'Medicine restocking',  4000, '2021-10-18 08:00:00'),
('exp-006', 'cnc-003', 'Cleaning services',    1000, '2021-10-24 08:00:00'),
('exp-007', 'cnc-004', 'Rent',                 8000, '2021-11-03 08:00:00'),
('exp-008', 'cnc-004', 'Insurance',            2500, '2021-11-15 08:00:00'),
('exp-009', 'cnc-005', 'Staff salary',         6000, '2021-11-26 08:00:00'),
('exp-010', 'cnc-001', 'Utilities',            3500, '2021-12-12 08:00:00'),
('exp-011', 'cnc-002', 'Marketing',            1500, '2021-12-22 08:00:00'),
('exp-012', 'cnc-003', 'Staff salary',         9000, '2021-12-29 08:00:00');
