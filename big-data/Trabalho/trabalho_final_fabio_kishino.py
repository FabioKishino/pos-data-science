
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark import SparkConf

Config = SparkConf()
Config.set("spark.sql.repl.eagerEval.enabled", True)
Config.set("spark.sql.repl.eagerEval.maxNumRows", "20")
Config.set("spark.sql.repl.eagerEval.truncate", "-1")
Config.set("spark.driver.memory","10G")
Config.set("spark.memory.fraction", 0.9)
Config.set("spark.sql.adaptive.enabled", "true")
Config.set("spark.sql.adaptive.join.enabled", "true")
Config.set('spark.sql.legacy.allowNonEmptyLocationInCTAS','true')
Config.set("spark.sql.optimizer.dynamicPartitionPruning.enabled", "true")
Config.set("spark.sql.sources.partitionOverwriteMode","dynamic")
Config.set("spark.serializer", "org.apache.spark.serializer.KryoSerializer")

spark = SparkSession.builder.config(conf=Config).master("local[*]").appName("TrabalhoFinal").getOrCreate()

path = "/Users/fabiokishino/Documents/Dev/pos-data-science/big-data/Trabalho/discentes-egressos-2025.csv"

df_csv = (
    spark.read
    .option("sep", ";")
    .option("quote", '"')
    .option("header", "true")
    .option("encoding", "ISO-8859-1")
    .csv(path)
)

df_csv.write.parquet("parquet/", mode='overwrite')

df = spark.read.parquet("parquet/")

df = df.select(*[nullif(df[column_name], lit('')).alias(column_name) for column_name in df.columns])

df = df.select(
    df["matricula"].try_cast(LongType()).alias("matricula"),
    df["nome_discente"].try_cast(StringType()).alias("nome_discente"),
    df["sexo"].try_cast(StringType()).alias("sexo"),
    df["ano_conclusao"].try_cast(IntegerType()).alias("ano_conclusao"),
    df["periodo_conclusao"].try_cast(IntegerType()).alias("periodo_conclusao"),
    df["ano_ingresso"].try_cast(IntegerType()).alias("ano_ingresso"),
    df["periodo_ingresso"].try_cast(IntegerType()).alias("periodo_ingresso"),
    df["id_curso"].try_cast(IntegerType()).alias("id_curso"),
    df["nome_curso"].try_cast(StringType()).alias("nome_curso"),
    df["modalidade_educacao"].try_cast(StringType()).alias("modalidade_educacao"),
    df["forma_ingresso"].try_cast(StringType()).alias("forma_ingresso"),
    df["tipo_discente"].try_cast(StringType()).alias("tipo_discente"),  
    df["nivel_ensino"].try_cast(StringType()).alias("nivel_ensino"),
    df["id_unidade"].try_cast(IntegerType()).alias("id_unidade"),
    df["nome_unidade"].try_cast(StringType()).alias("nome_unidade"),
    df["id_unidade_gestora"].try_cast(IntegerType()).alias("id_unidade_gestora"),
    df["nome_unidade_gestora"].try_cast(StringType()).alias("nome_unidade_gestora"),
    current_timestamp().alias("update_date")
)
df.createOrReplaceTempView("raw_data")

df = df.na.fill({
  'matricula': -1,
  'nome_discente': "N/A",
  'sexo': "N/A",
  'ano_conclusao': -1,
  'periodo_conclusao': -1,
  'ano_ingresso': -1,
  'periodo_ingresso': -1,
  'id_curso': -1,
  'nome_curso': "N/A",
  'modalidade_educacao': "N/A",
  'forma_ingresso': "N/A",
  'tipo_discente': "N/A",
  'nivel_ensino': "N/A",
  'id_unidade': -1,
  'nome_unidade': "N/A",
  'id_unidade_gestora': -1,
  'nome_unidade_gestora': "N/A",
})

df.repartition("ano_ingresso").write.partitionBy("ano_ingresso").mode("overwrite").parquet("partitioned_data/")

print("Sucesso!")
