-- Verify init_challenge_data

BEGIN;

SELECT id, challenge_id, input, output, hidden FROM challenge_data WHERE 1=0;

ROLLBACK;
