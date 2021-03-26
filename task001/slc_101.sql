CREATE TABLE student (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    surname VARCHAR(255) NOT NULL,
    n_group INTEGER NOT NULL,
    score NUMERIC(3, 2),
    address VARCHAR(3000),
    date_birth DATE
)
-- "fill table"
-- INSERT INTO student(
-- 	id, name, surname, n_group, score, address, date_birth)
-- 	VALUES (?, ?, ?, ?, ?, ?, ?)

CREATE TABLE hobby (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    risk NUMERIC(3, 2) NOT NULL
)

-- "fill table"
-- INSERT INTO hobby(
-- 	id, name, risk)
-- 	VALUES (?, ?, ?)

CREATE TABLE student_hobby (
    student_id INTEGER,
    hobby_id INTEGER,
    id SERIAL PRIMARY KEY,
    FOREIGN KEY (student_id) REFERENCES student (id),
    FOREIGN KEY (hobby_id) REFERENCES hobby (id),
    date_start DATE DEFAULT CURRENT_DATE
    date_finish DATE
)

-- "fill table"
-- INSERT INTO student_hobby(
-- 	id, student_id, hobby_id, date_start, date_finish)
	-- VALUES (?, ?, ?, ?, ?)
