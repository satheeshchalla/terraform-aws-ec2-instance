# Ensure security groups are created before you destory them.
# When they are referenced in other security groups they will not be deleted unless the references are updated properly.
# Use only name_prefix attribute instead of name.

resource "aws_security_group" "security_group" {
  count       = length(var.security_group_ids) == 0 ? 1 : 0
  description = "set of rules allowed inbound and outbound"
  name_prefix = "${var.name_prefix}-ec2-instance-sg"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name_prefix}-ec2-instance-sg"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_ssh" {
  count             = length(var.security_group_ids) == 0 ? 1 : 0
  description       = "allow ssh to this instance"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.source_ip_addrs
  security_group_id = aws_security_group.security_group[0].id
}

resource "aws_security_group_rule" "allow_everything" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.security_group[0].id
}

locals {
  sg_ids = length(var.security_group_ids) == 0 ? [aws_security_group.security_group[0].id] : var.security_group_ids
}
resource "aws_network_interface" "eni" {
  subnet_id       = var.subnet_id
  private_ips     = [var.static_ip]
  security_groups = local.sg_ids

  tags = {
    Name = "${var.name_prefix}-ec2-instance-eni"
  }
}


resource "aws_instance" "ec2_instance" {
  ami = var.image_id
  # subnet_id     = var.subnet_id (shouldn't have subnet_id when you use network_interface. The reason is that the instance will be create in the subnet where the network interface is.)
  instance_type = var.instance_type

  key_name                             = aws_key_pair.key.key_name
  iam_instance_profile                 = aws_iam_instance_profile.ec2_instance_profile[0].id
  user_data                            = var.user_data
  user_data_base64                     = var.user_data_base64
  instance_initiated_shutdown_behavior = "stop"

  # vpc_security_group_ids               = local.sg_ids
  root_block_device {
    volume_type           = var.root_block_device["type"]
    volume_size           = var.root_block_device["size"]
    delete_on_termination = var.root_block_device["delete_on_termination"]
    encrypted             = var.root_block_device["encrypted"]
    iops                  = var.root_block_device["iops"]
    tags = {
      Name = "${var.name_prefix}-ec2"
    }
  }

  network_interface {
    network_interface_id = aws_network_interface.eni.id
    device_index         = 0
  }

  tags = {
    Name           = "${var.name_prefix}-ec2",
    AutoSSMPatches = var.enable_system_patches
  }

}

resource "aws_key_pair" "key" {
  key_name = "my-key"
  # add your public key in project root directory
  public_key = file("mention key name here")
}
