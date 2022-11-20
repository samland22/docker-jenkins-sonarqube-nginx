#!/bin/bash

  # Author: LaureH
  # Date: Nov-20-2022
  # Description:---Script to install Docker-compose on Centos7---

 sudo yum update -y

 sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
 sudo chmod +x /usr/local/bin/docker-compose
 if [ $? -eq 0 ];
  then 

 echo "docker version is!"
 docker-compose --version
 fi

 echo "Script to install Docker-compose on Ubuntu"
 sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
 sudo chmod +x /usr/local/bin/docker-compose

if [ $? -eq 0 ];  then

 echo "docker-compose version is!" 
 docker-compose --version
fi

