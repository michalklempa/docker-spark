#!/bin/bash
env

export SPARK_PUBLIC_DNS=$(hostname -i)

java ${JAVA_OPTS} \
  -cp "${PROJECT_HOME}/jars/*" \
  org.apache.spark.deploy.SparkSubmit \
  --deploy-mode client \
  --master spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT} \
  --class ${MAIN_CLASS} \
  --conf 'spark.driver.host='$(hostname -i) \
  local:///${PROJECT_BASE_DIR}/${JAR}
