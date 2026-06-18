import sys
from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.python import PythonOperator

# Permite que Airflow encuentre la carpeta scripts/
sys.path.append('/opt/airflow')
from scripts.ingestion import run_ingestion

default_args = {
    'owner': 'magic_doors_team',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=3),
}

with DAG(
    dag_id='elt_magic_doors_pipeline',
    default_args=default_args,
    description='Pipeline ELT de ingesta y limpieza para Magic Doors DW',
    schedule_interval=timedelta(days=1),
    start_date=datetime(2026, 1, 1),
    catchup=False,
) as dag:

    task_extract_load = PythonOperator(
        task_id='Extract_Clean_and_Load',
        python_callable=run_ingestion,
    )

    task_extract_load
