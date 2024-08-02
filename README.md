# Overview
## The task
Marketing department requests a segmentation of the users to create
dedicated marketing campaigns for these segments.  
To determine the segments the Data Science Team wants to cluster the users and needs appropriate features to create the model.  
It's needed to design a data pipeline, which provides a data mart with the next features for each customer.

## Solution description
The pipelines is based on **dbt** (Data Base Tool) - for data transformation.  
**PostgreSQL** was used as a database.


The data mart with new features - **users_segmentation_features** table:
- age
- country
- state
- nearest distribution center
- product return rate in the last year
- customer profit level in the last year:  
    - level 1 > 50$ or less
    - level 2 - more than 50 but less than 150$
    - level 3 - more than 150$

## Dataset
The dataset is famous **theLook eCommerce** from Google BigQuery: https://console.cloud.google.com/marketplace/product/bigquery-public-data/thelook-ecommerce


# How to run
1. run `docker compose up` - the data mart will be genrated in the database.

# Operationalized version
For example, in GCP:
- Cloud Sheduler - to run pipeline executions (e.g. once a week)
- Snowflake - to store raw data
- dbt Cloud - for data transformation
- BigQuery - to execute queries and store data marts
- Vertex AI - to build, run and monitor ML models for classification (segmentation)
- Data Studio - to visualize data marts with resulted user segments
