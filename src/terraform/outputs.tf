output "selected_azs" {
  value       = random_shuffle.az.result
  description = "The randomly selected azs for deployment"
}

output "public_subnet_cidr" {
  value       = local.public_subnets
  description = "The public subnet_cidr"
}

output "private_subnet_cidr" {
  value       = local.private_subnets
  description = "The private subnet_cidr"
}

# Reference the ARN
output "lb_arn" {
  value = aws_lb.frontend.arn
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.frontend.dns_name
}
