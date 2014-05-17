DROP TABLE challenge_entries;
DROP TABLE challenge_data;
DROP TABLE languages;
DROP TABLE challenges;
DROP TABLE users;

CREATE TABLE "users" (
  id       INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  username TEXT    NOT NULL UNIQUE
);

CREATE TABLE "challenges" (
  id          INTEGER   NOT NULL PRIMARY KEY AUTOINCREMENT,
  name        TEXT      NOT NULL UNIQUE,
  short_descr TEXT      NOT NULL,
  long_descr  TEXT      NOT NULL,
  finishes    TIMESTAMP NOT NULL
);

CREATE TABLE "languages" (
  id              INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  name            TEXT    NOT NULL UNIQUE,
  compile         TEXT,
  source_filename TEXT,  -- blank for random filename
  run             TEXT,
  boilerplate     TEXT
);

CREATE TABLE "challenge_data" (
  id             INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  challenge_id   INTEGER NOT NULL REFERENCES challenges(id),
  input          TEXT    NOT NULL,
  output         TEXT    NOT NULL,
  hidden         BOOLEAN NOT NULL,
  UNIQUE (challenge_id, input)
);

CREATE TABLE "challenge_entries" (
  id            INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  challenge_id  INTEGER NOT NULL REFERENCES challenges(id),
  user_id       INTEGER NOT NULL REFERENCES users(id),
  language_id   INTEGER NOT NULL REFERENCES languages(id),
  code          TEXT    NOT NULL,
  compiles       BOOLEAN,
  compiler_error TEXT,
  passes        BOOLEAN,
  UNIQUE (challenge_id, user_id, language_id)
);
