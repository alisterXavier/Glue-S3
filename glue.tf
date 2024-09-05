resource "aws_glue_catalog_database" "CloudOpsBlend" {
  name = "cloudopsblend"
}
resource "aws_glue_crawler" "CloudOpsBlendCrawler" {
  name          = "cloudOpsblendcrawler"
  database_name = aws_glue_catalog_database.CloudOpsBlend.name
  role          = aws_iam_role.GlueServiceRole.arn
  s3_target {
    path = "s3://${aws_s3_bucket.CloudOps.bucket}/data/database/csv/"
  }
}
resource "aws_glue_connection" "CloudOpsBlend" {
  name = "CloudOpsBlendRDSConn"
  connection_properties = {
    JDBC_CONNECTION_URL = "jdbc:sqlserver://database-1.cvs4smgmij47.us-east-1.rds.amazonaws.com:1433;databaseName=CloudOpsBlend" // Modify this to 
    USERNAME            = "SecureLogin"
    PASSWORD            = "YourSecurePassword"
  }
  physical_connection_requirements {
    availability_zone      = local.rds_preference_az
    security_group_id_list = [aws_security_group.RdsSecurityGroup.id]
    subnet_id              = data.aws_subnets.rds_subnet.ids[0]
  }
}
resource "aws_glue_crawler" "CloudOpsBlendCrawlerRDS" {
  name          = "cloudOpsblendcrawlerrds"
  database_name = aws_glue_catalog_database.CloudOpsBlend.name
  role          = aws_iam_role.GlueServiceRole.arn
  jdbc_target {
    connection_name = aws_glue_connection.CloudOpsBlend.name
    path            = "CloudBlendOps/dbo/Customers"
  }
}
