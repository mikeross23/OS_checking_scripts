#!/bin/bash
sudo apt-get update 
if [ $? -eq 0 ]
then
    # Install LAMP for DEB.
    sudo apt install apache2 -y
    sudo systemctl enable apache2
    sudo systemctl start apache2
    sudo apt install mysql-server -y 
    ### mysql_secure_installation
    sudo touch /home/ubuntu/secure_mysql.sh 
    sudo tee /home/ubuntu/secure_mysql.sh <<EOF
#!/bin/bash
# Make sure that NOBODY can access the server without a password
mysql -e "UPDATE mysql.user SET Password = PASSWORD('password') WHERE User = 'username'"
# Kill the anonymous users
mysql -e "DROP USER ''@'localhost'"
# Because our hostname varies we'll use some Bash magic here.
mysql -e "DROP USER ''@'$(hostname)'"
# Kill off the demo database
mysql -e "DROP DATABASE test"
# Make our changes take effect
mysql -e "FLUSH PRIVILEGES"
# Any subsequent tries to run queries this way will get access denied because lack of usr/pwd param
EOF
    sudo chmod +x /home/ubuntu/secure_mysql.sh
    sudo /home/ubuntu/secure_mysql.sh
    ###
    sudo touch /home/.my.cnf
    sudo tee /home/.my.cnf <<EOF
[mysql]
user = username
password = password

[mysqldump]
user = username
password = password
EOF
    sudo chmod 600 /home/.my.cnf 
    sudo service mysql start
    # Create Wordpress database
    sudo mysql
    CREATE DATABASE demo_db;
    CREATE USER username@localhost IDENTIFIED BY 'password';
    GRANT ALL PRIVILEGES ON demo_db. * TO username@localhost;
    FLUSH PRIVILEGES;
    exit;
 
    sudo systemctl enable mysql
    sudo apt install php libapache2-mod-php php-mysql -y
    sudo apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y
    sudo systemctl restart apache2
    # Install Wordpress
    cd /var/www/html
    sudo wget -c http://wordpress.org/latest.tar.gz
    sudo tar -xzvf latest.tar.gz
    cd /var/www/html/wordpress
    sudo mv wp-config-sample.php wp-config.php


    # Install AWS CLI
    sudo apt install python3-pip -y 
    sudo pip install awscli 
    sudo apt install aws-shell -y 
    # Configure AWS credentials (after defining env. variables)
    aws configure set aws_access_key_id $MY_ACCESS_KEY
    aws configure set aws_secret_access_key $MY_SECRET_ACCESS_KEY
    aws configure set default.region $DEFAULT_REGION