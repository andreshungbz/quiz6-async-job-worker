-- Generalized Inverted Index (GIN)
-- Appropriate for data values that contain multiple component values (arrays, JSONB, full-text search)
-- https://www.postgresql.org/docs/current/indexes-types.html

-- EXPLAIN shows the query plan
-- ANALYZE runs the query and measures real execution time as well as estimated/actual rows

EXPLAIN ANALYZE
SELECT id, payload->>'original_filename' AS original_filename
FROM jobs
WHERE payload @> '{"mime_type": "image/jpeg"}'::jsonb;

EXPLAIN ANALYZE
SELECT id, payload->>'original_filename' AS original_filename
FROM jobs
WHERE payload @> '{"mime_type": "image/jpeg", "source": "mobile_upload"}'::jsonb;
