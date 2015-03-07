-- Gets all the items of a list

CREATE OR REPLACE FUNCTION list_items(p_list_id INTEGER) RETURNS setof RECORD AS $$
        SELECT i.name
        FROM item i
        LEFT JOIN list_items l ON i.id = l.item_id
        WHERE l.list_id = p_list_id;
$$
LANGUAGE SQL;
