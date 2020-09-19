#!/bin/bash
java -Dlog4j.configurationFile=${PROJECT_HOME}/conf/log4j2.xml \
  -cp "${PROJECT_HOME}/jars/*" \
  org.apache.spark.deploy.SparkSubmit \
  --deploy-mode client \
  --master spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT} \
  --class com.michalklempa.spark.sql.example.Main \
  local:///${PROJECT_BASE_DIR}/spark-sql-example-1.0.0-SNAPSHOT.jar