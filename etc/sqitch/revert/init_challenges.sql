-- Revert init_challenges

BEGIN;

DROP TABLE challenges;

COMMIT;
