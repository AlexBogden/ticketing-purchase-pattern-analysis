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

