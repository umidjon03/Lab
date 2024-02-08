from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta
import requests
import json, xmltodict
from sqlalchemy import create_engine
import pandas as pd

default_args = {
    'owner': 'admin',
    'start_date': datetime(2020, 1, 1),
    # 'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    'fetching_xml',
    default_args=default_args,
    schedule_interval='@daily',  # Set your desired schedule
)

def fetch_xml_data(**kwargs):
    # Replace 'YOUR_API_ENDPOINT' with the actual API endpoint
    api_endpoint = 'https://c115-185-230-204-108.ngrok-free.app/api/data/'
    response = requests.get(api_endpoint)
    return response.text

import os
def process_and_load_data(**kwargs):
    ti = kwargs['ti']
    xml_data = ti.xcom_pull(task_ids='fetch_xml_data')
    
    # Parse XML data (you may need to use an XML parsing library)
    # For simplicity, let's assume the data is in a format that can be converted to a DataFrame
    # df = pd.DataFrame(...)  # Convert XML data to DataFrame
    print(xml_data, type(xml_data))
    o = xmltodict.parse(xml_data)
    print(o, type(o))
    # Load data into PostgreSQL (replace 'postgresql://user:password@host:port/db' with your database connection)
    # engine = create_engine('postgresql://user:password@host:port/db')
    # df.to_sql('your_table_name', con=engine, if_exists='replace', index=False)

    # Save as JSON
    with open('/home/umidjon/Documents/Airflow/out.json', 'w') as json_file:
        json.dump(o, json_file)

fetch_task = PythonOperator(
    task_id='fetch_xml_data',
    python_callable=fetch_xml_data,
    dag=dag,
)

process_and_load_task = PythonOperator(
    task_id='process_and_load_data',
    python_callable=process_and_load_data,
    provide_context=True,
    dag=dag,
)

# Define the task dependencies
fetch_task >> process_and_load_task
