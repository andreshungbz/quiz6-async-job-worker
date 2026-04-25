ALTER TABLE jobs
ADD COLUMN status TEXT NOT NULL DEFAULT 'pending'
    -- Add check constraint for set of valid status values
    CHECK (status IN ('pending', 'processing', 'done', 'failed')),
ADD COLUMN progress INTEGER NOT NULL DEFAULT 0
    -- Add check constraint for valid progress values
    CHECK (progress BETWEEN 0 AND 100);
