# Ticketing Platform Risk & Purchase-Pattern Analysis

**Status: in progress.** Schema design and data load are complete. Data quality validation is underway: the Accuracy and Completeness dimensions are finished (2 of 6 applicable dimensions), and the other four are not started. The data quality pass will be followed by a business recommendations summary and a Power BI dashboard. This README will be updated as each remaining dimension is finished.

## Overview

This project analyzes ticket purchase and payment data for a live-events platform, with a focus on data quality and risk/fraud-relevant patterns, such as payments recorded after an event has already occurred, or tickets marked unavailable with no attendee on record.

## Data

The dataset is synthetic, generated from a documented prompt (`data_generation_prompt.md`) that specifies six related tables and intentionally introduces row-level messiness (roughly 15-20% of non-key values) to practice real-world data cleaning and validation:

- `event`: ~50 events
- `artist`: ~80 artists
- `ticket`: ~1,000 tickets
- `event_artist`: links artists to events (many-to-many)
- `attendee`: most (not all) tickets have an attendee
- `payment`: most (not all) attendees have a payment

Primary keys, foreign keys, and uniqueness constraints are guaranteed valid by the generation spec. Messiness was scoped to non-key columns (formatting, casing, missing values, and a few unenforced cross-table logical relationships that are expected to have some violations).

## Tools

- **PostgreSQL** (hosted on Neon)
- **DBeaver** for querying and data import
- **Power BI** for the planned dashboard

## Data Quality Validation

Rather than cleaning ad hoc, this project uses one structured validation pass organized around data quality dimensions, scoped to what's actually relevant for a static, synthetic dataset. Accuracy checks were chosen by scanning every non-key column and asking whether the same real-world fact is stored elsewhere in the schema. Columns with no second source to compare against (for example attendee name, email, and phone) are left to the Validity, Consistency, and Completeness checks.

| Dimension | Applicable? | Status |
|---|---|---|
| Accuracy | Yes | Complete |
| Completeness | Yes | Complete |
| Consistency | Yes | Not started |
| Validity | Yes | Not started |
| Uniqueness | Yes (constraint-verified) | Not started |
| Timeliness | No (static, one-time snapshot) | Ruled out |
| Integrity (referential) | Enforced by FK constraints at load time | Verification pending |

All queries are in `data_quality_checks.sql`, labeled to match the findings below.

### Findings: Accuracy

**Check 1, payment timing vs. event date:** Checked whether any payment was recorded after its ticket's event had already occurred (a logical impossibility, since tickets can't be paid for after the event). The check accounts for same-day purchases by comparing dates rather than raw timestamps.

Result: 43 payment records show a payment date after the event date, ranging from 1 to 30 days late. Those values are spread fairly evenly across that whole range rather than clustering toward the low end, which points to how the synthetic data was generated rather than a true outlier. In a real dataset, I'd expect most late payments to be only a few days late, with a smaller number of much later ones, not an even split. It's a good reminder that synthetic data can behave differently from real-world data unless the generation process is built to reflect it.

Limitation: a payment with no payment date cannot be compared to the event date, so the payments missing a date (see Completeness below) are not covered by this check.

**Check 2, ticket price vs. payment amount:** Compared each payment's amount to the price of the ticket it was made for, joining through the attendee table, using a strict exact comparison.

Result: 55 payments do not match their ticket price, in both directions (underpayments and overpayments). Some payments are exactly half the ticket price. Two follow-ups sharpened the picture:

- Check 2a: no attendee has more than one payment row, so the half-price payments are not installments of a payment plan.
- Check 2b: 25 of the 55 mismatches sit on just four ticket prices (750.00, 1250.00, 9.99, and 0.00), while most other prices appear once. The data alone can't show whether those ticket prices or their payments are the wrong side, which is the kind of question I'd take to whoever owns the pricing data.

Limitation: a comparison with a missing value returns unknown, so any ticket without a price or payment without an amount is silently left out. The Completeness checks found 24 tickets with no price and 17 payments with no amount.

**Check 3, ticket availability vs. attendee record:** A ticket's availability flag should agree with whether an attendee row exists for it. Checked for contradictions in both directions.

Result: 45 tickets contradict their availability flag, in two distinct groups:

- 39 tickets are marked available but have an attendee on record.
- 6 tickets are marked sold but have no attendee on record.

Limitation: the 34 tickets with no availability value (see Completeness below) match neither condition, so they are not flagged here.

### Findings: Completeness

A value counts as missing if it is NULL or, for text columns, blank after trimming spaces. Key columns were excluded, and `event_artist` has no non-key columns to check.

Result: gaps show up in every other table, but they are concentrated in a few columns:

- 34 tickets have no availability value, 28 have no type, and 24 have no price
- 23 payments have no payment method, 17 have no amount, and 10 have no payment date
- 13 attendees are missing a name, 17 an email, and 16 a phone number
- `event` and `artist` have only a handful: 4 events without a description, 1 without a venue, and 1 artist without a genre

Several of these gaps weaken the Accuracy checks above: missing ticket prices and payment amounts hide rows from check 2, missing payment dates hide rows from check 1, and missing availability values hide rows from check 3. The per-column counts come from the queries in `data_quality_checks.sql`.

## Repo Contents

- `schema.sql`: table definitions and constraints
- `data_quality_checks.sql`: SQL queries for the data quality validation pass
- `data_generation_prompt.md`: the specification used to generate the synthetic dataset
- `project_notes.md`: project design-decision notes