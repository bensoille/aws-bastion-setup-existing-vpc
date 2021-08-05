variable "aws_region"                  {default = "us-east-1"}
variable "vpc_id"                      {default = "vpc-89fd88f4"}
variable "ssh_key_name"                {default = "ben"}
variable "bastion_subnet_1"            {default = "subnet-2f5f0749"}
variable "bastion_subnet_2"            {default = "subnet-c4d8ffe5"}

variable "default_tags" {
  type = map(string)
  default = {
    Owner   = "ben.soille@gmail.com"
  }
}