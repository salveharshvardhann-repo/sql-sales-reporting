# SQL Sales Reporting Toolkit

Reusable SQL queries and views that turn raw deal/pipeline tables into standardized,
trustworthy reports — no more rebuilding the same numbers by hand every week.

**Author:** Harshvardhan Salve · [LinkedIn](https://linkedin.com/in/harshvardhan-salve-7601s)

---

## The problem

Recurring business questions ("What's our pipeline by stage?", "Who are the top owners
this quarter?", "Where do deals drop off?") were answered by pulling fresh data from raw
tables each time. Different people wrote different queries — so different people reported
*different numbers for the same question*.

## The approach

Standardize once, reuse forever:

1. A fixed **schema** (`schema.sql`) that defines what a "deal" record looks like.
2. A set of **versioned queries** (`queries.sql`) that answer the recurring questions.
3. Anyone who runs `queries.sql` gets the *same* answer — the queries are the source of truth.

## Repository structure

```
sql-sales-reporting/
├── schema.sql      # CREATE TABLE + sample data (SQLite-compatible)
├── queries.sql     # 4 standardized reporting queries
└── README.md
```

## How to run

```bash
# 1. Create the database with sample data
sqlite3 sales.db < schema.sql

# 2. Run any query
sqlite3 sales.db < queries.sql
```

(Any SQL client works — the syntax is deliberately plain SQL.)

## The queries

| # | Query | Business question |
|---|-------|-------------------|
| 1 | `pipeline_by_stage` | What is our open pipeline worth, by stage? |
| 2 | `monthly_won_revenue` | What revenue closed each month? |
| 3 | `funnel_conversion` | Where do deals drop off between stages? |
| 4 | `owner_leaderboard` | Which owners are carrying the pipeline this quarter? |

## Sample output (query 3 — funnel conversion)

```
stage        deals_entered  converted_to_next  conversion_pct
-----------  -------------  -----------------  --------------
Lead                   120                 86           71.7%
Qualified               86                 52           60.5%
Proposal                52                 31           59.6%
Negotiation             31                 26           83.9%
```

The Negotiation→Won step converts well; **Proposal→Negotiation is the bottleneck** —
exactly the kind of signal a pre-sales team should act on.

## Skills demonstrated

- Multi-table aggregation with `GROUP BY`, `CTE`s and window functions
- Funnel/conversion analysis
- Clean, commented, reusable SQL written for *other people* to run
- Translating a business question into a standard report

## Note

The data here is a representative sample with the same *shape* as real pipeline data I
work with (names/values are illustrative, not client data).
