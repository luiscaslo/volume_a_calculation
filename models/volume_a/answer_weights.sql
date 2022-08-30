WITH answer_weights AS (
    SELECT fa.survey_id,
           fa.survey_feedback_id,
           q.question_code AS question_code,
           c.iso_code country,
           a.answer_code answer_code,
           a.label answer_label,
           sf.country_weight,
           sf.eu_weight,
           sf_de.country_weight de_weight,
           q.question_type_id
    FROM {{ source('EBUSER', 'survey_feedback_answers') }} fa
         INNER JOIN {{ source('EBUSER', 'answers') }} a
                 ON a.question_id = fa.question_id AND a.answer_id = fa.answer_id
         INNER JOIN {{ source('EBUSER', 'questions') }} q
                 ON q.question_id = fa.question_id
         INNER JOIN {{ref('feedback_countries')}} c
                 ON c.survey_id = fa.survey_id AND c.survey_feedback_id = fa.survey_feedback_id
         INNER JOIN {{ source('EBUSER', 'survey_feedbacks') }} sf
                 ON sf.survey_id = fa.survey_id AND sf.survey_feedback_id = fa.survey_feedback_id
         LEFT OUTER JOIN ( SELECT survey_id, survey_feedback_id, weight_value AS country_weight
                           FROM {{ source('EBUSER', 'feedback_weights') }}
                           WHERE weight_code = 'w3' ) sf_de
                      ON sf_de.survey_feedback_id = fa.survey_feedback_id AND sf_de.survey_id = fa.survey_id
    WHERE fa.survey_id IN ({{ var('survey_id') }})
    )

SELECT *
FROM answer_weights
