USE DATABASE FILMS_DB;

USE SCHEMA FILMS_SCHEMA;

-- File format
CREATE OR REPLACE FILE FORMAT csv_fmt
  TYPE = CSV
  --SKIP_HEADER = 1; --ignore the first line(s)
   PARSE_HEADER=TRUE; --care about header names.
 

--  Internal stage
CREATE OR REPLACE STAGE csv_stage
  FILE_FORMAT = csv_fmt;

list @csv_stage;

-- Upload first file customer_initial.csv

-- Create table using inferred schema from first file

SELECT *
 FROM TABLE(
   INFER_SCHEMA(
     LOCATION=>'@"FILMS_DB"."FILMS_SCHEMA"."CSV_STAGE"/customer_initial.csv',
      FILE_FORMAT=>'csv_fmt'
     )
   );

   
-- Create table using inferred schema from first file

--Detect the Schema

CREATE OR REPLACE TABLE CUSTOMER_TABLE
USING TEMPLATE (
  SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*)) ---Object_construct converst to Key:Pair, Array converts to array
    FROM TABLE(
      INFER_SCHEMA(
        LOCATION=>'@"FILMS_DB"."FILMS_SCHEMA"."CSV_STAGE"/customer_initial.csv',
        FILE_FORMAT=>'csv_fmt'
      )
    ));


SELECT * FROM customer_table;

--  Enable schema evolution
ALTER TABLE customer_table SET ENABLE_SCHEMA_EVOLUTION = TRUE;

--  Copy data

  COPY INTO customer_table
  FROM @csv_stage
  FILE_FORMAT = (FORMAT_NAME = 'csv_fmt' ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE)
  MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;



--  Verify table structure & contents

DESC TABLE customer_table;
SELECT * FROM customer_table;

--UPLOADED customer_updated FILE AND ITS HAVING 2 new columns Email and Subscription date

  COPY INTO customer_table
  FROM @csv_stage
  FILE_FORMAT = (FORMAT_NAME = 'csv_fmt' ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE)
  MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;

DESC TABLE customer_table;
SELECT * FROM customer_table;