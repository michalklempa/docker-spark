ARG SCALA_VERSION=2.12
ARG SPARK_VERSION=3.0.1
ARG HADOOP_VERSION=2.7

FROM curlimages/curl as build
ARG SPARK_VERSION
ARG HADOOP_VERSION

ENV UPSTREAM_FILE_NAME="spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz"
ENV LOCAL_FILE_NAME="/tmp/${UPSTREAM_FILE_NAME}"
ENV SPARK_HOME="/opt/spark"

RUN curl -# "$(curl -s https://www.apache.org/dyn/closer.cgi\?preferred\=true)spark/spark-${SPARK_VERSION}/${UPSTREAM_FILE_NAME}" --output "${LOCAL_FILE_NAME}"
ENV SPARK_TMP="/tmp/spark"
RUN mkdir ${SPARK_TMP}
RUN tar -xvzf "${LOCAL_FILE_NAME}" --strip-components 1 -C "${SPARK_TMP}"
RUN echo "${UPSTREAM_FILE_NAME}" > "${SPARK_TMP}/.spark-version"

FROM azul/zulu-openjdk-debian:11 as final
ARG SCALA_VERSION
ARG SPARK_VERSION
ARG SPARK_TMP="/tmp/spark"

ENV SPARK_HOME="/opt/spark"
RUN mkdir ${SPARK_HOME}

COPY --from=build ${SPARK_TMP}/bin ${SPARK_HOME}/bin
COPY --from=build ${SPARK_TMP}/conf ${SPARK_HOME}/conf
COPY --from=build ${SPARK_TMP}/jars ${SPARK_HOME}/jars
COPY --from=build ${SPARK_TMP}/LICENSE ${SPARK_HOME}/LICENSE
COPY --from=build ${SPARK_TMP}/NOTICE ${SPARK_HOME}/NOTICE
COPY --from=build ${SPARK_TMP}/README.md ${SPARK_HOME}/README.md
COPY --from=build ${SPARK_TMP}/RELEASE ${SPARK_HOME}/RELEASE
COPY --from=build ${SPARK_TMP}/sbin ${SPARK_HOME}/sbin
COPY --from=build ${SPARK_TMP}/.spark-version ${SPARK_HOME}/.spark-version

ENV PATH $PATH:$SPARK_HOME/bin

COPY ./docker/*.sh /

ENV SPARK_MASTER_HOST=spark-master
ENV SPARK_MASTER_PORT=7077
ENV SPARK_SCALA_VERSION=${SCALA_VERSION}

WORKDIR ${SPARK_HOME}
EXPOSE 8080
CMD [ "/bin/bash" ]