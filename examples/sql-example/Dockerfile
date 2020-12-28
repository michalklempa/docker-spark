ARG SPARK_VERSION=3.0.1
ARG HADOOP_VERSION=2.7
ARG ARG_JAR_NAME=spark-sql-example-1.0.0-SNAPSHOT.jar
ARG ARG_MAIN_CLASS=com.michalklempa.spark.sql.example.Main

FROM maven:3-openjdk-8 as build
ARG ARG_JAR_NAME
ARG ARG_MAIN_CLASS

RUN mkdir /work
COPY pom.xml /work/pom.xml
COPY src /work/src

WORKDIR /work
RUN mvn clean package

FROM michalklempa/spark:${SPARK_VERSION}-hadoop${HADOOP_VERSION}
ARG ARG_JAR_NAME
ARG ARG_MAIN_CLASS

COPY --from=build /work/target/${ARG_JAR_NAME} /${ARG_JAR_NAME}

ENV MAIN_CLASS=${ARG_MAIN_CLASS}
ENV JAR="/${ARG_JAR_NAME}"