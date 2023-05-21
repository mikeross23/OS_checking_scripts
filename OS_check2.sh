#!/bin/bash
apt-get update 
if [ $? -eq 0 ]
then
    if     cat /etc/*release | grep ^NAME | grep Ubuntu;
      then echo "Your OS is Ubuntu. Installed DEB Package"
    elif   cat /etc/*release | grep ^NAME | grep Debian;
      then echo "Your OS is Debian. Installed DEB Package"
    elif   cat /etc/*release | grep ^NAME | grep Mint;
      then echo "Your OS is Mint. Installed DEB Package"
    else 
           yum update
           if [ $? -eq 0 ]
           then 
               if      cat /etc/*release | grep ^NAME | grep CentOS;
                  then echo "Your OS is CentOS. Installed YUM Package"
               elif    cat /etc/*release | grep ^NAME | grep RedHat;
                  then echo "Your OS id RedHat. Installed YUM Package"
               elif    cat /etc/*release | grep ^NAME | grep Fedora;
                  then echo "Your OS id Fedora. Installed YUM Package"
               else  
                       echo "OS is not detected"
            fi
    fi
                   
else
    echo "END"
fi

