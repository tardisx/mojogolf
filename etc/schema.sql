DROP TABLE challenge_entries;
DROP TABLE challenge_data;
DROP TABLE languages;
DROP TABLE challenges;
DROP TABLE users;

CREATE TABLE "users" (
  id       INTEGER PRIMARY KEY AUTOINCREMENT,
  username NOT NULL UNIQUE
);

CREATE TABLE "challenges" (
  id       INTEGER PRIMARY KEY AUTOINCREMENT,
  name     TEXT NOT NULL,
  descr    TEXT NOT NULL
);

CREATE TABLE "languages" (
  id       INTEGER PRIMARY KEY AUTOINCREMENT,
  name     TEXT NOT NULL,
  compile  TEXT,
  run      TEXT
);

CREATE TABLE "challenge_data" (
  id       INTEGER PRIMARY KEY AUTOINCREMENT,
  challenge_id    INTEGER NOT NULL REFERENCES challenges(id),
  input    TEXT NOT NULL,
  output   TEXT NOT NULL
);

CREATE TABLE "challenge_entries" (
  id       INTEGER PRIMARY KEY AUTOINCREMENT,
  challenge_id    INTEGER NOT NULL REFERENCES challenges(id),
  user_id     INTEGER NOT NULL REFERENCES users(id),
  language_id INTEGER NOT NULL REFERENCES languages(id),
  code     TEXT NOT NULL
);
