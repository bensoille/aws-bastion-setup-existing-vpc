Packer goss provisioner must be installed : https://github.com/YaleUniversity/packer-provisioner-goss


## How to run
```shell
packer build \
    -var "aws_vpc_id=${VPCID}" \
    -var "aws_subnet_id=${subnetID}" \
    -var "playbook_file=../ansible/bastion.yml" \
    -var "goss_path=../goss" \
    -var "goss_file=bastion.yaml" \
    bastion.json
```
