INSERT INTO jobs (status, progress, payload, result, error_msg)
SELECT
    -- job status
    s.status,

    -- set progress value based on status
    CASE s.status
        WHEN 'pending'    THEN 0
        WHEN 'processing' THEN (random() * 99)::INTEGER
        WHEN 'done'       THEN 100
        WHEN 'failed'     THEN (random() * 99)::INTEGER
    END AS progress,

    -- simulated input payload
    jsonb_build_object(
        'original_filename', 'file_' || i || '.jpg', -- use index for image name
        'stored_path', 'uploads/' || md5(i::text) || '.jpg', -- hash the index as text
        'mime_type',
        CASE
            -- about 80% will be JPEG, and about 20% will be PNG
            WHEN random() > 0.2 THEN 'image/jpeg'
            ELSE 'image/png'
        END,
        'file_size', (random() * 10000000)::INTEGER -- random file size
    ) AS payload,

    -- simulated result only for completed jobs
    CASE s.status
        WHEN 'done' THEN jsonb_build_object(
            'grayscale_path', 'uploads/processed/gray_' || md5(i::text) || '.jpg',
            'blurred_path', 'uploads/processed/blur_' || md5(i::text) || '.jpg',
            'scaled_path', 'uploads/processed/scaled_' || md5(i::text) || '.jpg',
            'thumbnail_path', 'uploads/processed/thumb_' || md5(i::text) || '.jpg'
        )
        ELSE '{}'::jsonb
    END AS result,

    -- error message only for failed jobs
    CASE s.status
        WHEN 'failed' THEN
            'ImageProcessingError: stage ' || (random() * 4)::INTEGER
        ELSE NULL
    END AS error_msg

-- number of records to generate
FROM generate_series(1, 100000) AS i

-- subquery which uses i to compute status for each row
CROSS JOIN LATERAL (
    SELECT (ARRAY['pending', 'processing', 'done', 'failed'])[
        -- force 25% per status
        ((i - 1) % 4) + 1
    ] AS status
) AS s;
