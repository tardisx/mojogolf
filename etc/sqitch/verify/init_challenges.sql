-- Verify init_challenges

BEGIN;

SELECT id, name, short_descr, long_descr, finishes FROM challenges WHERE 1=0;

ROLLBACK;
