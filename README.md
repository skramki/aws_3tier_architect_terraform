# AWS 3 Tier Architecture provisioning using Terraform

The three-tier architecture is the most popular implementation of a multi-tier architecture and consists of a single presentation tier, logic tier, and data tier.

This is most common use case for Software projects to be started quickly


### Resources need to be created / installed :

1) Custom VPC 

2) 2 Subnets (Public)

3) 1 Subnet (Private)

4) 2 EC2 Instances

5) Security Group

6) Elastic IP

7) NAT Gateway

8) Internet Gateway

9) Route Table

10) Application Load Balancer

11) Apache Webserver

12) MySQL DB

In order to kick start this Project enable AWS credential by below 2 methods:
1) How to export AWS Credential manually:

    export TF_VAR_access_key="your_access_key_here in terminal";
   
    export TF_VAR_secret_key="your_secret_key_here in terminal" 

       Then, declare global variable in variables.tf file as below
      ## variable "secret_key" {}
      ## variable "access_key" {}

3) AWS Credential inputs dynamic variable retival:
   Create terraform.tfvars file and keyin most common global variable for one time setup
   
      aws_region = "ap-southeast-1";
      access_key = "your_access_key_here";
      secret_key = "your_secret_key_here";

    Then, declare global variable in variables.tf file as below
    ## variable "secret_key" {}
    ## variable "access_key" {}


Next it's good to deploy AWS 3 tier Terraform code using below commands

terraform init

terraform plan

terraform apply