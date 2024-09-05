import sys

from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext

args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Script generated for node AWS Glue Data Catalog
AWSGlueDataCatalog_node1723455619270 = glueContext.create_dynamic_frame.from_catalog(database="cloudopsblend", table_name="csv", transformation_ctx="AWSGlueDataCatalog_node1723455619270")

# Script generated for node Change Schema
ChangeSchema_node1723455631368 = ApplyMapping.apply(frame=AWSGlueDataCatalog_node1723455619270, mappings=[("customerid", "long", "customerid", "long"), ("namestyle", "boolean", "namestyle", "boolean"), ("title", "string", "title", "string"), ("firstname", "string", "firstname", "string"), ("middlename", "string", "middlename", "string"), ("lastname", "string", "lastname", "string"), ("suffix", "string", "suffix", "string"), ("companyname", "string", "companyname", "string"), ("salesperson", "string", "salesperson", "string"), ("emailaddress", "string", "emailaddress", "string"), ("phone", "string", "phone", "string"), ("passwordhash", "string", "passwordhash", "string"), ("passwordsalt", "string", "passwordsalt", "string"), ("rowguid", "string", "rowguid", "string"), ("modifieddate", "string", "modifieddate", "string"), ("dataload", "string", "dataload", "string")], transformation_ctx="ChangeSchema_node1723455631368")

# Script generated for node Amazon S3
AmazonS3_node1723455636239 = glueContext.write_dynamic_frame.from_options(frame=ChangeSchema_node1723455631368, connection_type="s3", format="glueparquet", connection_options={"path": "s3://aws-glue-cloudops-101/data/paraquet/", "partitionKeys": []}, format_options={"compression": "snappy"}, transformation_ctx="AmazonS3_node1723455636239")

job.commit()