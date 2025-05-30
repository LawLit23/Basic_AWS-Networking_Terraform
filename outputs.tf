output "public_ip" {
  description = "The public IP of the Webserver"
  value       = "${aws_eip.eip.public_ip}:8080"

}

output "public_subnet1" {
  value = aws_subnet.public_subnet1.id
}
output "public_subnet2" {
  value = aws_subnet.public_subnet2.id
}

output "private_subnet1" {
  value = aws_subnet.private_subnet1.id
}
output "private_subnet2" {
  value = aws_subnet.private_subnet2.id
}
output "vpc_id" {
  value = aws_vpc.base_vpc.id
}
output "IG" {
  value = aws_internet_gateway.base_IG.id
}
output "NAT" {
  value = aws_nat_gateway.nat_gw.id
}
