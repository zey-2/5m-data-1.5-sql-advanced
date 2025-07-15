-- Although python is used frequently for data analytics, SQL is relevant when these queries along the data pipelines.
SHOW TABLES;

SHOW ALL TABLES;

DESCRIBE address;

SUMMARIZE claim;

SELECT
    *
FROM
    claim;

SELECT
    *
FROM
    claim
    INNER JOIN car on claim.car_id = car.id;

SELECT
    claim_date,
    travel_time,
    claim_amt,
    car_type,
    car_use
FROM
    claim
    LEFT JOIN car on claim.car_id = car.id;

-- WHERE claim_amt BETWEEN 10 AND 30;
SELECT
    *
FROM
    claim
    INNER JOIN client AS c1 ON claim.client_id = c1.id
    INNER JOIN client AS c2 ON c1.address_id = c2.address_id;

SELECT
    *
FROM
    claim
UNION
SELECT
    *
FROM
    car;

-- Binder Error: Set operations can only apply to expressions with the same number of result columns
-- Error occurs because union requires the same number of column and datatype
SELECT
    *
FROM
    claim
    LEFT JOIN client ON claim.client_id = client.id
    LEFT JOIN address ON client.address_id = address.id;

-- Duplicated header
SELECT
    id,
    claim_date,
    claim_amt,
    SUM(claim_amt) OVER (
        ORDER BY
            claim_amt
    ) AS running_total
FROM
    claim;

SELECT
    id,
    car_id,
    claim_amt,
    SUM(claim_amt) OVER (
        PARTITION BY
            car_id
        ORDER BY
            claim_amt
    ) AS running_total
FROM
    claim;

SELECT
    id,
    car_id,
    travel_time,
    SUM(travel_time) OVER (
        ORDER BY
            car_id
    ) AS running_total
FROM
    claim;

-- learn rank
-- the rank value jumps to three in this case.
SELECT
    id,
    car_id,
    claim_amt,
    RANK() OVER (
        PARTITION BY
            car_id
        ORDER BY
            claim_amt DESC
    ) AS claim_rank
FROM
    claim
WHERE
    car_id = 80;

-- filter rank = 1
SELECT
    id,
    car_id,
    claim_amt,
    RANK() OVER (
        PARTITION BY
            car_id
        ORDER BY
            claim_amt DESC
    ) AS claim_rank
FROM
    claim QUALIFY claim_rank = 1;

-- Moving windows example
SELECT
    id,
    claim_date,
    claim_amt,
    AVG(claim_amt) OVER (
        ORDER BY
            claim_date ROWS BETWEEN 2 PRECEDING
            AND CURRENT ROW
    ) AS moving_avg
FROM
    claim;

-- subquery, it is possible to perform a join then check the criteria
-- subquery may be easier to understand
SELECT
    id,
    resale_value,
    car_type
FROM
    car
WHERE
    id IN (
        SELECT DISTINCT
            car_id
        FROM
            claim
    );

--
SHOW claim;

SHOW car;

-- CTE is just like function 
-- It is necessary to run together as one query
WITH
    avg_resale_value_by_car_type AS (
        SELECT
            car_type,
            AVG(resale_value) AS average_resale_value
        FROM
            car
        GROUP BY
            car_type
    )
SELECT
    id,
    resale_value,
    c1.car_type
FROM
    car c1
    INNER JOIN avg_resale_value_by_car_type c2 ON c1.car_type = c2.car_type
WHERE
    resale_value < average_resale_value;

WITH
    avg_resale_value_by_car_use AS (
        SELECT
            car_use,
            AVG(resale_value) AS average_resale_value
        FROM
            car
        GROUP BY
            car_use
    )
SELECT
    id,
    resale_value,
    c1.car_use
FROM
    car c1
    INNER JOIN avg_resale_value_by_car_use c2 ON c1.car_use = c2.car_use
WHERE
    resale_value < average_resale_value;

WITH
    avg_resale_value_by_car_use AS (
        SELECT
            car_use,
            AVG(resale_value) AS average_resale_value
        FROM
            car
        GROUP BY
            car_use
    )
SELECT
    id,
    resale_value,
    c1.car_use
FROM
    car c1
    INNER JOIN avg_resale_value_by_car_use c2 ON c1.car_use = c2.car_use
WHERE
    resale_value < average_resale_value;

SELECT
    id,
    car_id,
    travel_time,
    SUM(travel_time) OVER (
        PARTITION BY
            car_id
        ORDER BY
            id
    ) AS running_total
FROM
    claim;