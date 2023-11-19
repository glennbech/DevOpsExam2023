resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = var.dashboard_name
  dashboard_body = <<DASHBOARD
  {
    "widgets": [
      {
        "type": "metric",
        "x": 0,
        "y": 0,
        "width": 12,
        "height": 6,
        "properties": {
          "metrics": [
            [
              "${var.dashboard_name}",
              "violations_total.count"
            ],
            [
              "${var.dashboard_name}",
              "violations_noMask.count"
            ],
            [
              "${var.dashboard_name}",
              "violations_noHelmet.count"
            ],
            [
              "${var.dashboard_name}",
              "violations_noMaskOrGlove.count"
            ]
          ],
          "period": 300,
          "stat": "Sum",
          "region": "eu-west-1",
          "title": "Total number of violations"
        }
      },
      {
        "type": "metric",
        "x": 12,
        "y": 0,
        "width": 6,
        "height": 6,
        "properties": {
          "metrics": [
            [
              "${var.dashboard_name}",
              "percentage.value"
            ]
          ],
          "view": "gauge",
          "yAxis":{
             "left":{
                "min":0,
                "max":100
             }
          },
          "period": 300,
          "stat": "Maximum",
          "region": "eu-west-1",
          "title": "Average Percentage of Violations"
        }
      },
      {
        "type": "metric",
        "x": 0,
        "y": 6,
        "width": 12,
        "height": 6,
        "properties": {
          "metrics": [
            [
              "${var.dashboard_name}",
              "latency_noMask.avg",
              "exception",
              "none",
              "method",
              "scanForPPE",
              "class",
              "com.example.s3rekognition.controller.RekognitionController"
            ],
            [
              "${var.dashboard_name}",
              "latency_noHelmet.avg",
              "exception",
              "none",
              "method",
              "scanForHeadCover",
              "class",
              "com.example.s3rekognition.controller.RekognitionController"
            ],
            [
              "${var.dashboard_name}",
              "latency_noMaskOrGlove.avg",
              "exception",
              "none",
              "method",
              "scanForFullPPE",
              "class",
              "com.example.s3rekognition.controller.RekognitionController"
            ]
          ],
          "period": 300,
          "stat": "Average",
          "region": "eu-west-1",
          "title": "Method Latency"
        }
      },
      {
        "type": "metric",
        "x": 18,
        "y": 6,
        "width": 6,
        "height": 6,
        "properties": {
          "metrics": [
            [
              "${var.dashboard_name}",
              "people_count.value"
            ]
          ],
          "view": "gauge",
          "yAxis":{
             "left":{
                "min":0,
                "max":100
             }
          },
          "period": 300,
          "stat": "Maximum",
          "region": "eu-west-1",
          "title": "People in the building"
        }
      }
    ]
  }
  DASHBOARD
}

module "alarm" {
  source = "./alarm_module"
  alarm_email = var.alarm_email
  prefix = var.dashboard_name
  latencyThreshold = var.latencyThreshold
  violationsThreshold = var.violationThreshold
}
