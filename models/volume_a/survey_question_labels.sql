WITH survey_questions AS (
    SELECT DISTINCT survey_id, question_id
    FROM {{ source('EBUSER', 'survey_feedback_answers') }}
    WHERE survey_id = ({{ var('survey_id') }})
),
survey_question_labels AS (
    SELECT sq.survey_id, q.question_code AS question_code, q.question_label
    FROM survey_questions sq
    INNER JOIN {{ source('EBUSER', 'questions') }} q
            ON q.question_id = sq.question_id
)

SELECT *
FROM survey_question_labels
ORDER BY question_code
