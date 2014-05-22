-- Deploy init_languages

BEGIN;

CREATE TABLE "languages" (
  id              INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  name            TEXT    NOT NULL UNIQUE,
  compile         TEXT,
  source_filename TEXT,  -- blank for random filename
  run             TEXT,
  boilerplate     TEXT
);

COMMIT;
