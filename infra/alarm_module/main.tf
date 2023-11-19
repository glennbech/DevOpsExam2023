resource "aws_cloudwatch_metric_alarm" "NoMaskLatencyHigh" {
  alarm_name     = "${var.prefix}-NoMaskLatency"
  namespace = var.prefix
  metric_name = "latency_noMask.avg"
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

  alarm_description = "This alarm goes of, when a call at /scan-ppe at the 90th percentile exceeds the threshold"
  alarm_actions = [aws_sns_topic.user_updates.arn]
}

resource "aws_cloudwatch_metric_alarm" "NoHelmetLatencyHigh" {
  alarm_name     = "${var.prefix}-NoHelmetLatency"
  namespace = var.prefix
  metric_name = "latency_noHelmet.avg"
  dimensions = {
    class = "com.example.s3rekognition.controller.RekognitionController"
    exception = "none"
    method = "scanForHeadCover"
  }

  comparison_operator = "GreaterThanThreshold"
  threshold = var.threshold
  evaluation_periods = "2"
  period = "60"
  extended_statistic = "p90"

  alarm_description = "This alarm goes of, when a call at /scan-construction at the 90th percentile exceeds the threshold"
  alarm_actions = [aws_sns_topic.user_updates.arn]
}

resource "aws_cloudwatch_metric_alarm" "NoMaskOrGloveLatencyHigh" {
  alarm_name     = "${var.prefix}-NoMaskOrGloveLatency"
  namespace = var.prefix
  metric_name = "latency_noMaskOrGlove.avg"
  dimensions = {
    class = "com.example.s3rekognition.controller.RekognitionController"
    exception = "none"
    method = "scanForFullPPE"
  }

  comparison_operator = "GreaterThanThreshold"
  threshold = var.threshold
  evaluation_periods = "2"
  period = "60"
  extended_statistic = "p90"

  alarm_description = "This alarm goes of, when a call at /scan-full-ppe at the 90th percentile exceeds the threshold"
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
