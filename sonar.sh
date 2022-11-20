#!/bin/bash

  #Author: LaureH
  #Date: 11-Nov-2022

  #Description:----- Script to install Docker, Docker-compose, Jenkins, Sonarqube, and Nginx --------

  echo "sonarqube Installation on Centos7"
  
  echo "system update"
  sudo yum -y install epel-release
  sudo yum -y update
  sudo shutdown -r now
  
  echo "install Java"
  yum install wget -y
  wget --no-cookies --no-check-certificate --header "Cookie:oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm"
  sudo yum -y localinstall jdk-8u131-linux-x64.rpm
  java -version

  echo "Install and configure PostgreSQL"
  sudo rpm -Uvh https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm
  sudo yum -y install postgresql96-server postgresql96-contrib
  sudo /usr/pgsql-9.6/bin/postgresql96-setup initdb
  sudo nano /var/lib/pgsql/9.6/data/pg_hba.conf
 
 ##Find the following lines and change peer to trust and idnet to md5
  # TYPE  DATABASE        USER            ADDRESS                 METHOD

  # "local" is for Unix domain socket connections only

  local   all             all                                     peer

  # IPv4 local connections:

  host    all             all             127.0.0.1/32            ident

  # IPv6 local connections:

  host    all             all             ::1/128                 ident

 ##Once updated, the configuration should look like the one shown below.
  # TYPE  DATABASE        USER            ADDRESS                 METHOD

  # "local" is for Unix domain socket connections only

  local   all             all                                     trust

  # IPv4 local connections:

  host    all             all             127.0.0.1/32            md5

  # IPv6 local connections:

  host    all             all             ::1/128                 md5
  
  echo "start and enable PostgreSQL"
  sudo systemctl start postgresql-9.6
  sudo systemctl enable postgresql-9.6

  echo "change password for default PostgreSQL user and switch to the postgres user"
  su - postgres
  createuser sonar
  ##Switch to the PostgreSQL shell psql
  ##Set a password for the newly created user for SonarQube database.
  ALTER USER sonar WITH ENCRYPTED password 'StrongPassword';
  ##Create a new database for PostgreSQL database by running:
  CREATE DATABASE sonar OWNER sonar;
  ##Exit from the psql shell:
  \q

  echo "download and configure Sonarqube"
  wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-6.4.zip
  sudo yum -y install unzip
  sudo unzip sonarqube-6.4.zip -d /opt
  sudo nano /opt/sonarqube/conf/sonar.properties
  ##Find the following lines.
  #sonar.jdbc.username=
  #sonar.jdbc.password=
  ##Uncomment and provide the PostgreSQL username and password of the database that we have created earlier. It should look like:
  sonar.jdbc.username=sonar
  sonar.jdbc.password=StrongPassword
  ##Next, find:
  #sonar.jdbc.url=jdbc:postgresql://localhost/sonar
  #Uncomment the line, save the file and exit from the editor.
  
  echo "configure systemd service"
  sudo nano /etc/systemd/system/sonar.service
  ##populate the file with:
  [Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=root
Group=root
Restart=always

[Install]
WantedBy=multi-user.target
  
 ##Start the application by running:
 sudo systemctl start sonar
 ##Enable the SonarQube service to automatically start at boot time.
 sudo systemctl enable sonar
 ##To check if the service is running, run:
 sudo systemctl status sonar

 echo "configure reverse proxy"
 sudo yum -y install httpd
 ##Create a new virtual host.
 sudo nano /etc/httpd/conf.d/sonar.yourdomain.com.conf
 ##Populate the file with:
 <VirtualHost *:80>

    ServerName sonar.yourdomain.com

    ServerAdmin me@yourdomain.com

    ProxyPreserveHost On

    ProxyPass / http://localhost:9000/

    ProxyPassReverse / http://localhost:9000/

    TransferLog /var/log/httpd/sonar.yourdomain.com_access.log

    ErrorLog /var/log/httpd/sonar.yourdomain.com_error.log

</VirtualHost>
  ##Start Apache and enable it to start automatically at boot time:
  sudo systemctl start httpd
  sudo systemctl enable httpd

  echo "configure firewall"
  sudo firewall-cmd --add-service=http --permanent
  sudo firewall-cmd --reload
  ##Start the SonarQube service:
  sudo systemctl start sonar
  ##You will also need to disable SELinux:
  sudo setenforce 0
  ##SonarQube is installed on your server, access the dashboard at the following address.
  http://sonar.yourdomain.com
  ##Log in using the initial administrator account, admin and admin. You can now use SonarQube to continuously analyze the code you have written.

end
