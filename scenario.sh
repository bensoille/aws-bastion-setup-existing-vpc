#!/bin/bash

# Ben Soille <ben.soille@gmail.com>
#
# Sets up and starts bastion host in given VPC
#

set -eu

if [[ $# -ne 4 ]]; then
    echo "Usage: $0 <VPC ID> <subnet ID> <region> <keypair name>" 
    exit 1
fi

VPCID=$1
subnetID=$2
region=$3
keypair_name=$4

#     _    __  __ ___                       _   _             
#    / \  |  \/  |_ _|   ___ _ __ ___  __ _| |_(_) ___  _ __  
#   / _ \ | |\/| || |   / __| '__/ _ \/ _` | __| |/ _ \| '_ \ 
#  / ___ \| |  | || |  | (__| | |  __/ (_| | |_| | (_) | | | |
# /_/   \_\_|  |_|___|  \___|_|  \___|\__,_|\__|_|\___/|_| |_|

cd packer/
# First validate packer file
packer validate bastion.json

# Then build
packer build \
    -var "aws_vpc_id=${VPCID}" \
    -var "aws_subnet_id=${subnetID}" \
    -var "playbook_file=../ansible/bastion.yml" \
    -var "goss_path=../goss" \
    -var "goss_file=bastion.yaml" \
    bastion.json

cd -

#  ____            _   _                   _            _             
# | __ )  __ _ ___| |_(_) ___  _ __     __| | ___ _ __ | | ___  _   _ 
# |  _ \ / _` / __| __| |/ _ \| '_ \   / _` |/ _ \ '_ \| |/ _ \| | | |
# | |_) | (_| \__ \ |_| | (_) | | | | | (_| |  __/ |_) | | (_) | |_| |
# |____/ \__,_|___/\__|_|\___/|_| |_|  \__,_|\___| .__/|_|\___/ \__, |
#                                                |_|            |___/ 

cd terraform
terraform init
terraform apply -auto-approve \
    -var aws_region=${region} \
    -var vpc_id=${VPCID} \
    -var ssh_key_name=${keypair_name} \
    -var bastion_subnet_1=${subnetID}

cd -