
WITH rounded_data AS (
    SELECT p.survey_id,
           p.question_code,
           p.country,
           p.answer_code,
           p.answer_label,
           ROUND(s.weighted_num_answers) AS weighted_num_answers,
           p.rounded_pct
    FROM {{ref('rounded_pct_by_answer')}} p
         INNER JOIN {{ref('stats_by_answer')}} s
                 ON s.survey_id = p.survey_id AND
                    s.question_code = p.question_code AND
                    s.country = p.country AND
                    s.answer_code = p.answer_code )

SELECT *
FROM rounded_data
ORDER BY question_code, country, answer_code