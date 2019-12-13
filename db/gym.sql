DROP TABLE IF EXISTS class_tracker;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS memberships;
DROP TABLE IF EXISTS course_classes;
DROP TABLE IF EXISTS venues;

CREATE TABLE venues (
  id SERIAL primary key,
  name VARCHAR(255) NOT NULL,
  address VARCHAR(255),
  max_number_classes INT
);

CREATE TABLE course_classes (
  id SERIAL primary key,
  name VARCHAR(255) NOT NULL,
  max_capacity INT,
  venue_id INT NOT NULL REFERENCES venues(id) ON DELETE CASCADE
);

CREATE TABLE memberships (
  id SERIAL primary key,
  name VARCHAR(255) NOT NULL,
  price INT
);

CREATE TABLE members (
  id SERIAL primary key,
  name VARCHAR(255) NOT NULL,
  status VARCHAR(255) NOT NULL,
  membership_id INT NOT NULL REFERENCES memberships(id)
);

CREATE TABLE class_tracker (
  id SERIAL primary key,
  course_class_id INT NOT NULL REFERENCES course_classes(id) ON DELETE CASCADE,
  member_id INT NOT NULL REFERENCES members(id) ON DELETE CASCADE
);
