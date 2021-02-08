# COVID Analysis 
## Overview
This project aims to answer three questions that would help understand the current state of COVID-19 testing in the US. 
<br>
1. The total number of tests performed as of yesterday in the United States
2. The 7-day rolling average number of new cases per day rolling over the last 30 days
3. The 10 states with the highest tests positivity rate for tests performed in the last 30 days. 
<br>
The original data is loaded into BigQuery and dbt is used to model the data. 

Documentations on both staging and final data models are available. The whole dbt workflow for this project can be seen by running `dbt docs serve` from the root directory

## About the Data
The data is collected and published through the [COVID Tracking Project](https://covidtracking.com/). Since each state has different method for collecting and caculating data, and some data points are not reported, the results of these analyses are at best an **estimate** and may differ from the actual number. However, it is suffice to give a sense of the current situation with COVID-19 throughout the country. For more information about data definitions, refer to [this page](https://covidtracking.com/about-data/data-definitions#pcr-tests)



## Model Overview
all data models used for this project can be found under the ``models`` directory. There are two staging models under ``models/staging`` and three final data models for the questions under ``models/final``

### Total number of tests
The number of tests performed includes all variations of tests (PCR, specimens, antibody, antigen) conducted in the US as of yesterday. This metric is at best an **estimate** of all variations of tests. Each state has different method of collecting and many data points are not reported. 

The completed sql query can be found under `models/final/total_test_counts.sql`. This data model references staging data at `models/staging/stg_tests_count.sql` from the original data source loaded in BigQuery. 

For PCR and specimen tests, the number is calculated using the `totalTestsViral` column, which represents the **total number of PCR or specimens tested** reported by the state. When this value is null, number of negative and positive test results are added up and used for calculation instead. (field name: `negativeTestsViral`, `positiveTestsViral`).     

Similarly, for antibody test counts, total number of completed antibody tests (`totalTestsAntibody`) is used primarily and when the value is null, positive and negative test results are added up and used for calculation (`positiveTestsAntibody`, `negativeTestsAntibody`)

Lastly for antigen test, only the total number of completed antigen tests (`totalTestsAntigen`) is provided and used for calculation. 

### Rolling Averages
The sql query can be found under `models/final/new_cases_rolling_average.sql`. This model references staging data at `models/staging/stg_new_cases.sql` 

the column `positiveIncrease`, which represents the daily increase in **cases confirmed plus probable**, is used for calculating the rolling averages of new cases. 

For a date, 7 day rolling average is calcuated in `seven_day_rolling_average` column and average of 7 day rolling average on last 30 days is calculated in `seven_day_rolling_average_on_rolling_thrity_days` column. The example output is shown below. 

| date       | seven_day_rolling_average | seven_day_rolling_average_on_rolling_thirty_days |
|------------|---------------------------|--------------------------------------------------|
| 2020-03-12 |        314.71428571428572 |                               36.331797235023039 |
| 2020-03-13 |        416.42857142857144 |                               49.755760368663594 |
| 2020-03-14 |        543.57142857142856 |                               67.281105990783416 |
| 2020-03-15 |        703.42857142857144 |                               89.967741935483872 |
| 2020-03-16 |        907.71428571428567 |                               119.23963133640552 |
| 2020-03-17 |        1150.5714285714287 |                               156.34562211981566 |
| 2020-03-18 |        1570.1428571428571 |                               206.98617511520737 |


### Top 10 states with highest positivity rate
The sql query can be found under `models/final/state_positivity_rate.sql`. This model references staging data at `models/staging/stg_tests_count.sql`

Positivity rate is calculated as (number of positive cases / total number of tests). Positive cases include confirmed cases from both PCR/specimen tests and antigen test. The example output table is as shown below ordered by positive rate in descending order. 

Note that number of positive cases are missing for many states, so this order is among the states that have data avaiable. 

| state | positivity_rate     |
|-------|---------------------|
| TX    | 0.12948053149270461 |
| SC    | 0.12283744768922995 |
| MO    | 0.12153807488026848 |
| TN    | 0.11486967464495083 |




