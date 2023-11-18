resource "aws_cloudwatch_metric_alarm" "threshold" {
  alarm_name     = "${var.prefix}-threshold"
  namespace = var.prefix
  metric_name = "latency_noMask.max"
  dimensions = {
    class = "com.example.s3rekognition.controller.RekognitionController"
    exception = "none"
    method = "scanForPPE"
  }

  comparison_operator = "GreaterThanThreshold"
  threshold = var.threshold
  evaluation_periods = "2"
  period = "60"
  extended_statistic = "p90"

  alarm_description = "This alarm goes of, when a call at the 90th percentile exceeds the threshold"
  alarm_actions = [aws_sns_topic.user_updates.arn]
}

resource "aws_sns_topic" "user_updates" {
  name = "${var.prefix}-alarm-topic"
}

resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.user_updates.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}
