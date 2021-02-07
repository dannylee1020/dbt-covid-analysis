with temp1 as(
    select
        date,
        state,
        positive_test_count,
        totalTestsViral,
        positiveTestsAntigen,
        totalTestsAntigen
    from {{ ref('stg_tests_count') }}
)
,
temp2 as(
  select
    state,
    sum(positive_test_count) as total_pcr_positive_count,
    sum(totalTestsViral) as total_pcr_test_count,
    sum(positiveTestsAntigen) as total_antigen_positive_count,
    sum(totalTestsAntigen) as total_antigen_test_count
  from temp1
  where date between date_sub(current_date(), interval 30 day) and current_date()
  group by 1
)
  select
    state,
    (total_pcr_positive_count + total_antigen_positive_count)  / (total_pcr_test_count + total_antigen_test_count) as positivity_rate
  from temp2
  order by 2 desc