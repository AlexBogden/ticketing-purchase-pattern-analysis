CREATE TABLE "event" (
  "event_id" int PRIMARY KEY,
  "name" varchar(255),
  "date" date,
  "venue" varchar(255),
  "description" text
);

CREATE TABLE "artist" (
  "artist_id" int PRIMARY KEY,
  "name" varchar(255),
  "genre" varchar(30)
);

CREATE TABLE "ticket" (
  "ticket_id" int PRIMARY KEY,
  "event_id" int NOT NULL,
  "type" varchar(50),
  "price" decimal(10,2),
  "availability" boolean
);

CREATE TABLE "event_artist" (
  "event_artist_id" int PRIMARY KEY,
  "event_id" int NOT NULL,
  "artist_id" int NOT NULL
);

CREATE TABLE "attendee" (
  "attendee_id" int PRIMARY KEY,
  "name" varchar(255),
  "email" varchar(255),
  "phone" varchar(15),
  "ticket_id" int UNIQUE NOT NULL
);

CREATE TABLE "payment" (
  "payment_id" int PRIMARY KEY,
  "attendee_id" int NOT NULL,
  "amount" decimal(10,2),
  "payment_date" timestamp,
  "payment_method" varchar(50)
);

CREATE UNIQUE INDEX ON "event_artist" ("event_id", "artist_id");

ALTER TABLE "ticket" ADD FOREIGN KEY ("event_id") REFERENCES "event" ("event_id");

ALTER TABLE "payment" ADD FOREIGN KEY ("attendee_id") REFERENCES "attendee" ("attendee_id");

ALTER TABLE "attendee" ADD FOREIGN KEY ("ticket_id") REFERENCES "ticket" ("ticket_id");

ALTER TABLE "event_artist" ADD FOREIGN KEY ("artist_id") REFERENCES "artist" ("artist_id");

ALTER TABLE "event_artist" ADD FOREIGN KEY ("event_id") REFERENCES "event" ("event_id");





SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';

SELECT * FROM EVENT WHERE description IS NULL;

SELECT 
	COUNT(*) FILTER (WHERE name IS NULL) AS null_name,
	COUNT(*) FILTER (WHERE date IS null) AS null_date,
	COUNT(*) FILTER (WHERE venue IS NULL) AS null_venue,
	COUNT(*) FILTER (WHERE description IS NULL) AS null_desc
FROM event;

SELECT *
FROM EVENTS
WHERE description IS NULL OR TRIM(description) = '';

SELECT *
FROM EVENT
WHERE description IS NULL OR description = '';


SELECT e.event_id, t.ticket_id ,e.name AS event_name, e.date AS event_date, (p.payment_date::date - e.date) AS days_late, p.payment_date, 
a.attendee_id,a."name" , p.amount
FROM event e
	JOIN ticket t ON e.event_id = t.event_id
	JOIN attendee a ON t.ticket_id = a.ticket_id 
	JOIN payment p ON a.attendee_id = p.attendee_id 
WHERE p.payment_date::date > e.date
ORDER BY days_late DESC;















