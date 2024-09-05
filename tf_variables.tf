variable "ACCESS_KEY" {
  type = string
}

variable "SECRET_ACCESS_KEY" {
  type = string
}

locals {
  rds_preference_az = "us-east-1a"
  account_id        = data.aws_caller_identity.current.account_id
  timestamp         = formatdate("YYYYDDMM", timestamp())
  s3_folders = [
    "data/",
    "data/database/",
    "data/paraquet/",
    "data/database/csv/",
    "data/database/csv/dataload=${local.timestamp}/",
    "logs/",
    "temp_data/",
    "scripts/",
    # "scripts/${fileset("./", "convert.py")}"
  ]
  s3_data_csv           = "data/database/csv/dataload=${local.timestamp}/customer.csv"
  s3_script             = "scripts/convert.py"
  temp_dir              = "s3://${aws_s3_bucket.CloudOps.bucket}/temp_data"
  spark_event_logs_path = "s3://${aws_s3_bucket.CloudOps.bucket}/logs"

  az = [{
    az : "us-east-1a",
    block : "10.0.0.0/21"
    }, {
    az : "us-east-1b",
    block : "10.0.8.0/21"
  }]

}

data "aws_caller_identity" "current" {}
