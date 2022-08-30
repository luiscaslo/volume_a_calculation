
WITH answers_ordered_by_decimals as (
    SELECT sd.survey_id,
           sd.question_code,
           sd.country,
           answer_code,
           sd.answer_label,
           rounded_pct,
           decimals,
           dif_to_100,
           row_number() over ( PARTITION BY sd.survey_id, sd.question_code, sd.country ORDER BY decimals DESC ) position_by_decimals
    FROM {{ ref('stats_by_answer') }} sd
         INNER JOIN ( SELECT survey_id, question_code, country, 100 - SUM(rounded_pct) dif_to_100
                      FROM {{ ref('stats_by_answer') }}
                      GROUP BY survey_id, question_code, country ) sd2
                 ON sd.survey_id = sd2.survey_id AND sd.question_code = sd2.question_code AND sd.country = sd2.country
    ORDER BY sd.survey_id, sd.question_code, sd.country, decimals DESC )

SELECT *
FROM answers_ordered_by_decimals