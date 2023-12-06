# EKS infrastructure by Terraform
This repository includes the required Terraform files to provision following components,
- Single node group EKS cluster 
- AWS Load Balancer Controller
- ArgoCD server exposed by AWS Application Load Balancer

# terraform versions tested
- Terraform v1.5.7
- provider aws v5.23.1
- provider cloudinit v2.3.2
- provider external v2.3.1
- provider helm v2.11.0
- provider kubernetes v2.23.0
- provider null v3.2.1
- provider time v0.9.1
- provider tls v4.0.4

# Usage
1. Clone this repository
2. `cd` to the repository folder
3. Initialize terraform dependencies by,
```
terraform init
```
4. Get the list of resources being created by,
```
terraform plan
```
5. Create the planned resources by,
```
terraform apply
```