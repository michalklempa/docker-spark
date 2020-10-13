#!/bin/bash
env

export SPARK_PUBLIC_DNS=$(hostname -i)

java ${JAVA_OPTS} \
    -cp "${PROJECT_HOME}/jars/*" \
    org.apache.spark.deploy.worker.Worker \
    --port 7078 --webui-port 8080 \
    ${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT}
