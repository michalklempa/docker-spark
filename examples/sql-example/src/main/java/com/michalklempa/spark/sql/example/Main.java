package com.michalklempa.spark.sql.example;

import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.RowFactory;
import org.apache.spark.sql.SparkSession;
import org.apache.spark.sql.types.DataTypes;
import org.apache.spark.sql.types.StructField;
import org.apache.spark.sql.types.StructType;

import java.util.ArrayList;
import java.util.List;

public class Main {
    public static void main(String[] args) {
        List<Double[]> doubles = new ArrayList<>();
        doubles.add(new Double[]{1.0, 30.0});
        doubles.add(new Double[]{1.5, 60.0});
        doubles.add(new Double[]{-5.5, 70.0});
        doubles.add(new Double[]{11.0, 0.0});
        doubles.add(new Double[]{-7.0, 55.0});
        SparkSession spark = SparkSession.builder()
                .appName("SQL Filter")
                .getOrCreate();
        JavaSparkContext sparkContext = new JavaSparkContext(spark.sparkContext());
        JavaRDD<Row> rowRDD = sparkContext
                .parallelize(doubles)
                .map((Double[] row) -> RowFactory.create(row));

        StructType schema = DataTypes
                .createStructType(new StructField[]{
                        DataTypes.createStructField("temperature", DataTypes.DoubleType, false),
                        DataTypes.createStructField("snow", DataTypes.DoubleType, false)
                });

        Dataset<Row> df = spark.sqlContext().createDataFrame(rowRDD, schema).toDF();
        df.createOrReplaceTempView("skiing_conditions");

        spark.sql("SELECT * FROM skiing_conditions WHERE snow > 20.0").show();

        spark.stop();
    }
}