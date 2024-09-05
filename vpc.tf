resource "aws_vpc" "CloudOpsBlend" {
  cidr_block           = "10.0.0.0/20"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_route_table" "CloudOpsBlend" {
  vpc_id = aws_vpc.CloudOpsBlend.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.CloudOpsBlend.id
  }
}
resource "aws_route_table_association" "CloudBlendOpsAssociation" {
  count          = length(aws_subnet.CloudOpsBlendSubnet[*].id)
  route_table_id = aws_route_table.CloudOpsBlend.id
  subnet_id      = aws_subnet.CloudOpsBlendSubnet[count.index].id

}

resource "aws_subnet" "CloudOpsBlendSubnet" {
  count                   = length(local.az)
  vpc_id                  = aws_vpc.CloudOpsBlend.id
  cidr_block              = local.az[count.index].block
  availability_zone       = local.az[count.index].az
  map_public_ip_on_launch = true
  depends_on              = [aws_vpc.CloudOpsBlend]
  tags = {
    RDS = local.az[count.index].az == local.rds_preference_az ? "true" : null
  }
}
resource "aws_db_subnet_group" "CloudOpsBlendSubnetGroup" {
  name       = "cloudopsblend_subnet_group"
  subnet_ids = aws_subnet.CloudOpsBlendSubnet[*].id
}

resource "aws_internet_gateway" "CloudOpsBlend" {
  vpc_id = aws_vpc.CloudOpsBlend.id
}
resource "aws_vpc_endpoint" "CloudBlendOpsS3GATEWAY" {
  vpc_id            = aws_vpc.CloudOpsBlend.id
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.CloudOpsBlend.id]
}

resource "aws_security_group" "RdsSecurityGroup" {
  name   = "RdsSecurityGroup"
  vpc_id = aws_vpc.CloudOpsBlend.id
}
resource "aws_security_group_rule" "RdsSecurityGroupAllowMSSQL" {
  protocol          = "tcp"
  type              = "ingress"
  from_port         = 1433
  to_port           = 1433
  cidr_blocks       = ["5.194.28.167/32"]
  security_group_id = aws_security_group.RdsSecurityGroup.id
}
resource "aws_security_group_rule" "RdsSecurityGroupAllowSelfInbound" {
  protocol                 = "tcp"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  source_security_group_id = aws_security_group.RdsSecurityGroup.id
  security_group_id        = aws_security_group.RdsSecurityGroup.id
}

data "aws_subnets" "rds_subnet" {
  filter {
    name   = "tag:RDS"
    values = ["true"]
  }
  depends_on = [aws_subnet.CloudOpsBlendSubnet]
}