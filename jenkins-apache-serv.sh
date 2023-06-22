#!/bin/bash
sudo apt-get update 
sudo apt install openjdk-11-jdk -y
sudo apt install git 
sudo apt install apache2 -y
sudo apt install gnupg2 -y
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update 
sudo apt-get install jenkins -y
sudo a2enmod rewrite
sudo a2enmod headers
sudo echo "ServerName localhost" >> /etc/apache2/apache2.conf
sudo ufw allow 8080
sudo ufw allow 80
sudo service jenkins start 
sudo service apache2 start && sudo tail -f /var/log/apache2/access.log
chown -R jenkins:jenkins /var/www/html
