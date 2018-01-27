variable "min_size" {
  type        = "string"
  description = "Minimum number of EC2 instances in ECS cluster."
  default     = 1
}

variable "max_size" {
  type        = "string"
  description = "Maximum number of EC2 instances in ECS cluster."
  default     = 10
}

variable "desired_size" {
  type        = "string"
  description = "Desired number of EC2 instances in ECS cluster."
  default     = 3
}

variable "instance_type" {
  type        = "string"
  description = "ECS EC2 instance type."
  default     = "t2.micro"
}

variable "cluster_name" {
  type        = "string"
  description = "ECS cluster name."
  default     = "cluster"
}

variable "environment" {
  type        = "string"
  description = "Environment."
  default     = "dev"
}

variable "ami" {
  type        = "string"
  description = "AMI Image ID"
  default     = ""
}

variable "subnets" {
  type        = "list"
  description = "Subnets for ECS nodes."
}

variable "vpc_id" {
  type        = "string"
  description = "VPC Id."
}

variable "key_name" {
  type        = "string"
  description = "SSH key pair name."
}

variable "associate_public_ip_address" {
  type        = "string"
  description = "External dynamic IP address"
  default     = false
}

variable "aws_region" {
  type        = "string"
  description = "AWS Region."
}

variable "tags" {
  type        = "map"
  description = "Tags for AWS resources"
}

variable "default_cooldown" {
  type    = "string"
  default = 300
}

variable "health_check_grace_period" {
  type    = "string"
  default = 300
}

variable "health_check_type" {
  type    = "string"
  default = "EC2"
}

variable "force_delete" {
  type    = "string"
  default = false
}

variable "load_balancers" {
  type    = "list"
  default = []
}

variable "target_group_arns" {
  type    = "list"
  default = []
}

variable "termination_policies" {
  type = "list"

  default = [
    "default",
  ]
}

variable "root_volume_type" {
  type    = "string"
  default = "gp2"
}

variable "root_volume_iops" {
  type    = "string"
  default = false
}

variable "root_volume_size" {
  type        = "string"
  default     = "16"
  description = "EBS Root volume size"
}

variable "delete_root_volume_on_termination" {
  type        = "string"
  default     = true
  description = "Delete Root EBS volume on termination"
}

variable "security_groups" {
  type        = "list"
  description = "Additional security groups"
  default     = []
}

variable "wait_for_capacity_timeout" {
  type    = "string"
  default = "10m"
}

variable "wait_for_elb_capacity" {
  type    = "string"
  default = false
}

variable "min_elb_capacity" {
  type    = "string"
  default = 0
}

variable "extra_volumes" {
  type        = "string"
  default     = false
  description = "Mount external EBS volumes (true/false)"
}

variable "availability_zones" {
  type        = "list"
  default     = []
  description = "Availability zones for extra EBS volumes"
}

variable "adjustment_type_up" {
  default = "ChangeInCapacity"
}

variable "scaling_adjustment_up" {
  default = "+1"
}

variable "cooldown_up" {
  default = "180"
}

variable "adjustment_type_down" {
  default = "ChangeInCapacity"
}

variable "scaling_adjustment_down" {
  default = "-1"
}

variable "cooldown_down" {
  default = "300"
}

variable "efs_storage_name" {
  description = "AWS EFS storage name (Available just in few regions)"
  default     = ""
}
