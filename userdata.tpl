#!/bin/bash
set -e  # Exit script on any error

# Log everything to a file
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Update system and install dependencies
sudo apt update && sudo apt upgrade -y
sudo apt install -y unzip curl nano git apache2

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws/

# Start and enable Apache
sudo systemctl start apache2
sudo systemctl enable apache2

# Retrieve GitHub PAT securely from SSM
GIT_PAT=$(aws ssm get-parameter \
  --name "github_pat" \
  --with-decryption \
  --query "Parameter.Value" \
  --output text \
  --region us-east-2)

# Clone the private repo
sudo git clone https://lawlit23:${GIT_PAT}@github.com/lawlit23/Portfolio_Website.git

# Deploy the site
sudo cp -r Portfolio_Website/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html/