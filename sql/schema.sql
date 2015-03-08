-- Schema of the database

CREATE TABLE db_version (
       version INTEGER NOT NULL
);

-----

INSERT INTO db_version (version) VALUES (1);

-----

CREATE TABLE users (
       id SERIAL PRIMARY KEY,
       name VARCHAR(30) UNIQUE NOT NULL
);

-----

INSERT INTO users (name) VALUES ('admin');

-----

CREATE TABLE list (
       id SERIAL PRIMARY KEY,
       user_id INTEGER REFERENCES users(id)
);

-----

INSERT INTO list (user_id) VALUES (1);

-----

CREATE TABLE item (
       id SERIAL PRIMARY KEY,
       name VARCHAR(255) UNIQUE NOT NULL
);

-----

CREATE UNIQUE INDEX item_lower_name_index ON item(LOWER(name));

-----

CREATE TABLE list_items (
       list_id INTEGER REFERENCES list(id) NOT NULL,
       item_id INTEGER REFERENCES item(id) NOT NULL,
       status INTEGER NOT NULL
);
