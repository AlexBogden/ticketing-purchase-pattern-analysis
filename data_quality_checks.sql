/* 
 * DATA QUALITY CHECKS
 */

/* Accuracy check #1 (payment timing vs event date): payments recorded after their event already happened */

SELECT e.event_id, t.ticket_id ,e.name AS event_name, e.date AS event_date, (p.payment_date::date - e.date) AS days_late, p.payment_date, 
a.attendee_id,a."name" , p.amount
FROM event e
	JOIN ticket t ON e.event_id = t.event_id
	JOIN attendee a ON t.ticket_id = a.ticket_id 
	JOIN payment p ON a.attendee_id = p.attendee_id 
WHERE p.payment_date::date > e.date
ORDER BY days_late DESC;

/* Accuracy check #2 (ticket price vs payment amount): payments whose amount does not match the price of the ticket */

SELECT t.ticket_id, t.event_id, t.price, a.attendee_id, a."name", p.payment_id, p.amount, (p.amount - t.price) AS diff
FROM ticket t 
	JOIN attendee a ON t.ticket_id = a.ticket_id
	JOIN payment p ON a.attendee_id = p.attendee_id
WHERE t.price <> p.amount
ORDER BY a.ticket_id;

/* Accuracy check #2a (follow-up to #2): attendees with more than one payment row */

SELECT count(p.attendee_id) AS payments_made, p.attendee_id 
FROM payment p 
GROUP BY p.attendee_id
HAVING count(p.attendee_id) > 1;


/* Accuracy check #2b (follow-up to #2): which ticket prices recur among the price vs payment amount mismatches */

SELECT t.price, count(t.price) AS price_frequency
FROM ticket t 
	JOIN attendee a ON t.ticket_id = a.ticket_id
	JOIN payment p ON a.attendee_id = p.attendee_id
WHERE t.price <> p.amount
GROUP BY t.price
ORDER BY price_frequency DESC, t.price DESC;

/* Accuracy check #3 (ticket availability vs attendee row): tickets marked available that have an attendee, or marked sold with no attendee */

SELECT t.event_id , t.ticket_id , a.attendee_id , a."name" , t.availability, 
	CASE 
		WHEN t.availability = FALSE AND a.attendee_id IS NULL THEN 'Sold with no attendee listed'
		WHEN t.availability = TRUE AND a.attendee_id IS NOT NULL THEN 'Marked available with attendee present'
	END AS issue_type
FROM ticket t 
	LEFT JOIN attendee a ON t.ticket_id = a.ticket_id 
WHERE (t.availability = FALSE AND a.attendee_id IS NULL) OR (t.availability = TRUE AND a.attendee_id IS NOT NULL); 






