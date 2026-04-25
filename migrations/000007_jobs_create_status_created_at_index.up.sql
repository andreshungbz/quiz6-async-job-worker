-- composite index
CREATE INDEX idx_jobs_status_created ON jobs (status, created_at);
