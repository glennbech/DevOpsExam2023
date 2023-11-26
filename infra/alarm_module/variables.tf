variable "prefix" {
  type = string
}

variable "latencyThreshold" {
  type = string
  default = "5000"
}

variable "violationsThreshold" {
  type = string
  default = "20"
}

variable "violationsPercentageThreshold" {
  type = string
  default = "15"
}

variable "alarm_email" {
  description = "The email that receives the alarm notification"
}