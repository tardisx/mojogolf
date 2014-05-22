-- Verify init_users

BEGIN;

SELECT id, username FROM users WHERE 1=0;

ROLLBACK;
