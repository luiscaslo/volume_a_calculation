
WITH country_by_rec AS (
    SELECT survey_id, survey_feedback_id, DECODE(c.iso_code, 'GR', 'EL', c.iso_code) iso_code
    FROM {{ source('EBUSER', 'survey_feedbacks') }} f
         INNER JOIN {{ source('EBUSER', 'country_dim') }} c
                 ON c.country_id = f.country_id
    WHERE f.survey_id IN ({{ var('survey_id') }}) )

SELECT *
FROM country_by_rec
ORDER BY survey_id, survey_feedback_id