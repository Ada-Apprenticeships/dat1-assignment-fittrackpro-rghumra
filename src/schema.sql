.open fittrackpro.db
.mode column

CREATE TABLE locations (
    location_id VARCHAR(10) PRIMARY KEY NOT NULL,
    name VARCHAR(25),
    address VARCHAR (40),
    phone_number CHAR(12) DEFAULT '00000 000000' NOT NULL,
    email VARCHAR (40) NOT NULL, 
        CHECK(email LIKE '%@%')
    opening_hours CHAR(11) NOT NULL
        CHECK(opening_hours LIKE '__:__-__:__')
);

CREATE TABLE members (
    member_id VARCHAR(10) PRIMARY KEY NOT NULL,
    first_name VARCHAR(25),
    last_name VARCHAR(25),
    email VARCHAR (40) NOT NULL, 
        CHECK(email LIKE '%@%')
    phone_number CHAR(12) DEFAULT '00000 000000' NOT NULL,
    date_of_birth DATE() NOT NULL,
    join_date DATE() NOT NULL,
    emergency_contact_name VARCHAR(40) NOT NULL,
    emergency_contact_phone CHAR(12) DEFAULT '00000 000000' NOT NULL
);

CREATE TABLE staff (
    staff_id VARCHAR(10) PRIMARY KEY NOT NULL,
    first_name VARCHAR(25),
    last_name VARCHAR(25),
    email VARCHAR (40) NOT NULL, 
        CHECK(email LIKE '%@%')
    phone_number CHAR(12) DEFAULT '00000 000000' NOT NULL,
    position VARCHAR(20) NOT NULL,
        CHECK(position IN('Trainer','Manager','Receptionist','Maintenance'))
    hire_date DATE()
    FOREIGN KEY location_id REFERENCES locations(location_id) ON DELETE CASCADE

);

CREATE TABLE equipment(
    equipment_id VARCHAR(10),
    name VARCHAR(20),
    type VARCHAR(20) NOT NULL,
        CHECK(type IN('Strength','Cardio'))
    purchase_date DATE(),
    last_maintenance_date DATE(),
    next_maintenance_date DATE(),
    FOREIGN KEY location_id REFERENCES locations(location_id) ON DELETE CASCADE
);

CREATE TABLE classes(
    class_id VARCHAR(10) PRIMARY KEY NOT NULL,
    name VARCHAR (25),
    description VARCHAR(100),
    capacity VARCHAR(2) NOT NULL,
    duration VARCHAR(2) NOT NULL,
    FOREIGN KEY location_id REFERENCES locations(location_id) ON DELETE CASCADE
);

CREATE TABLE class_schedule(
    schedule_id VARCHAR(10),
    FOREIGN KEY class_id REFERENCES classes(class_id) ON DELETE CASCADE
    FOREIGN KEY staff_id REFERENCES staff(staff_id) ON DELETE CASCADE
    start_time DATETIME(),
    end_time DATETIME()
);

CREATE TABLE memberships(
    membership_id VARCHAR(10),
    FOREIGN KEY member_id REFERENCES members(member_id) ON DELETE CASCADE,
    type VARCHAR(15),
    start_date DATE(),
    end_date DATE(),
    status VARCHAR(10)
        CHECK (status IN('Active','Inactive'))
);

