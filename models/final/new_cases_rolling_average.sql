with temp1 as(
    select
        *
    from {{ ref('stg_new_cases') }}
)
,
temp2 as(
  select
    date,
    sum(coalesce(positiveIncrease,0)) as new_positive_case
  from temp1
  group by 1
)
,
moving_average_seven as(
  select
    date,
    new_positive_case,
    avg(new_positive_case) over(order by date rows between 6 preceding and current row) as seven_day_rolling_average
  from temp2
  group by 1,2
  order by 1
)
  select
    date,
    seven_day_rolling_average,
    avg(seven_day_rolling_average) over(order by date rows between 30 preceding and current row) as seven_day_rolling_average_on_rolling_thirty_days
  from moving_average_seven
  order by 1