WITH answer_weights_multi AS (
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
    WHERE question_type_id = 5   -- We take only the multi-choice questions
    )

SELECT *
FROM answer_weights_multi
