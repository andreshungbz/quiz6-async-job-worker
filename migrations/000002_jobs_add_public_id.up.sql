ALTER TABLE jobs
-- UUIDv4 is a random ID that doesn't include timestamp like in UUIDv7
ADD COLUMN public_id UUID NOT NULL UNIQUE DEFAULT uuidv4();
