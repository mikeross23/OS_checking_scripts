#!/bin/bash
#decrypt file to get password
gpg -d -o pass.txt pass.txt.gpg
#update repo
sudo -S apt-get update < pass.txt
sudo -S apt-get upgrade -y < pass.txt
rm pass.txt