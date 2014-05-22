-- Verify init_challenge_entries

BEGIN;

SELECT id, challenge_id, user_id, language_id, code, compiles, compiler_error, passes FROM challenge_entries WHERE 1=0;

ROLLBACK;
