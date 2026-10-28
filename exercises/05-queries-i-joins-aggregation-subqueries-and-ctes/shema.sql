CREATE DATABASE hosptal_management;

CREATE TABLE PACIENT (
    patient_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    gender CHAR(1)
);  

CREATE TABLE INSURANCE (
    insurance_id INT PRIMARY KEY,
    provider_name VARCHAR(100),
);

CREATE TABLE UNIT(
    unit_id INT PRIMARY KEY,
    unit_name VARCHAR(100)
);

CREATE TABLE STAFF (
    staff_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    role VARCHAR(50)
);


CREATE TABLE ROOMS (
    room_id INT PRIMARY KEY,
    unit_id INT,
    room_number VARCHAR(10),
    FOREIGN KEY (unit_id) REFERENCES UNIT(unit_id)
);

CREATE TABLE SHIFTS (
    shift_id INT PRIMARY KEY,
    room_id INT,
    shift_start TIME,
    shift_end TIME,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
    FOREIGN KEY (unit_id) REFERENCES unit(unit_id)
);

CREATE TABLE M.UNIT (
    unit_id INT PRIMARY KEY,
    unit_name VARCHAR(100)
    FOREIGN KEY (unit_id) REFERENCES UNIT(unit_id)
);

CREATE TABLE PATIEN_CASE (
    case_id INT PRIMARY KEY,
    patient_id INT,
    diagnosis VARCHAR(100),
    date_of_diagnosis DATE,
    FOREIGN KEY (patient_id) REFERENCES PACIENT(patient_id)
);

CREATE TABLE EPISODE (
    episode_id INT PRIMARY KEY,
    case_id INT,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (case_id) REFERENCES patient_case(case_id),
    FOREIGN KEY (m_nunit_id) REFERENCES m_nunit(m_nunit_id)
);

CREATE TABLE FINANCE (
    finance_id INT PRIMARY KEY,
    episode_id INT,
    amount DECIMAL(10, 2),
    payment_date DATE,
    FOREIGN KEY (case_id) REFERENCES patient_case(case_id),
);

CREATE TABLE in_fn (
    in_fn_id INT PRIMARY KEY,
    insurance_id INT NOT NULL,
    finance_id INT NOT NULL,
    policy_number VARCHAR(50),
    FOREIGN KEY (insurance_id) REFERENCES insurance(insurance_id),
    FOREIGN KEY (finance_id) REFERENCES finance(finance_id)
);

CREATE TABLE REPORTS (
    report_id INT PRIMARY KEY,
    case_id INT,
    report_date DATE,
    report_content TEXT,
    FOREIGN KEY (case_id) REFERENCES CASE(case_id)
);







