SELECT
    public_id,
    payload->>'original_filename' AS filename,
    status,
    created_at,
    updated_at
FROM jobs
WHERE payload->>'original_filename' = 'file_1.jpg';

UPDATE jobs
SET status = 'processing'
WHERE payload->>'original_filename' = 'file_1.jpg';

SELECT
    public_id,
    payload->>'original_filename' AS filename,
    status,
    created_at,
    updated_at
FROM jobs
WHERE payload->>'original_filename' = 'file_1.jpg';
