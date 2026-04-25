ALTER TABLE jobs
-- An updated_at column is useful for the server sending notifications to the client
-- It also answers average time it takes to do an operation (e.g. thumbnails)
ADD COLUMN updated_at TIMESTAMPTZ NOT NULL DEFAULT now();
