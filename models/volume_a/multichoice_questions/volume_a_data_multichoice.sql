WITH volume_a_data_multichoice AS (
    SELECT c.survey_id,
           c.question_code,
           c.country,
           c.answer_code,
           c.answer_label,
           ROUND(c.weighted_num_answers) AS weighted_num_answers,
           ROUND(c.weighted_num_answers/t.total_weight*100) AS rounded_pct
    FROM {{ ref('count_per_answer_multichoice') }} c
         INNER JOIN {{ ref('totals_per_question_multichoice') }} t
                 ON t.survey_id = c.survey_id AND t.question_code = c.question_code AND t.country = c.country
    UNION
    SELECT survey_id,
           question_code,
           country,
           0 answer_code,
           'TOTAL' answer_label,
           total_answers weighted_num_answers,
           null rounded_pct
    FROM {{ ref('totals_per_question_multichoice') }}
    )

SELECT *
FROM volume_a_data_multichoice
ORDER BY survey_id, question_code, country, TO_NUMBER(answer_code)
