#!/bin/bash
env

java ${JAVA_OPTS} \
  -cp "${PROJECT_HOME}/jars/*" \
  org.apache.spark.deploy.SparkSubmit \
  --deploy-mode client \
  --master spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT} \
  --class ${MAIN_CLASS} \
  local:///${PROJECT_BASE_DIR}/${JAR}
