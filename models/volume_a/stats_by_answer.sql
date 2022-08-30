
WITH stats_by_answer AS (
    SELECT c.survey_id,
           c.question_code,
           c.country,
           c.answer_code,
           c.answer_label,
           -- ROUND(num_answers*100/total_answers, 2) answer_pct,
           CASE WHEN t.total_weighted_answers = 0
                THEN FLOOR(c.weighted_num_answers*100/t.total_answers)
                --ELSE FLOOR(c.weighted_num_answers*100/t.total_weighted_answers)
                ELSE FLOOR(c.weighted_num_answers*100/t.total_weighted_answers_norounded)   -- Temp change. 470 CY Issue ==> Change is correct
           END rounded_pct,
           CASE WHEN t.total_weighted_answers = 0
                THEN REPLACE(ABS(MOD(c.weighted_num_answers*100/t.total_answers, 1)), '.')
                ELSE REPLACE(ABS(MOD(c.weighted_num_answers*100/t.total_weighted_answers_norounded, 1)), '.')
                --THEN regexp_substr(TO_CHAR(ROUND(c.weighted_num_answers*100/t.total_answers, 2)), '\d+$')
                --ELSE regexp_substr(TO_CHAR(ROUND(c.weighted_num_answers*100/t.total_weighted_answers, 2)), '\d+$')
                --ELSE regexp_substr(TO_CHAR(ROUND(c.weighted_num_answers*100/t.total_weighted_answers_norounded, 2)), '\d+$')   -- Temp change. 470 CY Issue ==> Change is correct
           END decimals,
           -- num_answers,
           t.total_answers,
           c.weighted_num_answers
   FROM {{ ref('count_per_answer_no_multi') }} c
        INNER JOIN {{ ref('totals_per_question_no_multi') }} t
                ON c.survey_id = t.survey_id AND c.question_code = t.question_code AND c.country = t.country )

SELECT *
FROM stats_by_answer