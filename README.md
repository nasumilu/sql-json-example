# Database JSON Examples

## Customer Order Object

The json stored in the table is an array of customer order object(s). 

```json
[
    {
        "id": 1,
        "name": "Item One",
        "amount": 4999
    }
]
```

## Query Example

Query to calculate the sum of all order grouped by customers

### MySQL >= 8.0


```sql
SELECT 
	c.name, 
    CAST(FORMAT(SUM(j.amount)/100, 2) AS float) AS total
FROM customer AS c
LEFT JOIN (
	SELECT
		customer, 
        a.amount
	FROM customer_order,
    json_table(items, '$[*]' COLUMNS ( amount INT PATH '$.amount') ) AS a
) AS j ON j.customer = c.id
GROUP BY c.name
ORDER BY total ASC;
```

### PostgreSQL >= 12

```sql
SELECT 
	c.name,
	(SUM(j.amount)::float8/100) as total
FROM customer AS c
LEFT JOIN (
	SELECT 
	customer, 
	jsonb_path_query(items::jsonb, '$[*].amount')::int AS amount
	FROM customer_order) AS j ON j.customer = c.id
GROUP BY c.name
ORDER BY total ASC;
```