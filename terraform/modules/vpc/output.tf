output "vpc-id" {
  value = aws_vpc.vpc.id
}

output "subnet-id" {
  value = aws_subnet.primary.id
}