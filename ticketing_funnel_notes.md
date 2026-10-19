# Ticketing Purchase Pattern Analysis — Project Notes

Working notes for the ticketing-funnel-analysis portfolio project. Keep this file in the project repo alongside schema.sql.

## Design Decisions

### Synthetic data: key integrity vs. value-level messiness

The data-generation prompt keeps all primary key, foreign key, and unique values valid and consistent across the CSVs, while allowing realistic messiness in non-key columns (missing data, inconsistent formatting, logical mismatches like a payment amount not quite matching a ticket price).

This reflects how constraints actually function in a live database. Primary key, foreign key, and unique constraints are enforced at the database level, so any row that violates them is rejected before it's ever written. That means structural issues, like broken keys or orphaned references, typically show up upstream of a constrained table (raw source data, staging tables, unvalidated migrations or API pulls), not inside a table that already has those constraints in place. Value-level issues aren't caught by constraints at all, which is why those are the imperfections this dataset was designed to include.

### Messiness percentage: 15-20% of rows

Chose 15-20% of rows to contain some form of data-quality issue, based on an Experian data quality survey commonly cited in industry sources, which found companies estimate roughly 25-26% of their organizational data is "dirty" (Progress: https://www.progress.com/blogs/the-staggering-impact-of-dirty-data, Cazoomi: https://www.cazoomi.com/blog/dirty-data-how-much-it-can-cost-your-business-and-how-to-get-rid-of-it/). That figure is a broad, self-reported estimate across many types of data issues at the organizational level, not a precise per-field measurement, so 15-20% was chosen as a slightly conservative but still defensible number that stays true to the spirit of the benchmark while remaining manageable to clean at this dataset's size.
