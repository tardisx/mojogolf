-- Deploy init_challenges
-- requires: init_users

BEGIN;

CREATE TABLE "challenges" (
  id          INTEGER   NOT NULL PRIMARY KEY AUTOINCREMENT,
  name        TEXT      NOT NULL UNIQUE,
  short_descr TEXT      NOT NULL,
  long_descr  TEXT      NOT NULL,
  finishes    TIMESTAMP NOT NULL
);

COMMIT;
