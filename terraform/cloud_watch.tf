resource "aws_cloudwatch_metric_alarm" "bastion_ssh_down" {
  alarm_name          = "bastion-ssh-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "ssh-status"
  namespace           = "Custom"
  period              = "60"
  statistic           = "Average"
  threshold           = "0"
  alarm_description   = "This metric monitors ssh service of bastion host"
}