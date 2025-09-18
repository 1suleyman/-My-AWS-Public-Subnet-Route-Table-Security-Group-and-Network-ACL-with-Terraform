# 🌐 My AWS Public Subnet, Route Table, Security Group, and Network ACL with Terraform

I decided to fully automate my AWS networking setup using Terraform. This project provisions a **public subnet**, **route table**, **security group**, and **network ACL** — all declaratively. 🖥️☁️

This project is a Terraform-powered version of my hands-on [AWS Public Subnet, Route Table, Security Group, and Network ACL Hands-On Lab](https://github.com/1suleyman/-AWS-public-subnet-route-table-security-group-and-network-ACL-Hands-On-Lab/tree/main), fully codified for repeatable deployments.

**Part 2 in my networking series**

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

* [main.tf](https://github.com/1suleyman/-My-AWS-Public-Subnet-Route-Table-Security-Group-and-Network-ACL-with-Terraform/blob/main/terraform-public-subnet/main.tf)
* [variables.tf](https://github.com/1suleyman/-My-AWS-Public-Subnet-Route-Table-Security-Group-and-Network-ACL-with-Terraform/blob/main/terraform-public-subnet/variable.tf)

---

## 🛠 Terraform Steps I Followed

### Step 1: Configure Terraform Provider

I set up the AWS provider by editing the provider block in `main.tf`.
This tells Terraform which AWS account and region to use.

[View main.tf provider section](https://github.com/1suleyman/-My-AWS-Public-Subnet-Route-Table-Security-Group-and-Network-ACL-with-Terraform/blob/main/terraform-public-subnet/main.tf)

---

### Step 2: Create Route Table & Associate with Subnet

I created a route table and associated it with my Public 1 subnet to control traffic flow.

[View route table section](https://github.com/1suleyman/-My-AWS-Public-Subnet-Route-Table-Security-Group-and-Network-ACL-with-Terraform/blob/main/terraform-public-subnet/main.tf)

💡 **Tip:** Route tables direct traffic **inside and outside** the VPC.

---

### Step 3: Create Security Group

I created a security group for my EC2 instances in the VPC, allowing HTTP inbound traffic and all outbound traffic.

[View security group section](https://github.com/1suleyman/-My-AWS-Public-Subnet-Route-Table-Security-Group-and-Network-ACL-with-Terraform/blob/main/terraform-public-subnet/main.tf)

💡 **Tip:** Security groups provide **resource-level protection**.

---

### Step 4: Create Network ACL

I added a network ACL to provide an additional layer of security at the subnet level.

[View network ACL section](https://github.com/1suleyman/-My-AWS-Public-Subnet-Route-Table-Security-Group-and-Network-ACL-with-Terraform/blob/main/terraform-public-subnet/main.tf)

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
