-- Clears all the items in a list

CREATE OR REPLACE FUNCTION clear_list(p_list_id INTEGER) RETURNS VOID AS $$
        UPDATE list_items
        SET status = 3
        WHERE list_id = p_list_id;
$$
LANGUAGE SQL;
