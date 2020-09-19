#!/bin/bash
java -Dlog4j.configurationFile=${PROJECT_HOME}/conf/log4j2.xml \
  -cp "${PROJECT_HOME}/jars/*" \
  org.apache.spark.deploy.master.Master \
  --port 7077 --webui-port 8080
