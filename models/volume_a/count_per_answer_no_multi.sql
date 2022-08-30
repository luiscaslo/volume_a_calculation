WITH counts AS (
    SELECT survey_id,
           question_code,
           country,
           answer_code,
           answer_label,
           COUNT(*) AS num_answers,
           SUM(country_weight) AS weighted_num_answers,
           SUM(de_weight) AS weighted_num_answers_de,
           SUM(eu_weight) AS weighted_num_answers_eu
    FROM {{ ref('answer_weights_no_multichoice') }}
    WHERE survey_id IN ({{ var('survey_id') }})
    GROUP BY survey_id, question_code, country, answer_code, answer_label
    ),

count_per_answer_countries AS (
    SELECT survey_id, question_code, country, answer_code, answer_label, num_answers, weighted_num_answers
    FROM counts
    WHERE country NOT IN ('NI', 'GB')
    UNION
    SELECT survey_id, question_code, 'DE' country, answer_code, answer_label, SUM(num_answers) AS num_answers, SUM(weighted_num_answers_de) AS weighted_num_answers
    FROM counts
    WHERE country IN ('D-E', 'D-W')
    GROUP BY survey_id, question_code, 'DE', answer_code, answer_label
    UNION
    SELECT survey_id, question_code, 'UK' country, answer_code, answer_label, SUM(num_answers) AS num_answers, SUM(weighted_num_answers) AS weighted_num_answers
    FROM counts
    WHERE country IN ('NI', 'GB')
    GROUP BY survey_id, question_code, 'UK', answer_code, answer_label
    UNION
    SELECT survey_id, question_code, 'EU' country, answer_code, answer_label, SUM(num_answers) AS num_answers, SUM(weighted_num_answers_eu) AS weighted_num_answers
    FROM counts
    WHERE country IN ({{ var('eu28_countries') }})
    GROUP BY survey_id, question_code, 'EU', answer_code, answer_label
    )

SELECT *
FROM count_per_answer_countries
ORDER BY survey_id, question_code, country, answer_code
