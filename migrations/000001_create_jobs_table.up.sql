CREATE TABLE IF NOT EXISTS jobs (
    -- UUIDs instead of serial are more modern and secure
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    -- JSONB type factors in the variation of image metadata
    payload JSONB NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
