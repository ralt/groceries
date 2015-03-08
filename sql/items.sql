-- Gets all the items

CREATE OR REPLACE FUNCTION items(p_list_id INTEGER) RETURNS SETOF VARCHAR(255) AS $$
        SELECT i.name
        FROM item i
        LEFT JOIN list_items l
        ON l.item_id = i.id
        -- the items already in the list are not interesting...
        WHERE l.list_id != p_list_id
        -- deleted items shouldn't be counted
        AND l.status != 3;
$$
LANGUAGE SQL;
