-- Deploy init_users

BEGIN;

CREATE TABLE "users" (
  id       INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  username TEXT    NOT NULL UNIQUE
);

-- XXX Add DDLs here.

COMMIT;
