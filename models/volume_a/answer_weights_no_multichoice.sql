WITH answer_weights_no_multi AS (
    SELECT survey_id,
           survey_feedback_id,
           question_code,
           country,
           answer_code,
           answer_label,
           country_weight,
           eu_weight,
           de_weight
    FROM {{ ref('answer_weights') }}
    WHERE question_type_id <> 5   -- We exclude the multi-choice questions as the totals are calculated differently
    )

SELECT *
FROM answer_weights_no_multi
