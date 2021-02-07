# getting counts, state and date  
select
  negativeTestsViral as negative_test_count, 
  positiveTestsViral as positive_test_count,
  negativeTestsViral+positiveTestsViral as total_pcr_specimen_test,
  totalTestsViral, -- PCR or specimens
  negativeTestsAntibody as negative_antibody_test_count,
  positiveTestsAntibody as positive_antibody_test_count,
  negativeTestsAntibody + positiveTestsAntibody as total_antibody_test_count,
  totalTestsAntibody,
  positiveTestsAntigen,
  totalTestsAntigen,
  state,
  date
from `dbt-sandbox-303803.torch_covid_data.all_states_history`