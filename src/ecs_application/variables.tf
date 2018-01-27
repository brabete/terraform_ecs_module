variable "name" {
  type = "string"
  description = "Application name"
}

variable "image" {
  description = "Docker image"
  default = ""
}

variable "version" {
  type = "string"
  default = "latest"
  description = "Docker image version"
}

variable "aws_region" {
  type = "string"
  description = "AWS region"
}

// template name
variable "template" {
  type = "string"
  description = "Task definition template"
}

// hard cpu limit for docker
variable "cpu" {
  default = "100"
}

variable "memory" {
  default = "256"
}

variable "node_env" {
  default = "development"
}

variable "container_port" {
  default = "3000"
}

variable "node_mongodb" {
  description = "MongoDB connection string"
  default = ""
}

variable "aws_log_region" {
  description = "AWS region where logs will be send"
  default = ""
}

variable "ecs_log_group" {
  description = "AWS Cloudwatch log group"
  default = ""
}

variable "splunk_url" {
  description = "Url of splunk collector"
  default = ""
  type = "string"
}

variable "splunk_token" {
  default = ""
}

variable "log_retention" {
  description = "Log retention in days"
  default = 30
}

variable "node_solr_hostname" {
  default = ""
}
