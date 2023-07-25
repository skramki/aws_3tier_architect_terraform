# AWS 3 Tier Architecture provisioning using Terraform

The three-tier architecture is the most popular implementation of a multi-tier architecture and consists of a single presentation tier, logic tier, and data tier.

This is most common use case for Software projects to be started quickly


### Resources need to be created / installed :

1) Custom VPC 

* 2 Subnets (Public)

* 1 Subnet (Private)

* 2 EC2 Instances

* Security Group

* Elastic IP

* NAT Gateway

* Internet Gateway

* Route Table

* Application Load Balancer

* Apache Webserver

* MySQL DB

## Create main.cf
3-tier-app/
├── main.tf
├── variables.tf
├── outputs.tf
├── frontend/
│   ├── main.tf
│   └── variables.tf
├── backend/
│   ├── main.tf
│   └── variables.tf
├── database/
│   ├── main.tf
│   └── variables.tf
└── terraform.tfvars

##export TF_VAR_secret_key="your_secret_key_here"
##variable "secret_key" {}

