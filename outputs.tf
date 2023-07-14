output "ec2_instance" {
  description = "Returns the ec2 instance attributes"
  value = {
    id                 = aws_instance.ec2_instance[*].id
    security_group_ids = local.sg_ids
  }
}

output "public_ip" {
  value = aws_instance.ec2_instance[*].public_ip
}
output "private_ip" {
  value = aws_instance.ec2_instance[*].private_ip
}