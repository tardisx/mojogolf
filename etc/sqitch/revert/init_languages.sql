-- Revert init_languages

BEGIN;

DROP TABLE languages;

COMMIT;
