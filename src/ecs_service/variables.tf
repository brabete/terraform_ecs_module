variable "service_name" {
  type        = "string"
  description = "Name of the service"
}

variable "environment" {
  type        = "string"
  description = "Logical environment"
}

variable "alb_deletion_protection" {
  default     = true
  description = "Enable ALB termination protection"
}

variable "service_port" {
  default     = 80
  description = "The port on which targets receive traffic, unless overridden when registering a specific target"
}

variable "service_protocol" {
  default     = "HTTP"
  description = "The protocol to use for routing traffic to the targets"
}

variable "service_deregistration_delay" {
  default     = 300
  description = "The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused"
}

variable "aws_region" {
  type        = "string"
  description = "AWS region"
}

variable "vpc_id" {
  type        = "string"
  description = "VPC ID"
}

variable "subnets" {
  type        = "list"
  description = "Subnets, where ALB is placed"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Tags for resources"
}

variable "internal" {
  default     = true
  description = "Internal or external service"
}

variable "stickiness_enabled" {
  default = false
}

variable "stickiness_type" {
  default = "lb_cookie"
}

variable "stickiness_cookie_duration" {
  default = 86400
}

variable "health_check_interval" {
  default = 30
}

variable "health_check_path" {
  default = "/ping"
}

variable "health_check_port" {
  default = "traffic-port"
}

variable "health_check_protocol" {
  default = "HTTP"
}

variable "health_check_healthy_threshold" {
  default = 5
}

variable "health_check_unhealthy_threshold" {
  default = 2
}

variable "health_check_matcher" {
  default = "200"
}

variable "health_check_timeout" {
  default     = 15
  description = "Timout for healthcheck"
}

variable "alb_logs_s3_bucket" {
  default     = ""
  description = "S3 bucket for ALB logs"
}

variable "alb_logs_s3_prefix" {
  default     = ""
  description = "S3 ALB logs prefix"
}

variable "alb_logs_s3_enabled" {
  default     = true
  description = "Enable ALB logging to S3 bucket"
}

variable "alb_security_groups" {
  type        = "list"
  description = "Additional security groups"
}

variable "private_zone_id" {
  type        = "string"
  description = "AWS Route53 private zone ID"
  default     = ""
}

variable "public_zone_id" {
  type        = "string"
  description = "AWS Route53 public zone ID"
  default     = ""
}

variable "domain" {
  type        = "string"
  description = "top level domain"
}

variable "task_arn" {}

variable "task_role_arn" {}

variable "ecs_cluster_name" {}

variable "desired_count" {
  default     = 1
  description = "Number of running containers"
}

variable "deployment_minimum_healthy_percent" {
  default = 50
}

variable "deployment_maximum_percent" {
  default = 200
}

variable "container_port" {}

variable "ecs_agent_role" {}
