#!/bin/bash

  #Author: LaureH
  #Date: 11-Nov-2022

  #Description:----- Script to install Docker, Docker-compose, Jenkins, Sonarqube, and Nginx --------

  echo "Docker Installation on Centos7"
  
  echo "cleanup up the system"
  sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
  
  echo "Setup the docker repository"
  sudo yum install -y yum-utils
  sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

  echo "Install the docker engine"
  sudo yum install docker-ce docker-ce-cli containerd.io

  echo "Check the status, start and enable docker daemon"
  sudo systemctl status docker
  
  if [ $? -eq O ]
  then
  echo "docker daemon is up and  running!"
  else
  echo "start and enable docker daemon with the commands"
  fi

  sudo systemctl start docker
  sudo systemctl enable docker
  

  echo "Docker Installation on Ubuntu"
  
  echo "cleanup up the system"
  sudo apt-get remove docker docker-engine docker.io containerd runc

  echo "Setup the docker repository"
  sudo apt-get update
  sudo apt-get install ca-certificates curl gnupg lsb-release
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/kyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  echo "Install the docker engine"
  sudo apt-get update -y
  sudo apt-get install docker-ce docker-ce-cli containerd.io -y
  
  echo "Check the status, start and enable docker daemon"
  sudo systemctl status docker
  if [ $? -eq O ]
  then
  echo "docker daemon is up and  running!"
  else
  echo "start and enable docker daemon with the commands"
  fi

  sudo systemctl start docker
  sudo systemctl enable docker

