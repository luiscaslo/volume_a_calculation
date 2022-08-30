{{ config(
    materialized="table"
) }}

WITH rounded_pct_by_answer as (
    SELECT survey_id,
           question_code,
           country,
           answer_code,
           answer_label,
           CASE WHEN position_by_decimals <= dif_to_100 THEN rounded_pct + 1
                ELSE rounded_pct
           END rounded_pct
    FROM {{ref('answers_ordered_by_decimals')}} )

SELECT *
FROM rounded_pct_by_answer
ORDER BY survey_id, question_code, country, answer_code