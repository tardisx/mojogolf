-- Revert init_challenge_entries

BEGIN;

DROP TABLE challenge_entries;

COMMIT;
