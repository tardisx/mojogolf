-- Revert init_users

BEGIN;

DROP TABLE "users";

-- XXX Add DDLs here.

COMMIT;
