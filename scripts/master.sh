#!/bin/bash
env

java ${JAVA_OPTS} \
  -cp "${PROJECT_HOME}/jars/*" \
  org.apache.spark.deploy.master.Master \
  --port 7077 --webui-port 8080
