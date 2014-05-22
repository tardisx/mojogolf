-- Deploy init_challenge_entries
-- requires: init_challenges
-- requires: init_languages
-- requires: init_users

BEGIN;

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

COMMIT;
