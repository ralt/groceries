-- Gets all the items of a list

CREATE OR REPLACE FUNCTION list_items(p_list_id INTEGER) RETURNS setof RECORD AS $$
        SELECT i.name, l.status
        FROM item i
        LEFT JOIN list_items l ON i.id = l.item_id
        WHERE l.list_id = p_list_id
        -- status 1 = new, 2 = bought, 3 = deleted.
        -- Keeping deleted so that it's possible to do
        -- statistics later on.
        AND l.status != 3
        ORDER BY l.status ASC, i.name ASC;
$$
LANGUAGE SQL;
