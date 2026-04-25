-- B-Tree
-- Handles equality and range queries that can be sorted into some ordering
-- https://www.postgresql.org/docs/current/indexes-types.html

-- EXPLAIN shows the query plan
-- ANALYZE runs the query and measures real execution time as well as estimated/actual rows

EXPLAIN ANALYZE
SELECT public_id, status, progress, result, error_msg
FROM jobs
WHERE status = 'pending'
ORDER BY created_at
LIMIT 1;

EXPLAIN ANALYZE
SELECT public_id, status, progress, result, error_msg
FROM jobs
WHERE public_id = (SELECT public_id FROM jobs LIMIT 1);
