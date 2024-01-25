from airflow import DAG
from airflow.operators.python import PythonOperator, BranchPythonOperator
from airflow.operators.bash import BashOperator
from random import randint

from datetime import datetime


def _choose_best(ti):
    '''
    the parent tasks load returned values into db.
    So you can fetch the data from db by ti argument. It is called xcom
    '''
    
    accuracies = ti.xcom_pull(task_ids=[
        "training_A",
        "training_B",
        "training_C"
    ])
    print('referee', accuracies)
    best_accuracy = max(accuracies)
    
    if (best_accuracy>8):
        return "accurateeee"
    return "inaccurateeee"


def _training_model(): 
    return randint(1, 10)

with DAG("my_dag", start_date=datetime(2020, 2, 2), #if the date is in future the dag does not run
         schedule_interval="@daily", catchup=False) as dag:
    training_model_A = PythonOperator(
        task_id = "training_A",
        python_callable=_training_model
    )

    training_model_B = PythonOperator(
        task_id = "training_B",
        python_callable=_training_model
    )

    training_model_C = PythonOperator(
        task_id = "training_C",
        python_callable=_training_model
    )

    choose_best_model = BranchPythonOperator(
        task_id = "choose_best",
        python_callable=_choose_best
    )

    accurate = BashOperator(
        task_id = "accurateeee",
        bash_command="echo 'accurate!!!'"
    )

    inaccurate = BashOperator(
        task_id = "inaccurateeee",
        bash_command="echo 'inaccurate!!!'"
    )

    [training_model_A,training_model_B,training_model_C] >> choose_best_model >> [accurate, inaccurate]


#https://www.youtube.com/watch?v=IH1-0hwFZRQ
    # sudo fuser -k 8080/tcp
    #kill $(lsof -t -i:8793)