#!/bin/bash

  #Author: LaureH
  #Date: 11-Nov-2022

  #Description:----- Script to install Docker, Docker-compose, Jenkins, Sonarqube, and Nginx --------

  echo "Jenkins Installation on Centos7"

  echo "Java installation"
  sudo yum install java-11-openjdk-devel -y

  echo "Enable the Jenkins repository"
  curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
  sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key

  echo "Install the latest version of Jenkins"
  sudo yum install jenkins -y

  echo "Start the service"
  sudo systemctl start jenkins
  sudo systemctl status jenkins
  sudo systemctl enable jenkins

  echo "Adjust the firewall"
  sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
  sudo firewall-cmd --reload

  echo "Setting up Jenkins in the browser"
  ##Launch your google chrome browser an type your IP address followed by the port number 8080
  ##http://your_ip_or_domain:8080 
  echo "Copy and paste the administrator password"
 ##In your terminal, use the following command to print the Administrator password that was generated during jenkins installation.
 ##You should see a 32-character long alphanumeric password. Copy the password and paste it into the Administrator password field in the page you have in the browser. Then click on Continue

 ##Note: use this command to copy the initial password:
 sudo cat /var/lib/jenkins/secrets/initialAdminPassword

 ##On the screen Customize Jenkins, you will be asked to either Install suggested plugins or Select plugins to install. Click on the Install suggested plugins box and the installation process will start immediately

 ##When the installation will be completed, you will get a form to create the First Admin User. Fill out the form an validate on Save and Continue
 echo "Instance configuration"
 ##On the next page you will need to set the URL for the Jenkins instance. The Jenkins URL field will come with a default  value (automatically generated). Just click on Save and Finish

 ##Jenkins is now ready for use! Click on Start using Jenkins button and you will be automatically be redirected to the Jenkins dashboard

 ##Here you are logged in as the First Admin user you created in a previous step

end
