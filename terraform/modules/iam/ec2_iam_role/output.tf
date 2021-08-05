output "arn" {
  description = "ARN of IAM Role"
  value       = "${aws_iam_role.this.arn}"
}

output "unique_id" {
  description = "ARN Unique ID of IAM Role"
  value       = "${aws_iam_role.this.unique_id}"
}

output "profile_name" {
  description = "Instance profile Name"
  value       = "${aws_iam_instance_profile.this.name}"
}

output "profile_arn" {
  description = "Instance profile ARN"
  value       = "${aws_iam_instance_profile.this.arn}"
}