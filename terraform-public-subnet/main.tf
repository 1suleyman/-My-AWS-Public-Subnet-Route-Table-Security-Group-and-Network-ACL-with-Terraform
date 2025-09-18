# Terraform core configuration (provider, resources)

# 1. Configure AWS Provider

provider "aws" {
  region = var.aws_region
}

# 2. Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = "${var.vpc_cidr_block}"
  tags = {
    Name = "${var.vpc_name}"
  }
}

# 3. Create a Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "${var.subnet_cidr_block}"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.subnet_name}"
  }
}
# 4. Create an Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${var.igw_name}"
  }
}
# 5. Create a Route Table and associate it with the Subnet

resource "aws_route_table" "networking_part2" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.route_table_name}"
  }
}

resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.networking_part2.id
}

# 6. Create a Security Group and rules

resource "aws_security_group" "networking_part2_sg" {
  name        = "${var.security_group_name}"
  description = "A Security Group for the Terraform VPC"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.internet_cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # all traffic
    cidr_blocks = ["${var.internet_cidr_block}"]
  }

  tags = {
    Name = "${var.security_group_name}"
  }
}

# 7. Create a Network ACL, rules and associate it with the Subnet
resource "aws_network_acl" "networking_part2_acl" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    # Port 0 to 65535 covers the entire valid port range.
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    rule_no     = var.network_acl_inbound_rule_number
    action      = var.network_acl_inbound_rule_action
    cidr_block  = var.internet_cidr_block
  }

  egress {
    # Port 0 to 65535 covers the entire valid port range.
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    rule_no     = var.network_acl_outbound_rule_number
    action      = var.network_acl_outbound_rule_action
    cidr_block  = var.internet_cidr_block
  }

  tags = {
    Name = var.network_acl_name
  }
}

# This resource is still needed to associate the ACL with the subnet
resource "aws_network_acl_association" "public_subnet_acl_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  network_acl_id = aws_network_acl.networking_part2_acl.id
}
