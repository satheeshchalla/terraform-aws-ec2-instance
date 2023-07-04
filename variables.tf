variable "name_prefix" {
  description = "name prefix for all the resources including ec2 instance."
  default     = ""
}
variable "vpc_id" {
  description = "vpc_id"
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "subnet_id"
  type        = string
  default     = ""
}

variable "image_id" {
  description = "ami id to launch instance"
  default     = ""
}

variable "instance_type" {
  type        = string
  description = "(optional) The instance type to launch instance. Defaults to t3.micro"
  default     = "t3.micro"
}

variable "key_name" {
  type        = string
  description = "(optional) The Key pair to be used to launch instance."
  default     = ""
}

variable "root_block_device" {
  type = object({
    type                  = string
    size                  = number
    iops                  = string
    delete_on_termination = bool
    encrypted             = bool
  })
  description = "(optional) The root block device configuration object"
  default = {
    type                  = "gp3"
    size                  = 20
    iops                  = 100
    delete_on_termination = true
    encrypted             = false
  }
}

variable "user_data" {
  type        = string
  description = "(optional) The user data to be passed to the instance."
  default     = null
}

variable "user_data_base64" {
  type        = string
  description = "(optional) user data in base64 format including gzip encoded data."
  default     = null
}
variable "security_group_ids" {
  type        = list(string)
  description = "(optional) list of security group ids to be attached to this instance."
  default     = []
}
variable "source_ip_addrs" {
  type        = list(any)
  description = "(optional) List of Source IP addresses to allow SSH to this instance."
  default     = []
}

variable "network_interface_id" {
  type        = string
  description = "(optional) network interface id for instances if required"
  default     = ""
}

variable "static_ip" {
  type        = string
  description = "(optional) static describe your variable"
  default     = ""
}

variable "iam_instance_profile" {
  type        = string
  description = "(optional) IAM instance profile to be attached to the instance"
  default     = ""
}

variable "enable_system_patches" {
  type        = bool
  description = "(optional) Allow SSM to apply patches to this instance. "
  default     = false
}

variable "region" {
  type        = string
  description = "(optional) default region is ap-south-1"
  default     = "ap-south-1"
}