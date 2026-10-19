/* 
 * DATA QUALITY CHECKS
 */

/* 
 * Accuracy check #1 (payment timing vs event date — payments recorded after their event already happened)
 */
SELECT e.event_id, t.ticket_id ,e.name AS event_name, e.date AS event_date, (p.payment_date::date - e.date) AS days_late, p.payment_date, 
a.attendee_id,a."name" , p.amount
FROM event e
	JOIN ticket t ON e.event_id = t.event_id
	JOIN attendee a ON t.ticket_id = a.ticket_id 
	JOIN payment p ON a.attendee_id = p.attendee_id 
WHERE p.payment_date::date > e.date
ORDER BY days_late DESC;


SELECT 
FROM ticket
JOIN 