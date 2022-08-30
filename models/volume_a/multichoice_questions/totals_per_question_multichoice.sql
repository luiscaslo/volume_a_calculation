WITH totals_tmp AS (
    SELECT survey_id, question_code, country, COUNT(DISTINCT survey_feedback_id) AS feedbacks_count, SUM(country_weight) AS total_weight, ROUND(SUM(country_weight)) AS total_answers
    FROM (
        SELECT DISTINCT
               survey_id,
               CASE WHEN INSTR(question_code, '.') > 0 THEN SUBSTR(question_code, 1, INSTR(question_code, '.')-1)
                    ELSE question_code
                    END AS question_code,
               country,
               survey_feedback_id,
               country_weight
        FROM {{ ref('answer_weights_multichoice') }} )
    GROUP BY survey_id, question_code, country
    ),

totals_per_question_multi AS (
    SELECT survey_id, question_code, country, total_weight, total_answers
    FROM totals_tmp
    WHERE country NOT IN  ('NI', 'GB')
    UNION
    SELECT survey_id, question_code, 'DE' AS country, SUM(total_weight) AS total_weight, SUM(total_answers) AS total_answers
    FROM totals_tmp
    WHERE country in ('D-E', 'D-W')
    GROUP BY survey_id, question_code, 'DE'
    UNION
    SELECT survey_id, question_code, 'UK' AS country, SUM(total_weight) AS total_weight, SUM(total_answers) AS total_answers
    FROM totals_tmp
    WHERE country in ('NI', 'GB')
    GROUP BY survey_id, question_code, 'UK'
    UNION
    SELECT survey_id, question_code, 'EU' AS country, SUM(total_weight) AS total_weight, SUM(total_answers) AS total_answers
    FROM totals_tmp
    WHERE country in ({{ var('eu28_countries') }})
    GROUP BY survey_id, question_code, 'EU'
    )

SELECT *
FROM totals_per_question_multi
ORDER BY country
