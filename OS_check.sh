#!/bin/bash
if    cat /etc/*release | grep ^NAME | grep Ubuntu; 
   then
      echo "Installing DEB Package"
      apt-get update
elif  cat /etc/*release | grep ^NAME | grep Debian; 
   then
      echo "Installing DEB Package"
      apt-get update
elif  cat /etc/*release | grep ^NAME | grep Mint; 
   then
      echo "Installing DEB Package"
      apt-get update
elif  cat /etc/*release | grep ^NAME | grep CentOS; 
   then
      echo "Installing YUM Package"
      yum update
elif  cat /etc/*release | grep ^NAME | grep RedHat; 
   then
      echo "Installing YUM Package"
      yum update
elif  cat /etc/*release | grep ^NAME | grep Fedora; 
   then
      echo "Installing YUM Package"
      yum update
else
      echo "OS is not detected"
fi   
