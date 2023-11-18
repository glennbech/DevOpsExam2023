variable "prefix" {
  type = string
}

variable "threshold" {
  type = string
  default = "5000"
}

variable "alarm_email" {
  description = "The email that receives the alarm notification"
  default = "marcus1sp2@gmail.com"
}