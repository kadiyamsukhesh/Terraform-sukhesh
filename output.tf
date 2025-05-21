output "ec2_instance_ip" {
    value = module.ec2_instance.public_ip
}

output "route_table_ids" {
  value = module.vpc.public_route_table_ids
}