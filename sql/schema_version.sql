-- Gets the schema version

CREATE OR REPLACE FUNCTION schema_version() RETURNS INT AS $$
DECLARE
        ret INTEGER;
BEGIN
        SELECT version INTO ret FROM db_version;
        RETURN ret;
END; $$
LANGUAGE PLPGSQL;
