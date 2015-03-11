-- Gets all the items

CREATE OR REPLACE FUNCTION items(p_list_id INTEGER) RETURNS SETOF VARCHAR(255) AS $$
        SELECT name
        FROM item
$$
LANGUAGE SQL;
