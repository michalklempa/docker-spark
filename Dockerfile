ARG SPARK_VERSION=3.0.1
ARG HADOOP_VERSION=2.7
ARG SCALA_VERSION=2.12

FROM alpine:3 as build
ARG SPARK_VERSION
ARG HADOOP_VERSION

ENV PROJECT_BASE_DIR /opt/spark
ENV PROJECT_HOME ${PROJECT_BASE_DIR}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}
ENV PROJECT_DIST_FILE_NAME="spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz"

RUN apk --update add --no-cache \
  && apk add --no-cache ca-certificates openssl curl wget \
  && update-ca-certificates \
  && rm -f /var/cache/apk/*

RUN mkdir -p ${PROJECT_HOME} \
    && DOWNLOAD_DIST_URL="$(curl -s https://www.apache.org/dyn/closer.cgi\?preferred\=true)spark/spark-${SPARK_VERSION}/${PROJECT_DIST_FILE_NAME}" \
    && CURL_OUTPUT="${PROJECT_BASE_DIR}/${PROJECT_DIST_FILE_NAME}" \
    && curl -# ${DOWNLOAD_DIST_URL} --output ${CURL_OUTPUT} \
    && tar -xvzf ${CURL_OUTPUT} --strip-components 1 -C ${PROJECT_HOME} \
    && rm ${CURL_OUTPUT}

FROM openjdk:11-slim-buster as final
ARG SPARK_VERSION
ARG HADOOP_VERSION
ARG SCALA_VERSION

ENV PROJECT_BASE_DIR /opt/spark
ENV PROJECT_HOME ${PROJECT_BASE_DIR}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}

COPY --from=build ${PROJECT_HOME}/bin ${PROJECT_HOME}/bin
COPY --from=build ${PROJECT_HOME}/conf ${PROJECT_HOME}/conf
COPY --from=build ${PROJECT_HOME}/jars ${PROJECT_HOME}/jars
COPY --from=build ${PROJECT_HOME}/LICENSE ${PROJECT_HOME}/LICENSE
COPY --from=build ${PROJECT_HOME}/NOTICE ${PROJECT_HOME}/NOTICE
COPY --from=build ${PROJECT_HOME}/README.md ${PROJECT_HOME}/README.md
COPY --from=build ${PROJECT_HOME}/RELEASE ${PROJECT_HOME}/.md
COPY --from=build ${PROJECT_HOME}/sbin ${PROJECT_HOME}/sbin

ENV PATH $PATH:$PROJECT_HOME/bin

COPY ./scripts/*.sh ${PROJECT_BASE_DIR}/

ENV SPARK_HOME ${PROJECT_HOME}
ENV SPARK_MASTER_HOST spark-master
ENV SPARK_MASTER_PORT 7077
ENV SPARK_SCALA_VERSION ${SCALA_VERSION}

WORKDIR ${PROJECT_HOME}
EXPOSE 8080
CMD [ "/bin/bash" ]
