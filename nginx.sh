#!/bin/bash

  #Author: LaureH
  #Date: 11-Nov-2022

  #Description:----- Script to install Docker, Docker-compose, Jenkins, Sonarqube, and Nginx --------

  echo "Nginx Installation on Ubuntu"
  sudo apt update
  sudo apt install nginx
  
  echo "Adjusting the Firewall"
  sudo ufw app list
  sudo ufw allow 'Nginx HTTP'
  sudo ufw status
  
  echo "Checking your Web Server"
  systemctl status nginx
  curl -4 icanhazip.com

  #When you have your server’s IP address, enter it into your browser’s address bar:
  http://your_server_ip

  echo "Welcome to Nginx!"

end
