.open fittrackpro.db
.mode column

PRAGMA foreign_keys = OFF;

DROP TABLE IF EXISTS locations;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS class_schedule;
DROP TABLE IF EXISTS memberships;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS class_attendance;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS personal_training_sessions;
DROP TABLE IF EXISTS member_health_metrics;
DROP TABLE IF EXISTS equipment_maintenance_log;

PRAGMA foreign_keys = ON;

CREATE TABLE locations (
    location_id     INTEGER PRIMARY KEY,
    name            VARCHAR NOT NULL,
    address         VARCHAR NOT NULL,
    phone_number    CHAR(13) NOT NULL CHECK (length(phone_number) IN (12, 13)),
    email           VARCHAR NOT NULL CHECK (email LIKE '%@%'),
    opening_hours   CHAR(11) NOT NULL CHECK (opening_hours LIKE '__:__-__:__')
);

CREATE TABLE members (
    member_id       INTEGER PRIMARY KEY,
    first_name      TEXT NOT NULL,
    last_name       TEXT,
    email           VARCHAR NOT NULL CHECK (email LIKE '%@%'),
    phone_number    CHAR(13) NOT NULL CHECK (length(phone_number) IN (12, 13)),
    date_of_birth   DATE NOT NULL,
    join_date       DATE NOT NULL,
    emergency_contact_name  VARCHAR NOT NULL,
    emergency_contact_phone CHAR(13) NOT NULL CHECK (length(emergency_contact_phone) IN (12, 13))
);

CREATE TABLE staff (
    staff_id        INTEGER PRIMARY KEY,
    first_name      TEXT NOT NULL,
    last_name       TEXT,
    email           VARCHAR NOT NULL
        CHECK (email LIKE '%@%'),
    phone_number    CHAR(13) NOT NULL CHECK (length(phone_number) IN (12, 13)),
    position        TEXT NOT NULL
        CHECK (position IN ('Trainer','Manager','Receptionist','Maintenance')),
    hire_date       DATE NOT NULL,
    location_id     INTEGER NOT NULL,
    FOREIGN KEY (location_id)
        REFERENCES locations(location_id)
        ON DELETE CASCADE
);

CREATE TABLE equipment (
    equipment_id            INTEGER PRIMARY KEY,
    name                    VARCHAR NOT NULL,
    type                    VARCHAR NOT NULL
        CHECK (type IN ('Strength','Cardio')),
    purchase_date           DATE NOT NULL,
    last_maintenance_date   DATE NOT NULL,
    next_maintenance_date   DATE NOT NULL
        CHECK (next_maintenance_date > last_maintenance_date),
    location_id             INTEGER NOT NULL,
    FOREIGN KEY (location_id)
        REFERENCES locations(location_id)
        ON DELETE CASCADE
);

CREATE TABLE classes (
    class_id        INTEGER PRIMARY KEY,
    name            VARCHAR NOT NULL,
    description     VARCHAR,
    capacity        INTEGER NOT NULL
        CHECK (capacity > 0),
    duration        INTEGER NOT NULL
        CHECK (duration > 0),
    location_id     INTEGER NOT NULL,
    FOREIGN KEY (location_id)
        REFERENCES locations(location_id)
        ON DELETE CASCADE
);

CREATE TABLE class_schedule (
    schedule_id     INTEGER PRIMARY KEY,
    class_id        INTEGER NOT NULL,
    staff_id        INTEGER NOT NULL,
    start_time      DATETIME NOT NULL,
    end_time        DATETIME NOT NULL
        CHECK (end_time > start_time),
    FOREIGN KEY (class_id)
        REFERENCES classes(class_id)
        ON DELETE CASCADE,
    FOREIGN KEY (staff_id)
        REFERENCES staff(staff_id)
        ON DELETE CASCADE
);

CREATE TABLE memberships (
    membership_id   INTEGER PRIMARY KEY,
    member_id       INTEGER NOT NULL,
    type            TEXT,
    start_date      DATE NOT NULL,
    end_date        DATE NOT NULL,
    status          VARCHAR NOT NULL
        CHECK (status IN ('Active','Inactive')),
    FOREIGN KEY (member_id)
        REFERENCES members(member_id)
        ON DELETE CASCADE
);

CREATE TABLE attendance (
    attendance_id   INTEGER PRIMARY KEY,
    member_id       INTEGER NOT NULL,
    location_id     INTEGER NOT NULL,
    check_in_time   DATETIME NOT NULL,
    check_out_time  DATETIME NOT NULL,
    FOREIGN KEY (member_id)
        REFERENCES members(member_id)
        ON DELETE CASCADE,
    FOREIGN KEY (location_id)
        REFERENCES locations(location_id)
        ON DELETE CASCADE
);

CREATE TABLE class_attendance (
    class_attendance_id INTEGER PRIMARY KEY,
    schedule_id         INTEGER NOT NULL,
    member_id           INTEGER NOT NULL,
    attendance_status   VARCHAR NOT NULL
        CHECK (attendance_status IN ('Registered','Attended','Unattended')),
    FOREIGN KEY (schedule_id)
        REFERENCES class_schedule(schedule_id)
        ON DELETE CASCADE,
    FOREIGN KEY (member_id)
        REFERENCES members(member_id)
        ON DELETE CASCADE
);

CREATE TABLE payments (
    payment_id      INTEGER PRIMARY KEY,
    member_id       INTEGER NOT NULL,
    amount          REAL NOT NULL
        CHECK (amount > 0),
    payment_date    DATETIME NOT NULL,
    payment_method  VARCHAR NOT NULL
        CHECK (payment_method IN ('Credit Card','Bank Transfer','PayPal','Cash')),
    payment_type    VARCHAR NOT NULL
        CHECK (payment_type IN ('Monthly membership fee','Day pass')),
    FOREIGN KEY (member_id)
        REFERENCES members(member_id)
        ON DELETE CASCADE
);

CREATE TABLE personal_training_sessions (
    session_id      INTEGER PRIMARY KEY,
    member_id       INTEGER NOT NULL,
    staff_id        INTEGER NOT NULL,
    session_date    DATE NOT NULL,
    start_time      TIME NOT NULL,
    end_time        TIME NOT NULL
        CHECK (end_time > start_time),
    notes           VARCHAR,
    FOREIGN KEY (member_id)
        REFERENCES members(member_id)
        ON DELETE CASCADE,
    FOREIGN KEY (staff_id)
        REFERENCES staff(staff_id)
        ON DELETE CASCADE
);

CREATE TABLE member_health_metrics (
    metric_id               INTEGER PRIMARY KEY,
    member_id               INTEGER NOT NULL,
    measurement_date        DATE NOT NULL,
    weight                  REAL NOT NULL,
    body_fat_percentage     REAL NOT NULL,
    muscle_mass             REAL NOT NULL,
    bmi                     REAL NOT NULL,
    FOREIGN KEY (member_id)
        REFERENCES members(member_id)
        ON DELETE CASCADE
);

CREATE TABLE equipment_maintenance_log (
    log_id              INTEGER PRIMARY KEY,
    equipment_id        INTEGER NOT NULL,
    maintenance_date    DATE NOT NULL,
    description         VARCHAR,
    staff_id            INTEGER NOT NULL,
    FOREIGN KEY (equipment_id)
        REFERENCES equipment(equipment_id)
        ON DELETE CASCADE,
    FOREIGN KEY (staff_id)
        REFERENCES staff(staff_id)
        ON DELETE CASCADE
);
