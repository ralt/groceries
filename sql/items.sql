-- Gets all the items

CREATE OR REPLACE FUNCTION items() RETURNS SETOF VARCHAR(255) AS $$
       SELECT name FROM item
$$
LANGUAGE SQL;
