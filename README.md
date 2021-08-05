# Setup bastion host in AWS existing VPC
Given an existing AWS VPC, this IaC repository allows for ssh bastion host creation and deployment. Deployment happens in given AWS VPC.

## Prerequisites
An AWS account with a VPC, to setup bastion host in :
- IAM user with correct permissions (Access key ID, secret key in ~/.aws/credentials)
- some created *keypair* with convenient type
- the VPC ID in which to deploy bastion host

Some tooling is used through tis repository
- awscli *2.2.26*
- ansible *2.9.6*
- terraform *0.12.28*
- packer *1.7.4* with [goss plugin installed](https://github.com/YaleUniversity/packer-provisioner-goss)
- git *2.25.1*

## Quick start

### One command fits all
Run `scenario.sh` script and setup everything at once :     

**./scenario.sh \<VPC ID\> \<subnet ID\> \<region\> \<keypair name\>**     
With :
- *VPC ID* : the existing VPC to deploy to
- *subnet ID* : the existing VPC's subnet to deploy to
- *region* : the AWS region to deploy to
- *keypair name* : the name of existing keypair to use for connection

Example :
```shell
./scenario.sh 'vpc-89fd88f4' 'subnet-2f5f0749' 'us-east-1' 'ben'
```
### ssh service monitoring
In addition, a `ssh-bastion-down` *Cloudwatch* alarm is set up. This alarm is based on `ssh-status` data source, which is fed by a cron script installed on bastion host.

## How to
> These steps are done by `scenario.sh` and explained only for convenience

1. Create bastion host AMI using packer (specify your VPC and subnet IDs.)
```shell
#     _    __  __ ___                       _   _             
#    / \  |  \/  |_ _|   ___ _ __ ___  __ _| |_(_) ___  _ __  
#   / _ \ | |\/| || |   / __| '__/ _ \/ _` | __| |/ _ \| '_ \ 
#  / ___ \| |  | || |  | (__| | |  __/ (_| | |_| | (_) | | | |
# /_/   \_\_|  |_|___|  \___|_|  \___|\__,_|\__|_|\___/|_| |_|

cd packer/
# First validate packer file
packer validate bastion.json

# Then build AMI at AWS
packer build \
    -var "aws_vpc_id=${VPCID}" \
    -var "aws_subnet_id=${subnetID}" \
    -var "playbook_file=../ansible/bastion.yml" \
    -var "goss_path=../goss" \
    -var "goss_file=bastion.yaml" \
    bastion.json

cd -
```
*Estimated needed time : 7m*

2. Provision AWS infrastructure with terraform (specify AMI id created by packer)    
```shell
#  ____            _   _                   _            _             
# | __ )  __ _ ___| |_(_) ___  _ __     __| | ___ _ __ | | ___  _   _ 
# |  _ \ / _` / __| __| |/ _ \| '_ \   / _` |/ _ \ '_ \| |/ _ \| | | |
# | |_) | (_| \__ \ |_| | (_) | | | | | (_| |  __/ |_) | | (_) | |_| |
# |____/ \__,_|___/\__|_|\___/|_| |_|  \__,_|\___| .__/|_|\___/ \__, |
#                                                |_|            |___/ 

cd terraform
# First init terraform and eventually install modules
terraform init
# Then deploy bastion AMI instance
terraform apply \
    -var aws_region=${region} \
    -var vpc_id=${VPCID} \
    -var ssh_key_name=${keypair_name} \
    -var bastion_subnet_1=${subnetID}

cd -  
```
*Estimated needed time : 10m*

3. Log in
Get your bastion instance public IP address and use the private key of existing keypair :
```shell
ssh -i ~/Téléchargements/ben.pem ubuntu@3.236.161.192
```

## Destroy resources
### Bastion host
```shell
terraform destroy
```
### AMI
Deregister AMI in AWS console