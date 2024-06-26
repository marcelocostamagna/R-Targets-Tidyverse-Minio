define_coffee_recipe <- function(coffee_train) {
  coffee_recipe <- recipe(coffee_train) %>%
    update_role(everything(), new_role = "support") %>% 
    update_role(cupper_points, new_role = "outcome") %>%
    update_role(
      variety, processing_method, country_of_origin,
      aroma, flavor, aftertaste, acidity, sweetness, altitude_mean_meters,
      new_role = "predictor"
    ) %>%
    step_string2factor(all_nominal(), -all_outcomes()) %>%
    step_impute_knn(country_of_origin,
                   impute_with = imp_vars(
                     in_country_partner, company, region, farm_name, certification_body
                   )
    ) %>%
    step_impute_knn(altitude_mean_meters,
                   impute_with = imp_vars(
                     in_country_partner, company, region, farm_name, certification_body,
                     country_of_origin
                   )
    ) %>%
    step_unknown(variety, processing_method, new_level = "unknown") %>%
    step_other(country_of_origin, threshold = 0.01) %>%
    step_other(processing_method, variety, threshold = 0.10) %>%
    step_normalize(all_numeric(), -all_outcomes())  
}