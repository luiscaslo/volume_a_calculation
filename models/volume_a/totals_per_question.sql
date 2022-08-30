WITH totals AS (
    SELECT survey_id, question_code, country, total_answers
    FROM {{ ref('totals_per_question_multichoice') }}
    WHERE question_code NOT LIKE '%rgps'
    UNION
    SELECT survey_id, question_code, country, total_weighted_answers AS total_answers
    FROM {{ ref('totals_per_question_no_multi') }}
    WHERE question_code NOT LIKE '%rgps'
    ),

    totals_per_question AS (
    SELECT survey_id,
       question_code,
       country,
       0 answer_code,
       'TOTAL' answer_label,
       total_answers AS weighted_num_answers
       --,
       --' ' rounded_pct
    FROM totals
    )

SELECT *
FROM totals_per_question
ORDER BY question_code, country
