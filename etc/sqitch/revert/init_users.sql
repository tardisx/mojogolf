-- Revert init_users

BEGIN;

DROP TABLE "users";

COMMIT;
