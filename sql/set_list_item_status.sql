-- Sets an list item status

CREATE OR REPLACE FUNCTION set_list_item_status(p_list_id INTEGER, p_item_id INTEGER, p_status INTEGER) RETURNS void AS $$
        UPDATE list_items
        SET status = p_status
        WHERE list_id = p_list_id
        AND item_id = p_item_id;
$$
LANGUAGE SQL;
