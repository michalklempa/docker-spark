#!/bin/bash
java -Dlog4j.configurationFile=$PWD/conf/log4j2.xml \
    -cp "${PWD}/jars/*" \
    org.apache.spark.deploy.worker.Worker \
    --port 7078 --webui-port 8080 \
    ${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT}
