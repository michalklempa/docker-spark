#!/bin/bash

env

export SPARK_PUBLIC_DNS=$(hostname -i)

java ${JAVA_OPTS} \
  -cp "${JAR}:${SPARK_HOME}/conf:${SPARK_HOME}/jars/*" \
  org.apache.spark.deploy.SparkSubmit \
  --deploy-mode client \
  --master spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT} \
  --class ${MAIN_CLASS} \
  ${SUBMIT_OPTS} \
  --conf 'spark.driver.host='$(hostname -i) \
  local://${JAR}
