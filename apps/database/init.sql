CREATE TABLE IF NOT EXISTS log_events (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    level VARCHAR(20) NOT NULL,
    message TEXT NOT NULL,
    source VARCHAR(100) DEFAULT 'backend'
);

INSERT INTO log_events (level, message, source)
VALUES
    ('INFO', 'Application started successfully', 'backend'),
    ('WARN', 'Database connection check in progress', 'backend'),
    ('ERROR', 'Sample error log for demo purposes', 'backend'),
    ('INFO', 'Monitoring service connected', 'prometheus')
ON CONFLICT DO NOTHING;