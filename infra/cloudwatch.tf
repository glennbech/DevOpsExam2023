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
            {
              "${var.dashboard_name}",
              "violations.value",
              {"type": "noMask"}
            },
            {
              "${var.dashboard_name}",
              "violations.value",
              {"type": "noHelmet"}
            },
            {
              "${var.dashboard_name}",
              "violations",
              {"type": "noMaskOrGlove"}
            }
          ],
          "period": 300,
          "stat": "Maximum",
          "region": "eu-west-1",
          "title": "Total number of violations"
        }
      }
    ]
  }
  DASHBOARD
}

