-- Revert init_challenge_data

BEGIN;

DROP TABLE challenge_data;

COMMIT;
