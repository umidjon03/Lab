cd ~/Documents/Airflow
python -m venv airV
source airV/bin/activate
# this makes current path as a main airflow path (creates config file and db, etc)
export AIRFLOW_HOME=/home/umidjon/Documents/Airflow/
airflow users create --username admin --firstname fn --lastname ln --role Admin --email admin@admin.com
airflow webserver
airflow scheduler

# additional
airflow dags list
airflow config list
airflow tasks `dag_id` list