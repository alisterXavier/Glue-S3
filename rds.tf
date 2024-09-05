# resource "aws_db_instance" "CloudOpsBlend" {
#   #   db_name                = "CloudOpsBlend"
#   engine         = "sqlserver-ex"
#   instance_class = "db.t3.micro"
#   #   multi_az               = true
#   allocated_storage      = 200
#   username               = "admin"
#   password               = "qwertyqwerty"
#   db_subnet_group_name   = aws_db_subnet_group.CloudOpsBlendSubnetGroup.name
#   vpc_security_group_ids = [aws_security_group.RdsSecurityGroup.id]
#   iops                   = 3000
#   license_model          = "license-included"
#   skip_final_snapshot    = true
#   availability_zone      = var.rds_preference_az
# }
