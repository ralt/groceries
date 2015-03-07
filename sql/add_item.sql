-- Adds an item

CREATE OR REPLACE FUNCTION add_item(item_name VARCHAR(255), p_list_id INTEGER) RETURNS INTEGER AS $$
DECLARE
        v_item_id INTEGER;
BEGIN
        SELECT id INTO v_item_id
        FROM item
        WHERE name = LOWER(item_name);

        IF v_item_id IS NULL THEN
                INSERT INTO item (name)
                VALUES (LOWER(item_name)) RETURNING id into v_item_id;
        END IF;

        INSERT INTO list_items (list_id, item_id, status)
        VALUES (p_list_id, v_item_id, 1);

        RETURN v_item_id;
END; $$
LANGUAGE PLPGSQL;
