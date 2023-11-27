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
  threshold = var.latencyThreshold
  evaluation_periods = "2"
  period = "120"
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
  threshold = var.latencyThreshold
  evaluation_periods = "2"
  period = "120"
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
  threshold = var.latencyThreshold
  evaluation_periods = "2"
  period = "120"
  extended_statistic = "p90"

  alarm_description = "This alarm goes of, when a call at /scan-full-ppe at the 90th percentile exceeds the threshold"
  alarm_actions = [aws_sns_topic.user_updates.arn]
}

resource "aws_cloudwatch_metric_alarm" "ToManyPPEViolations" {
  alarm_name     = "${var.prefix}-ViolationsThreshold"
  namespace = var.prefix
  metric_name = "violations_total.count"

  comparison_operator = "GreaterThanThreshold"
  threshold = var.violationsThreshold
  evaluation_periods = "2"
  period = "60"
  statistic = "Sum"

  alarm_description = "This alarm goes off when too many violate standard PPE"
  alarm_actions = [aws_sns_topic.user_updates.arn]
}

resource "aws_cloudwatch_metric_alarm" "ToManyPPEPercentageViolations" {
  alarm_name     = "${var.prefix}-ViolationsPercentageThreshold"
  namespace = var.prefix
  metric_name = "violations_noMask_percentage.value"

  comparison_operator = "GreaterThanThreshold"
  threshold = var.violationsPercentageThreshold
  evaluation_periods = "2"
  period = "60"
  statistic = "Maximum"

  alarm_description = "This alarm goes off when too high a percent of people violate standard PPE"
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
