-- Generalized Inverted Index (GIN) is designed for data types like JSONB
CREATE INDEX idx_jobs_payload ON jobs USING GIN (payload);
