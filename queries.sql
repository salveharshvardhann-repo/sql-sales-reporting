-- queries.sql
-- Standardized reporting queries for the sales pipeline.
-- Every query here is the single source of truth for its business question.
-- Run against the database created by schema.sql.

-- ─────────────────────────────────────────────────────────────
-- 1. PIPELINE_BY_STAGE
--    Business question: "What is our open pipeline worth, by stage?"
-- ─────────────────────────────────────────────────────────────
WITH pipeline_by_stage AS (
    SELECT
        stage,
        COUNT(*)            AS open_deals,
        ROUND(SUM(value))   AS pipeline_value,
        ROUND(AVG(value))   AS avg_deal_size
    FROM deals
    WHERE stage NOT IN ('Won', 'Lost')          -- open pipeline only
    GROUP BY stage
    ORDER BY
        CASE stage
            WHEN 'Lead'        THEN 1
            WHEN 'Qualified'   THEN 2
            WHEN 'Proposal'    THEN 3
            WHEN 'Negotiation' THEN 4
        END
)
SELECT * FROM pipeline_by_stage;

-- ─────────────────────────────────────────────────────────────
-- 2. MONTHLY_WON_REVENUE
--    Business question: "What revenue actually closed each month?"
-- ─────────────────────────────────────────────────────────────
WITH monthly_won_revenue AS (
    SELECT
        strftime('%Y-%m', closed_at)   AS month,
        COUNT(*)                        AS deals_won,
        ROUND(SUM(value))               AS revenue_won
    FROM deals
    WHERE stage = 'Won'
    GROUP BY month
    ORDER BY month
)
SELECT * FROM monthly_won_revenue;

-- ─────────────────────────────────────────────────────────────
-- 3. FUNNEL_CONVERSION
--    Business question: "Where do deals drop off between stages?"
--    Conversion = deals that reached the NEXT stage / deals that
--    entered THIS stage (Won counts as the next step of Negotiation).
-- ─────────────────────────────────────────────────────────────
WITH entered AS (
    SELECT stage, COUNT(*) AS n
    FROM deals
    WHERE stage != 'Won'
    GROUP BY stage
),
reached AS (
    -- deals that made it past each stage
    SELECT 'Lead'        AS stage, COUNT(*) AS n FROM deals WHERE stage NOT IN ('Lead')        AND stage != 'Lost'
    UNION ALL
    SELECT 'Qualified',   COUNT(*) FROM deals WHERE stage NOT IN ('Lead','Qualified')            AND stage != 'Lost'
    UNION ALL
    SELECT 'Proposal',    COUNT(*) FROM deals WHERE stage NOT IN ('Lead','Qualified','Proposal') AND stage != 'Lost'
    UNION ALL
    SELECT 'Negotiation', COUNT(*) FROM deals WHERE stage = 'Won'
)
SELECT
    e.stage,
    e.n                                   AS deals_entered,
    r.n                                   AS converted_to_next,
    ROUND(100.0 * r.n / e.n, 1)           AS conversion_pct
FROM entered e
JOIN reached r USING (stage)
ORDER BY
    CASE e.stage
        WHEN 'Lead'        THEN 1
        WHEN 'Qualified'   THEN 2
        WHEN 'Proposal'    THEN 3
        WHEN 'Negotiation' THEN 4
    END;

-- ─────────────────────────────────────────────────────────────
-- 4. OWNER_LEADERBOARD (current quarter)
--    Business question: "Which owners are carrying the pipeline?"
-- ─────────────────────────────────────────────────────────────
WITH owner_leaderboard AS (
    SELECT
        owner,
        COUNT(*)                                            AS open_deals,
        ROUND(SUM(value))                                   AS open_pipeline,
        SUM(CASE WHEN stage = 'Negotiation' THEN 1 ELSE 0 END) AS in_negotiation
    FROM deals
    WHERE stage NOT IN ('Won', 'Lost')
    GROUP BY owner
    ORDER BY open_pipeline DESC
)
SELECT * FROM owner_leaderboard;
