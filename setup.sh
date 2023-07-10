#!/usr/bin/env bash
source ./airflow/.env

up() {
  echo "Starting Airbyte..."
  cd airbyte
  docker-compose up -d
  cd ..

  echo "Starting Airflow..."
  cd airflow 
  docker-compose up airflow-init
  docker-compose up -d
  cd ..

  echo "Starting Metabase..."
  cd metabase
  docker-compose up -d
  cd ..
 
  echo "Access Airbyte at http://localhost:8000 and set up the connections."
  
  echo "Access Airflow at http://localhost:8080 to kick off your Airbyte sync DAG."  

  echo "Access Metabase at http://localhost:3000 and set up a connection with Snowflake."

}

down() {
  echo "Stopping Airbyte..."
  cd airbyte
  docker-compose down
  cd ..
  echo "Stopping Airflow..."
  cd airflow
  docker-compose down
  cd ..
  echo "Stopping Metabase..."
  cd metabase
  docker-compose down
  cd ..
}

config() {

  # Set connection IDs for DAG.
  cd airflow
  docker-compose run airflow-webserver airflow variables import ./variables.json

  docker network create modern-data-stack
  docker network connect modern-data-stack airbyte-proxy
  docker network connect modern-data-stack airbyte-worker  
  docker network connect modern-data-stack airflow_airflow-worker_1
  docker network connect modern-data-stack airflow_airflow-webserver_1
  docker network connect modern-data-stack metabase
  
  cd airflow
  docker-compose run airflow-webserver airflow connections add 'airbyte_connection' --conn-uri 'airbyte://airbyte-proxy:8000'
  cd ..
  
  echo "Config Updated..."
}


case $1 in
  up)
    up
    ;;
  config)
    config
    ;;
  down)
    down
    ;;
  *)
    echo "Usage: $0 {up|config|down}"
    ;;
esac
