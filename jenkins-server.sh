#!  /bin/bash
#install java
sudo apt update
sudo apt install -y openjdk-11-jre
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
#install and config git
sudo apt update
sudo apt install git
git config --global user.name "Your Name"
git config --global user.email "youremail@domain.com"
#install jenkins
sudo apt update
sudo apt install -y jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins
#install maven
sudo apt update
sudo apt install maven
cat >> /etc/profile.d/maven.sh << EOF
#!/bin/bash
export JAVA_HOME=/usr/lib/jvm/default-java
export M2_HOME=/opt/maven
export MAVEN_HOME=/opt/maven
export PATH=${M2_HOME}/bin:${PATH}
EOF
sudo chmod +x /etc/profile.d/maven.sh
#install tomcat
sudo useradd -m -d /opt/tomcat -U -s /bin/false tomcat
cd /tmp
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.0.20/bin/apache-tomcat-10.0.20.tar.gz
sudo tar xzvf apache-tomcat-10*tar.gz -C /opt/tomcat --strip-components=1
sudo chown -R tomcat:tomcat /opt/tomcat/
sudo chmod -R u+x /opt/tomcat/bin
