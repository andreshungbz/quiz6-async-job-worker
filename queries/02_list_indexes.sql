SELECT
    indexname,
    indexdef
FROM pg_indexes
WHERE tablename = 'jobs'
ORDER BY indexname;
