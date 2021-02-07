with temp1 as(
    select
        *
    from {{ ref('stg_tests_count') }}
)
,
temp2 as(
  select
    state,
    case
      when (negative_test_count is null or positive_test_count is null) and totalTestsViral is not null then totalTestsViral
      when totalTestsViral is null then total_pcr_specimen_test
    end as pcr_specimens_test_count,
    case
      when negative_antibody_test_count is null or positive_antibody_test_count is null then totalTestsAntibody
      when totalTestsAntibody is null then total_antibody_test_count
    end as antibody_test_count,
    totalTestsAntigen as antigen_test_count
  from temp1
  where date <= date_sub(current_date(), interval 1 day)
)
,
temp3 as(
  select
    state,
    sum(coalesce(pcr_specimens_test_count, 0)) + sum(coalesce(antibody_test_count, 0)) + sum(coalesce(antigen_test_count,0)) as total_test_count
  from temp2
  group by 1
)

  select
    sum(total_test_count) as total_test_count_in_us
  from temp3