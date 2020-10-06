#!/bin/bash
env

java ${JAVA_OPTS} \
  -cp "${PROJECT_BASE_DIR}/${JAR}:${PROJECT_HOME}/jars/*" \
  ${MAIN_CLASS}