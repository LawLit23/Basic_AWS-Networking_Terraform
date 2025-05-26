output "public_ip" {
  description = "The public IP of the Webserver"
  value       = aws_instance.web.public_ip

}
