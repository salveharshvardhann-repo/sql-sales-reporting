-- schema.sql
-- Standard sales pipeline schema + sample data (SQLite-compatible).

CREATE TABLE IF NOT EXISTS deals (
    deal_id     INTEGER PRIMARY KEY,
    company     TEXT    NOT NULL,
    stage       TEXT    NOT NULL CHECK (stage IN
                ('Lead','Qualified','Proposal','Negotiation','Won','Lost')),
    value       REAL    NOT NULL,
    owner       TEXT    NOT NULL,
    created_at  TEXT    NOT NULL,   -- ISO date: YYYY-MM-DD
    closed_at   TEXT                -- NULL while the deal is open
);

-- 20 representative deals across stages and owners.
INSERT INTO deals (deal_id, company, stage, value, owner, created_at, closed_at) VALUES
(1,  'Acme Corp',        'Won',         45000, 'A. Sharma',  '2026-01-10', '2026-02-14'),
(2,  'Bright Retail',    'Negotiation', 120000,'A. Sharma',  '2026-02-01', NULL),
(3,  'Nova Traders',     'Proposal',    78000, 'P. Patel',   '2026-03-05', NULL),
(4,  'Orbit Textiles',   'Qualified',   56000, 'R. Verma',   '2026-03-12', NULL),
(5,  'Peak Electronics', 'Won',         96000, 'P. Patel',   '2026-01-22', '2026-03-02'),
(6,  'Quartz Foods',     'Lost',        41000, 'R. Verma',   '2026-02-08', '2026-03-20'),
(7,  'Sunrise Pharma',   'Proposal',    134000,'A. Sharma',  '2026-04-01', NULL),
(8,  'Vertex Auto',      'Lead',        62000, 'P. Patel',   '2026-04-15', NULL),
(9,  'Westline Steel',   'Won',         73000, 'R. Verma',   '2026-02-11', '2026-04-05'),
(10, 'Yonder Logistics', 'Qualified',   88000, 'A. Sharma',  '2026-04-20', NULL),
(11, 'Zenith Ceramics',  'Won',         51000, 'P. Patel',   '2026-03-01', '2026-04-22'),
(12, 'Bluepeak Foods',   'Negotiation', 67000, 'R. Verma',   '2026-05-02', NULL),
(13, 'Crestline Pharma', 'Lead',        92000, 'A. Sharma',  '2026-05-10', NULL),
(14, 'Deltawave Tech',   'Proposal',    105000,'P. Patel',   '2026-05-18', NULL),
(15, 'Eastmark Retail',  'Won',         48000, 'R. Verma',   '2026-04-08', '2026-06-01'),
(16, 'Fairhaven Traders','Lost',        39000, 'A. Sharma',  '2026-05-25', '2026-07-10'),
(17, 'Goldcrest Foods',  'Qualified',   71000, 'P. Patel',   '2026-06-12', NULL),
(18, 'Harborline Textiles','Negotiation',118000,'R. Verma',  '2026-06-20', NULL),
(19, 'Ironwood Auto',    'Won',         84000, 'A. Sharma',  '2026-05-05', '2026-07-28'),
(20, 'Jadestone Steel',  'Lead',        55000, 'P. Patel',   '2026-07-01', NULL);
