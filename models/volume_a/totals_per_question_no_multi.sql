WITH totals AS (
    SELECT survey_id,
           question_code,
           country,
           SUM(num_answers) AS total_answers,
           ROUND(SUM(weighted_num_answers)) AS total_weighted_answers,
           SUM(weighted_num_answers) AS total_weighted_answers_norounded   -- Temp change. 470 CY Issue ==> Change is correct
    FROM {{ ref('count_per_answer_no_multi') }}
    GROUP BY survey_id, question_code, country )

SELECT *
FROM totals
