Prompt

I need you to write and run Python code to generate a synthetic relational dataset for a fictional live-events ticketing platform, then export the results as CSV files. Please use code execution rather than generating example rows by hand; this is important for enforcing exact row counts, valid foreign key relationships, and a controlled percentage of intentionally messy data across a large number of rows, which is difficult to guarantee through manually written examples.

Before generating anything, please ask me any clarifying questions if something in the spec below is ambiguous or underspecified.

Here's the full specification:

Generate a synthetic relational dataset for a fictional live-events ticketing platform (similar in structure to SeatGeek or Ticketmaster), across six related tables: event, ticket, attendee, payment, artist, event_artist.

event table columns: event_id (int, primary key), name (varchar, up to 255 chars), date (date), venue (varchar, up to 255 chars), description (text)

ticket table columns: ticket_id (int, primary key), event_id (int, foreign key referencing event.event_id), type (varchar, up to 50 chars), price (decimal, 10,2), availability (boolean)

attendee table columns: attendee_id (int, primary key), name (varchar, up to 255 chars), email (varchar, up to 255 chars), phone (varchar, up to 15 chars), ticket_id (int, foreign key referencing ticket.ticket_id, one-to-one relationship, unique)

payment table columns: payment_id (int, primary key), attendee_id (int, foreign key referencing attendee.attendee_id), amount (decimal, 10,2), payment_date (timestamp), payment_method (varchar, up to 50 chars)

artist table columns: artist_id (int, primary key), name (varchar, up to 255 chars), genre (varchar, up to 30 chars)

event_artist table columns: event_artist_id (int, primary key), event_id (int, foreign key referencing event.event_id), artist_id (int, foreign key referencing artist.artist_id), unique combination of event_id and artist_id

Generate roughly 50 events spread across the past 12 months, with roughly 1,000 tickets distributed across those events, an attendee row for most (not all) tickets, and a payment row for most (not all) attendees.

Generate roughly 80 artists, with most events featuring between 1 and 4 artists via the event_artist table. Every artist should be linked to at least one event, and some artists should perform at more than one event.

ticket.type should use a small realistic set of values (e.g. General, VIP, Early Bird, Group)

payment.payment_method should use a small realistic set of values (e.g. Credit Card, Debit Card, PayPal, Apple Pay)

artist.genre should use a small realistic set of values (e.g. Pop, Rock, Hip-Hop, Country, Electronic, Jazz)

artist.name should be realistic-sounding fictional artist or band names, not the names of real musicians or performers

ticket.price and payment.amount should fall within a realistic range (e.g. $20 to $500)

ticket.availability should reflect whether a ticket has been sold, generally corresponding to whether it has a matching attendee record

payment_date should generally occur before the event's date, and amount should generally correspond to the linked ticket's price

This data will be loaded into a live PostgreSQL database with primary key, foreign key, and unique constraints already enforced, so all key and foreign key values must remain valid and consistent across the CSVs. Apply the requested messiness only to non-key columns.

Include realistic messiness typical of real-world operational data, affecting roughly 15-20% of rows, without telling me which columns or what specific issues you introduced.

Output each table as a separate CSV file.