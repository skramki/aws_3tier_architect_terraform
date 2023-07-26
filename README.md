# 3-Tier Architecture AWS EC2 provisioning using Terraform

![Alt text](https://github.com/skramki/aws_3tier_architect_terraform/blob/40ff6850aa4760b924c205ecccaa0efa850c780d/3Tier%20Architect%20Overview.png)

This is most common use case for Software projects to be started quickly

![Alt text](https://github.com/skramki/aws_3tier_architect_terraform/blob/3a3f51128b59624cffa3e8ce6d9932eddcc35d54/3Tier%20AWS-EC2%20Architecture%20Provisioning-TF-.png)

### Resources need to be created / installed:

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
