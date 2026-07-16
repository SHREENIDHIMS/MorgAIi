-- Runs once, on first container start, via docker-entrypoint-initdb.d.
-- Add one file like this per project — each project gets its own
-- database inside the ONE shared Postgres instance, not its own
-- Postgres process.

CREATE DATABASE mortgage_assistant;

\connect mortgage_assistant

CREATE EXTENSION IF NOT EXISTS vector;   -- pgvector, replaces Qdrant

CREATE ROLE mortgage_app WITH LOGIN PASSWORD 'change_me_in_env';
GRANT ALL PRIVILEGES ON DATABASE mortgage_assistant TO mortgage_app;

-- Example schema shape — actual tables live in the app's Alembic migrations.
-- CREATE TABLE document_chunks (
--     id            BIGSERIAL PRIMARY KEY,
--     document_id   BIGINT NOT NULL,
--     content       TEXT NOT NULL,
--     embedding     vector(384),         -- bge-small-en-v1.5 dim
--     is_active     BOOLEAN DEFAULT true,
--     is_approved   BOOLEAN DEFAULT false,
--     department    TEXT,
--     doc_type      TEXT,
--     created_at    TIMESTAMPTZ DEFAULT now()
-- );
-- CREATE INDEX ON document_chunks USING hnsw (embedding vector_cosine_ops);
