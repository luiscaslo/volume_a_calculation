
WITH volume_a_no_labels AS (
    SELECT survey_id,
           question_code,
           country,
           answer_code,
           answer_label,
           weighted_num_answers,
           rounded_pct
    FROM {{ ref('rgps_grouped_answers_data') }}
    UNION
    SELECT survey_id,
           question_code,
           country,
           answer_code,
           answer_label,
           weighted_num_answers,
           rounded_pct
    FROM {{ ref('volume_a_data_multichoice') }}
    UNION
    SELECT survey_id,
           question_code,
           country,
           answer_code,
           answer_label,
           weighted_num_answers,
           null rounded_pct
    FROM {{ ref('totals_per_question') }}
    ),

    volume_a AS (
    SELECT v.survey_id,
           v.question_code,
           question_label,
           country,
           answer_code,
           answer_label,
           weighted_num_answers,
           rounded_pct
    FROM volume_a_no_labels v
    INNER JOIN ( SELECT DISTINCT survey_id,
                        CASE WHEN INSTR(question_code, '.') > 0
                             THEN substr(question_code, 1, INSTR(question_code, '.')-1)
                             ELSE question_code END AS question_code,
                        question_label
                 FROM survey_question_labels ) q
            ON q.survey_id   = v.survey_id AND
               v.question_code = q.question_code
    )

SELECT *
FROM volume_a
ORDER BY question_code, country, answer_code