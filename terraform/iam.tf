module "bastion_role" {
  source        = "./modules/iam/ec2_iam_role"
  name          = "bastion-host-role"
  policy_arn    = [
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
  ]
}