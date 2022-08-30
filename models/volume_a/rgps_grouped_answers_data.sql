WITH not_repeated_rgps_answers AS (
    SELECT survey_id,
           REPLACE(question_code, 'rgps', '') question_code,
           country,
           answer_code,
           answer_label,
           weighted_num_answers,
           rounded_pct
    FROM {{ ref('rounded_data') }}
    WHERE question_code LIKE '%rgps' AND
          ( survey_id, REPLACE(question_code, 'rgps', ''), answer_label )
          NOT IN ( SELECT distinct survey_id, question_code, answer_label
                   FROM {{ ref('rounded_data') }} )
    ),

rgps_grouped_answers_data AS (
    SELECT *
    FROM {{ ref('rounded_data') }}
    WHERE question_code NOT LIKE '%rgps'
    UNION
    SELECT *
    FROM not_repeated_rgps_answers
    )

SELECT *
FROM rgps_grouped_answers_data
ORDER BY question_code, TO_NUMBER(answer_code)