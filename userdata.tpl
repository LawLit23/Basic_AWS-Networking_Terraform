#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt-get install -y nano git
sudo apt install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2
sudo git clone https://github.com/LawLit23/Portfolio_Website.git
sudo cp -r Portfolio_Website/* /var/www/html/