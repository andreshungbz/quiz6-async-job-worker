ALTER TABLE jobs
-- result is another JSONB column for storing results of operations in the set {grayscale, blur, scale, thumbnail}
-- Initializing to '{}' is necessary so that appending new entries is possible
ADD COLUMN result JSONB NOT NULL DEFAULT '{}',
ADD COLUMN error_msg TEXT;
