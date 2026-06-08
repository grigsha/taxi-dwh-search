CREATE TABLE IF NOT EXISTS {{schema}}.{{table_name}} (
    message_id TEXT NOT NULL,
    group_id TEXT NOT NULL,
    author_id TEXT,
    source_code TEXT NOT NULL,
    source_group_id TEXT,
    source_message_id TEXT,
    reply_to_message_id TEXT,
    message_ts TIMESTAMP,
    message_text TEXT,
    dt DATE NOT NULL,
    search_vector TSVECTOR GENERATED ALWAYS AS (to_tsvector('russian'::regconfig, coalesce(message_text, ''))) STORED,
    CONSTRAINT pk_{{table_name}} PRIMARY KEY (message_id, dt)
);

CREATE INDEX IF NOT EXISTS idx_{{table_name}}_dt
    ON {{schema}}.{{table_name}} (dt);

CREATE INDEX IF NOT EXISTS idx_{{table_name}}_message_ts
    ON {{schema}}.{{table_name}} (message_ts);

CREATE INDEX IF NOT EXISTS idx_{{table_name}}_source_code
    ON {{schema}}.{{table_name}} (source_code);

CREATE INDEX IF NOT EXISTS idx_{{table_name}}_group_id
    ON {{schema}}.{{table_name}} (group_id);

CREATE INDEX IF NOT EXISTS idx_{{table_name}}_author_id
    ON {{schema}}.{{table_name}} (author_id);

CREATE INDEX IF NOT EXISTS idx_{{table_name}}_search_vector
    ON {{schema}}.{{table_name}} USING GIN (search_vector);