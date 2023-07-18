# Lesson

## Brief

### Lesson Overview

This lesson introduces advanced query and statements. Learners will be able to use meta queries to retrieve information about the database, use joins and unions to combine data from multiple tables, use window functions to calculate aggregates over a set of rows, use subqueries to filter data and apply common table expressions to create temporary tables.

---

## Part 1 - Meta queries

Open DBeaver and create a new connection to the DuckDB database file `db/unit-1-5.db`.

The tables we will be using are in the `main` (default) schema.

### List and describe tables

To list all the tables in `main`, run the following query:

```sql
SHOW TABLES;
```

You should see 4 rows of data. Each row represents the name of a table in the schema:

- `address`
- `car`
- `claim`
- `client`

If you want to see more details, run:

```sql
SHOW ALL TABLES;
```

To view the schema of an individual table, use the `DESCRIBE`` command.

```sql
DESCRIBE address;
```

You should see the column names and data types.

> Describe the other 3 tables. Study their column names and data types.

### Summarize tables

You can use the `SUMMARIZE` command to launch a query that computes a number of aggregates over all columns (of a table or query), including min, max, avg, std and approx_unique.

```sql
SUMMARIZE address;
```

> Summarize the other 3 tables. Study their min, max, approx_unique, avg and std (if applicable).

## Part 2 - Joins
