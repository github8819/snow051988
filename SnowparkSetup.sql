USE ROLE ACCOUNTADMIN;

-- Create the warehouse, database and schema
CREATE OR REPLACE WAREHOUSE SNOWPARK_DEMO_WH;
CREATE OR REPLACE DATABASE SNOWPARK_DEMO_DB;
CREATE OR REPLACE SCHEMA SNOWPARK_DEMO_SCHEMA;


-- Create table CAMPAIGN_SPEND from data hosted on publicly accessible S3 bucket
CREATE or REPLACE file format csvformat
  skip_header = 1
  type = 'CSV';

CREATE or REPLACE stage campaign_data_stage
  file_format = csvformat
  url = 's3://sfquickstarts/ad-spend-roi-snowpark-python-scikit-learn-streamlit/campaign_spend/';

list @campaign_data_stage;

SELECT $1,$2,$3,$4,$5,$6,$7
FROM @campaign_data_stage;

SELECT $1,$2,$3,$4,$5,$6
FROM @campaign_data_stage;

CREATE or REPLACE TABLE CAMPAIGN_SPEND (
  CAMPAIGN VARCHAR(60), 
  CHANNEL VARCHAR(60),
  DATE DATE,
  TOTAL_CLICKS NUMBER(38,0),
  TOTAL_COST NUMBER(38,0),
  ADS_SERVED NUMBER(38,0)
);

COPY into CAMPAIGN_SPEND
  from @campaign_data_stage;

SELECT * FROM CAMPAIGN_SPEND
LIMIT 1000;

-- Create table MONTHLY_REVENUE from data hosted on publicly accessible S3 bucket
CREATE or REPLACE stage monthly_revenue_data_stage
  file_format = csvformat
  url = 's3://sfquickstarts/ad-spend-roi-snowpark-python-scikit-learn-streamlit/monthly_revenue/';

LIST @monthly_revenue_data_stage;

CREATE or REPLACE TABLE MONTHLY_REVENUE (
  YEAR NUMBER(38,0),
  MONTH NUMBER(38,0),
  REVENUE FLOAT
);

COPY into MONTHLY_REVENUE
  from @monthly_revenue_data_stage;

SELECT * FROM MONTHLY_REVENUE
LIMIT 1000;

-- Create table BUDGET_ALLOCATIONS_AND_ROI that holds the last six months of budget allocations and ROI
CREATE or REPLACE TABLE BUDGET_ALLOCATIONS_AND_ROI (
  MONTH varchar(30),
  SEARCHENGINE integer,
  SOCIALMEDIA integer,
  VIDEO integer,
  EMAIL integer,
  ROI float
)
COMMENT = '{"origin":"sf_sit-is", "name":"aiml_notebooks_ad_spend_roi", "version":{"major":1, "minor":0}, "attributes":{"is_quickstart":1, "source":"streamlit"}}';

INSERT INTO BUDGET_ALLOCATIONS_AND_ROI (MONTH, SEARCHENGINE, SOCIALMEDIA, VIDEO, EMAIL, ROI)
VALUES
('January',35,50,35,85,8.22),
('February',75,50,35,85,13.90),
('March',15,50,35,15,7.34),
('April',25,80,40,90,13.23),
('May',95,95,10,95,6.246),
('June',35,50,35,85,8.22);

SELECT * FROM BUDGET_ALLOCATIONS_AND_ROI;

https://www.snowflake.com/en/developers/guides/getting-started-with-snowpark-in-snowflake-python-worksheets/

DROP DATABASE SNOWPARK_DEMO_DB;