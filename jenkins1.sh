#!/bin/bash
#install java
sudo apt update
sudo apt install -y openjdk-11-jre
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
#install jenkins
sudo apt update
sudo apt install -y jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo apt update
sudo apt install tomcat9 tomcat9-admin -y
sudo ufw allow from any to any port 8081 proto tcp
sudo apt install nodejs -y