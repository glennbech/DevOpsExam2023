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
        "x": 0,
        "y": 0,
        "width": 12,
        "height": 6,
        "properties": {
          "metrics": [
            [
              "${var.dashboard_name}",
              "latency_noMask.sum"
            ],
            [
              "${var.dashboard_name}",
              "latency_noHelmet.sum"
            ],
            [
              "${var.dashboard_name}",
              "latency_noMaskOrGlove.sum"
            ]
          ],
          "period": 300,
          "stat": "p90",
          "region": "eu-west-1",
          "title": "Method Latency"
        }
      }
    ]
  }
  DASHBOARD
}

