-- Verify init_languages

BEGIN;

SELECT id, name, compile, source_filename, run, boilerplate FROM languages WHERE 1=0;

ROLLBACK;
