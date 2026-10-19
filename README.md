# Ticketing Platform Risk & Purchase-Pattern Analysis

**Status: in progress.** Schema design and data load are complete. Data quality validation is underway: 1 of 6 planned dimension checks documented so far (Accuracy). The data quality pass will be followed by a business recommendations summary and a Power BI dashboard. This README will be updated as each remaining check is finished.

## Overview

This project analyzes ticket purchase and payment data for a live-events platform, with a focus on data quality and risk/fraud-relevant patterns, such as payments recorded after an event has already occurred, or tickets marked unavailable with no attendee on record.

## Data

The dataset is synthetic, generated from a documented prompt (`data_generation_prompt.md`) that specifies six related tables and intentionally introduces row-level messiness (roughly 15-20% of non-key values) to practice real-world data cleaning and validation:

- `event` — ~50 events
- `artist` — ~80 artists
- `ticket` — ~1,000 tickets
- `event_artist` — links artists to events (many-to-many)
- `attendee` — most (not all) tickets have an attendee
- `payment` — most (not all) attendees have a payment

Primary keys, foreign keys, and uniqueness constraints are guaranteed valid by the generation spec. Messiness was scoped to non-key columns (formatting, casing, missing values, and a few unenforced cross-table logical relationships that are expected to have some violations).

## Tools

- **PostgreSQL** (hosted on Neon)
- **DBeaver** for querying and data import
- **Power BI** for the planned dashboard

## Data Quality Validation

Rather than cleaning ad hoc, this project uses one structured validation pass organized around data quality dimensions, scoped to what's actually relevant for a static, synthetic dataset:

| Dimension | Applicable? | Status |
|---|---|---|
| Accuracy | Yes | In progress |
| Completeness | Yes | Not started |
| Consistency | Yes | Not started |
| Validity | Yes | Not started |
| Uniqueness | Yes (constraint-verified) | Not started |
| Timeliness | No — static, one-time snapshot | Ruled out |
| Integrity (referential) | Enforced by FK constraints at load time | Verification pending |

### Findings so far

**Accuracy — payment timing vs. event date:** Checked whether any payment was recorded after its ticket's event had already occurred (a logical impossibility, since tickets can't be paid for after the event). The check accounts for same-day purchases by comparing dates rather than raw timestamps.

Result: 41 payment records show a payment date after the event date, ranging from 1 to 30 days late. Those values are spread fairly evenly across that whole range rather than clustering toward the low end, which points to how the synthetic data was generated rather than a true outlier. In a real dataset, I'd expect most late payments to be only a few days late, with a smaller number of much later ones, not an even split. It's a good reminder that synthetic data can behave differently from real-world data unless the generation process is built to reflect it.

## Repo Contents

- `schema.sql` — table definitions and constraints
- `data_quality_checks.sql` — SQL queries for the data quality validation pass
- `data_generation_prompt.md` — the specification used to generate the synthetic dataset
- `ticketing_funnel_notes.md` — project design-decision notes