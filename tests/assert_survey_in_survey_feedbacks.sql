-- Checing if the survey passed as a parameter exists in the table 'survey_feedbacks'.
-- Using the command MINUS in the query, if the number of rows returned by ut is >= 0, then it means that the survey does not exist in 'survey_feedbacks'.

SELECT {{ var('survey_id') }} survey_id
FROM DUAL
MINUS
SELECT distinct survey_id
FROM {{ source('EBUSER', 'survey_feedbacks' )}}
WHERE survey_id IN ({{ var('survey_id') }})
