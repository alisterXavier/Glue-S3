resource "aws_s3_bucket" "CloudOps" {
  bucket        = "aws-glue-cloudops-101-404-444-101"
  force_destroy = true
}
resource "aws_s3_object" "Create_folders" {
  count = length(local.s3_folders)
  bucket   = aws_s3_bucket.CloudOps.id
  key      = local.s3_folders[count.index]
}
resource "aws_s3_object" "Upload_csv" {
  bucket = aws_s3_bucket.CloudOps.id
  key    = local.s3_data_csv
  source = "Glue_S3/customer.csv"
}
resource "aws_s3_object" "Upload_script" {
  bucket = aws_s3_bucket.CloudOps.id
  key    = local.s3_script
  source = "Glue_S3/convert.py"
}