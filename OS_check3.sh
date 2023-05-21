#!/bin/bash
sudo su
apt-get update
if [ $? -eq 0 ]
then
    echo "Installing DEB package"
    #Installing Apache2
    apt install -y apache2
    ufw app list
    ufw allow in "Apache"
    ufw status
    #Installing MySQL
    apt install -y mysql-server
    sudo mysql
    cat exit
    #Installing PHP
    apt install -y php libapache2-mod-php php-mysql
elif 
    yum check-update
    if [ $? -eq 0 ]
    then 
        echo "Installing YUM package"
        #Installing Apache Web Server
        yum -y install httpd
        systemctl start httpd
        systemctl enable httpd.service
        #Installing MySQL (MariaDB)
        yum -y install mariadb-server
        systemctl start mariadb
        systemctl enable mariadb.service
        #Installing PHP
        yum -y install php php-mysql
        systemctl restart httpd.service
    else
        echo "Unknown OS"
    fi    
else 
    echo "End of checking OS"
fi


