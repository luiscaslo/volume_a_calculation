import pandas as pd
from sqlalchemy import types
from sqlalchemy.engine import create_engine
import cx_Oracle

config = {
	"host": "eurobarometer.ccvk2kcsyvls.eu-west-1.rds.amazonaws.com",
	"port": 1521,
	"sid": "ORCL",
	"username": "ebuser_tmp",
	"password": "ebuser!2022"
}
dsn = cx_Oracle.makedsn(config["host"], config["port"], sid=config["sid"])
conn_str = "oracle://{user}:{password}@{sid}".format(
	user=config["username"], password=config["password"], sid=dsn)
conn = create_engine(conn_str)

print("Connection established...")

data = pd.read_sql("select survey_id, question_id, country, answer_code, answer_label, weighted_num_answers, rounded_pct from volume_a_data", conn)

print(data)

df = pd.DataFrame(data)
df.rename(columns={'weighted_num_answers': 'count', 'rounded_pct': 'percentage'}, inplace=True)

# Counts and percentages in 2 rows
df2 = df.melt(id_vars=['survey_id', 'question_id', 'country', 'answer_code', 'answer_label'], value_vars=['count', 'percentage'])
df2 = df2.sort_values(['survey_id', 'question_id', 'country', 'answer_code'])
df2 = df2[['question_id', 'country', 'answer_code', 'answer_label', 'variable', 'value']]
df2 = df2.astype({"answer_code": int})

# Countries as columns
df2 = df2.pivot(index=['question_id', 'answer_code', 'answer_label', 'variable'], columns='country', values='value')


df2 = df2.reset_index()
df2.rename(columns={'question_id': 'Question', 'answer_label': 'Answer', 'variable': 'KPI'}, inplace=True)

# to Excel
writer = pd.ExcelWriter('poc_generate_volumes.xlsx')
grouped = df2.groupby('Question')
for name, group in grouped:
	print(name)
	group.to_excel(writer, sheet_name=name, index=False)
writer.save()

print("END")
