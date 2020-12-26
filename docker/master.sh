#!/bin/bash
env

export SPARK_PUBLIC_DNS=$(hostname -i)

java ${JAVA_OPTS} \
  -cp "${SPARK_HOME}/conf:${SPARK_HOME}/jars/*" \
  org.apache.spark.deploy.master.Master \
  --host ${SPARK_PUBLIC_DNS} --port 7077 --webui-port 8080
