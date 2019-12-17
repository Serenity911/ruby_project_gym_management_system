DROP TABLE IF EXISTS class_trackers;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS course_classes;
DROP TABLE IF EXISTS memberships;
DROP TABLE IF EXISTS venues;

CREATE TABLE venues (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  address VARCHAR(255),
  max_number_classes INT
);

-- if time, change to membership_id in members
CREATE TABLE memberships (
  id SERIAL primary key,
  name VARCHAR(255) NOT NULL,
  price INT
);

CREATE TABLE course_classes (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  course_date DATE,
  max_capacity INT,
  membership_id INT NOT NULL REFERENCES memberships(id),
  -- membership_level VARCHAR(255) NOT NULL,
  venue_id INT NOT NULL REFERENCES venues(id) ON DELETE CASCADE
);



CREATE TABLE members (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  status VARCHAR(255) NOT NULL,
  -- membership VARCHAR(255) NOT NULL
  membership_id INT NOT NULL REFERENCES memberships(id)
);

CREATE TABLE class_trackers (
  id SERIAL primary key,
  course_class_id INT NOT NULL REFERENCES course_classes(id) ON DELETE CASCADE,
  member_id INT NOT NULL REFERENCES members(id) ON DELETE CASCADE
);
