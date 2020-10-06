#!/bin/bash
env

java ${JAVA_OPTS} \
    -cp "${PROJECT_HOME}/jars/*" \
    org.apache.spark.executor.CoarseGrainedExecutorBackend \
    --driver-url $SPARK_DRIVER_URL \
    --executor-id $SPARK_EXECUTOR_ID \
    --cores $SPARK_EXECUTOR_CORES \
    --app-id $SPARK_APPLICATION_ID \
    --hostname $SPARK_EXECUTOR_POD_IP