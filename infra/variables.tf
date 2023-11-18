
variable "access_role" {
  description = "The ARN of the access role for authentication"
  type = string
}
# Default: arn:aws:iam::244530008913:role/service-role/AppRunnerECRAccessRole

variable "image" {
  description = "The identifier or name of the Docker image in the Amazon Elastic Container Registry (ECR)."
  type = string
}
# Default: 244530008913.dkr.ecr.eu-west-1.amazonaws.com/mama014-private:latest

variable "policy_name" {
  description = "The name for the IAM policy that grants necessary permissions for AppRunner instances to interact with AWS resources."
  type = string
}
# Default: 2011-apr-policy

variable "port" {
  description = "The port to use for the AppRunner service"
  type = string
}
# Default: 8080

variable "role_name" {
  description = "The name of the IAM role for the AppRunner service"
  type = string
}
# Default: Kandidat2011Sim

variable "service_name" {
  description = "The name of the AppRunner service"
  type = string
}
# Default: Kandidat2011Service

variable "dashboard_name" {
  description = "The name of the used CloudWatch Dashobard"
  type = string
}
# Default: kandidat2011simp

variable "alarm_email" {
  type = string
}
# Default: marcus1sp2@gmail.com
