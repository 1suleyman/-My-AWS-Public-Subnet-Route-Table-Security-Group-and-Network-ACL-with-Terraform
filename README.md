# 🌐 My AWS Public Subnet, Route Table, Security Group, and Network ACL with Terraform

I decided to fully automate my AWS networking setup using Terraform. This version of the project provisions a **public subnet**, **route table**, **security group**, and **network ACL** — all declaratively. 🖥️☁️

**Part 2 in the networking series** 
Here is the [aws console verion](https://github.com/1suleyman/-AWS-public-subnet-route-table-security-group-and-network-ACL-Hands-On-Lab/tree/main)

---

## 📋 Project Overview

**Terraform Goal:**
Use Terraform to create a public subnet, configure traffic flow with a route table, secure EC2 instances with a security group, and add subnet-level protections using a network ACL.

**Key Benefits of Terraform:**

* Infrastructure is **reproducible** and **version-controlled**
* **Easy to modify or destroy** resources without touching the AWS console
* Makes my **portfolio project fully automated**

---

## 📦 Terraform Project Structure

```text
terraform-public-subnet/
├── main.tf          <-- Terraform configuration for route table, SG, and ACL
├── variables.tf     <-- Input variables (VPC ID, subnet ID, region)
├── outputs.tf       <-- Outputs (route table ID, SG ID, ACL ID)
└── terraform.tfvars <-- Variable values
```

---

## 🛠 Terraform Steps I Followed

### Step 1: Configure Terraform Provider

I set up the AWS provider in `main.tf`:

```hcl
provider "aws" {
  region = var.aws_region
}
```

This tells Terraform which AWS account and region to use.

---

### Step 2: Create Route Table & Associate with Subnet

```hcl
resource "aws_route_table" "networking_part2" {
  vpc_id = var.vpc_id

  tags = {
    Name = "Networking series part 2 Route Table"
  }
}

resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = var.public_subnet_id
  route_table_id = aws_route_table.networking_part2.id
}
```

**What this does:**

* Creates a route table attached to my VPC
* Associates the route table with my **Public 1 subnet**
* (Optional) I can add a default route to an Internet Gateway if I want public internet access

💡 **Tip:** Route tables direct traffic **inside and outside** the VPC.

---

### Step 3: Create Security Group

```hcl
resource "aws_security_group" "networking_part2_sg" {
  name        = "Networking series part 2 Security Group"
  description = "A Security Group for the Suleyman VPC"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # all traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Networking series part 2 Security Group"
  }
}
```

**Explanation:**

* Inbound: allows HTTP from anywhere
* Outbound: allows **all traffic**
* Security groups act as **firewalls for EC2 instances**

💡 **Tip:** Security groups are **resource-level protection**.

---

### Step 4: Create Network ACL

```hcl
resource "aws_network_acl" "networking_part2_acl" {
  vpc_id = var.vpc_id
  tags = {
    Name = "Networking series part 2 ACL"
  }
}

resource "aws_network_acl_rule" "inbound_allow_all" {
  network_acl_id = aws_network_acl.networking_part2_acl.id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "outbound_allow_all" {
  network_acl_id = aws_network_acl.networking_part2_acl.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_subnet_network_acl_association" "public_subnet_acl_assoc" {
  subnet_id      = var.public_subnet_id
  network_acl_id = aws_network_acl.networking_part2_acl.id
}
```

**Explanation:**

* Inbound & outbound: allow all traffic
* ACL protects **entire subnet**, adding a second layer of security
* Must be associated with a subnet for rules to take effect

💡 **Tip:** Security groups = EC2-level protection, ACLs = subnet-level protection.

---

## ✅ How I Deployed

* Ran `terraform init` to initialize the working directory
* Ran `terraform plan` to preview changes
* Ran `terraform apply` to create route table, SG, and ACL
* Verified resources in AWS Console

💡 **Mistakes I fixed:** Initially forgot to associate the ACL with the subnet, which made inbound/outbound rules ineffective.

---

## 📌 Project Summary

| Step                  | Status | Key Notes                                            |
| --------------------- | ------ | ---------------------------------------------------- |
| Create Route Table    | ✅      | Associated with Public 1 subnet                      |
| Create Security Group | ✅      | HTTP allowed; all outbound allowed                   |
| Create Network ACL    | ✅      | Inbound & outbound allow all; associated with subnet |

---

## 💡 Notes / Tips

* **Terraform is idempotent:** Running `apply` multiple times won’t break existing resources
* **Security Groups vs. ACLs:** SG = resource-level, ACL = subnet-level
* **Subnet Associations:** ACL rules only work when associated with a subnet
* **Testing:** Launch an EC2 instance in the Public 1 subnet and attach SG to test HTTP

---

## 📸 Screenshots

* Route table created and associated

<img width="367" height="34" alt="Screenshot 2025-09-18 at 10 20 18" src="https://github.com/user-attachments/assets/52389d63-fd23-4a42-a39b-e62652bb0e57" />

<img width="262" height="132" alt="Screenshot 2025-09-18 at 10 20 41" src="https://github.com/user-attachments/assets/de856337-c7f6-4af1-b57d-80bbd2ca2c41" />

* Security group rules

<img width="382" height="31" alt="Screenshot 2025-09-18 at 10 21 18" src="https://github.com/user-attachments/assets/2b03b45c-35ef-4616-a93e-73eb03476872" />
  
* Network ACL rules and subnet association

<img width="454" height="47" alt="Screenshot 2025-09-18 at 10 27 09" src="https://github.com/user-attachments/assets/b827b798-e199-4b8a-bebe-92217a2a21d8" />

<img width="1013" height="172" alt="Screenshot 2025-09-18 at 10 27 22" src="https://github.com/user-attachments/assets/88464589-aa5b-4e0b-b46d-7bb0f0fb141f" />

<img width="1017" height="167" alt="Screenshot 2025-09-18 at 10 27 49" src="https://github.com/user-attachments/assets/dd6c9d24-fc4f-4b3d-b8a4-c2e26fc3b435" />

<img width="228" height="128" alt="Screenshot 2025-09-18 at 10 28 04" src="https://github.com/user-attachments/assets/86c798cc-0b94-4eab-b114-1d1b59025943" />

---

## ✅ References

* [Amazon VPC Documentation](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)
* [Network ACLs](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html)
* [Security Groups](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html)

Got it! Here’s your README reformatted so **all the Terraform code sections are replaced with links** to the actual files, keeping the first-person narrative and lab flow intact:

---

# 🌐 My AWS Public Subnet, Route Table, Security Group, and Network ACL with Terraform

I decided to fully automate my AWS networking setup using Terraform. This project provisions a **public subnet**, **route table**, **security group**, and **network ACL** — all declaratively. 🖥️☁️

**Part 2 in my networking series**
Here is the [AWS Console version](https://github.com/1suleyman/-AWS-public-subnet-route-table-security-group-and-network-ACL-Hands-On-Lab/tree/main)

---

## 📋 Project Overview

**Terraform Goal:**
Use Terraform to create a public subnet, configure traffic flow with a route table, secure EC2 instances with a security group, and add subnet-level protections using a network ACL.

**Key Benefits of Terraform:**

* Infrastructure is **reproducible** and **version-controlled**
* **Easy to modify or destroy** resources without touching the AWS console
* Makes my **portfolio project fully automated**

---

## 📦 Terraform Project Structure

```text
terraform-public-subnet/
├── main.tf          <-- Terraform configuration for route table, SG, and ACL
├── variables.tf     <-- Input variables (VPC ID, subnet ID, region)
├── outputs.tf       <-- Outputs (route table ID, SG ID, ACL ID)
└── terraform.tfvars <-- Variable values
```

You can view the **Terraform files here**:

* [main.tf](https://github.com/1suleyman/-AWS-public-subnet-route-table-security-group-and-network-ACL-Hands-On-Lab/blob/main/main.tf)
* [variables.tf](https://github.com/1suleyman/-AWS-public-subnet-route-table-security-group-and-network-ACL-Hands-On-Lab/blob/main/variables.tf)
* [outputs.tf](https://github.com/1suleyman/-AWS-public-subnet-route-table-security-group-and-network-ACL-Hands-On-Lab/blob/main/outputs.tf)
* [terraform.tfvars](https://github.com/1suleyman/-AWS-public-subnet-route-table-security-group-and-network-ACL-Hands-On-Lab/blob/main/terraform.tfvars)

---

## 🛠 Terraform Steps I Followed

### Step 1: Configure Terraform Provider

I set up the AWS provider by editing the provider block in `main.tf`.
This tells Terraform which AWS account and region to use.

[View main.tf provider section](https://github.com/1suleyman/-AWS-public-subnet-route-table-security-group-and-network-ACL-Hands-On-Lab/blob/main/main.tf)

---

### Step 2: Create Route Table & Associate with Subnet

I created a route table and associated it with my Public 1 subnet to control traffic flow.

[View route table section](https://github.com/1suleyman/-AWS-public-subnet-route-table-security-group-and-network-ACL-Hands-On-Lab/blob/main/main.tf#L7)

💡 **Tip:** Route tables direct traffic **inside and outside** the VPC.

---

### Step 3: Create Security Group

I created a security group for my EC2 instances in the VPC, allowing HTTP inbound traffic and all outbound traffic.

[View security group section](https://github.com/1suleyman/-AWS-public-subnet-route-table-security-group-and-network-ACL-Hands-On-Lab/blob/main/main.tf#L19)

💡 **Tip:** Security groups provide **resource-level protection**.

---

### Step 4: Create Network ACL

I added a network ACL to provide an additional layer of security at the subnet level.

[View network ACL section](https://github.com/1suleyman/-AWS-public-subnet-route-table-security-group-and-network-ACL-Hands-On-Lab/blob/main/main.tf#L40)

💡 **Tip:** ACLs act at the **subnet level**, while security groups act at the **resource level**.

✅ **Checkpoint:** ACL created and associated with my Public 1 subnet.

---

## ✅ How I Deployed

* Ran `terraform init` to initialize the working directory
* Ran `terraform plan` to preview changes
* Ran `terraform apply` to create route table, SG, and ACL
* Verified resources in the AWS Console

💡 **Mistakes I fixed:** Initially forgot to associate the ACL with the subnet, which made inbound/outbound rules ineffective.

---

## 📌 Project Summary

| Step                  | Status | Key Notes                                            |
| --------------------- | ------ | ---------------------------------------------------- |
| Create Route Table    | ✅      | Associated with Public 1 subnet                      |
| Create Security Group | ✅      | HTTP allowed; all outbound allowed                   |
| Create Network ACL    | ✅      | Inbound & outbound allow all; associated with subnet |

---

## 💡 Notes / Tips

* **Terraform is idempotent:** Running `apply` multiple times won’t break existing resources
* **Security Groups vs. ACLs:** SG = resource-level; ACL = subnet-level
* **Subnet Associations:** ACL rules only work when associated with a subnet

---

## 📸 Screenshots

* Route table created and associated

<img width="367" height="34" alt="Screenshot 2025-09-18 at 10 20 18" src="https://github.com/user-attachments/assets/52389d63-fd23-4a42-a39b-e62652bb0e57" />

<img width="262" height="132" alt="Screenshot 2025-09-18 at 10 20 41" src="https://github.com/user-attachments/assets/de856337-c7f6-4af1-b57d-80bbd2ca2c41" />

* Security group rules

<img width="382" height="31" alt="Screenshot 2025-09-18 at 10 21 18" src="https://github.com/user-attachments/assets/2b03b45c-35ef-4616-a93e-73eb03476872" />
  
* Network ACL rules and subnet association

<img width="454" height="47" alt="Screenshot 2025-09-18 at 10 27 09" src="https://github.com/user-attachments/assets/b827b798-e199-4b8a-bebe-92217a2a21d8" />

<img width="1013" height="172" alt="Screenshot 2025-09-18 at 10 27 22" src="https://github.com/user-attachments/assets/88464589-aa5b-4e0b-b46d-7bb0f0fb141f" />

<img width="1017" height="167" alt="Screenshot 2025-09-18 at 10 27 49" src="https://github.com/user-attachments/assets/dd6c9d24-fc4f-4b3d-b8a4-c2e26fc3b435" />

<img width="228" height="128" alt="Screenshot 2025-09-18 at 10 28 04" src="https://github.com/user-attachments/assets/86c798cc-0b94-4eab-b114-1d1b59025943" />

---

## ✅ References

* [Amazon VPC Documentation](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)
* [Network ACLs](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html)
* [Security Groups](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html)
