-- Deploy init_challenge_data
-- requires: init_challenges

BEGIN;

CREATE TABLE "challenge_data" (
  id             INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  challenge_id   INTEGER NOT NULL REFERENCES challenges(id),
  input          TEXT    NOT NULL,
  output         TEXT    NOT NULL,
  hidden         BOOLEAN NOT NULL,
  UNIQUE (challenge_id, input)
);

COMMIT;
