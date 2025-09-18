# region
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-west-2"
}

# VPC and Subnet configuration

# VPC CIDR block
variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

# VPC Name
variable "vpc_name" {
  default = "Terraform VPC"
}
# Subnet CIDR block
variable "subnet_cidr_block" {
  default = "10.0.0.0/24"
}
# Subnet Name
variable "subnet_name" {
  default = "Terraform Public Subnet 1"
}

# Internet Gateway and Route Table configuration

# Internet Gateway Name
variable "igw_name" {
  default = "Terraform IG"
}
# Route table Name
variable "route_table_name" {
  default = "Terraform Networking series part 2 Route Table"
}
# Security Group Name
variable "security_group_name" {
  default = "Terraform Networking series part 2 Security Group"
}
# internet cidr block
variable "internet_cidr_block" {
  default = "0.0.0.0/0"
}

# Network ACL configuration

# Network ACL Name
variable "network_acl_name" {
  default = "Terraform Networking series part 2 ACL"
}
# Network ACL Inbound Rule Number
variable "network_acl_inbound_rule_number" {
  default = 100
}
# Network ACL Outbound Rule Number
variable "network_acl_outbound_rule_number" {
  default = 100
}
# Network ACL Inbound Rule action
variable "network_acl_inbound_rule_action" {
  default = "allow"
}
# Network ACL Outbound Rule action
variable "network_acl_outbound_rule_action" {
  default = "allow"
}
