# A. Customer Journey
## Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.

1. Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!

```sql
SELECT 
    s.customer_id,
    p.plan_name,
    p.price,
    s.start_date
FROM subscriptions s
JOIN plans p ON s.plan_id = p.plan_id
WHERE s.customer_id IN (1, 2, 11, 13, 15, 16, 18, 19)
ORDER BY s.customer_id, s.start_date;
´´´
