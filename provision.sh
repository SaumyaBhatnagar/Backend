#! /usr/bin/env bash

###
#
# Vagrant provisioning script
# Sets-up your Ubuntu 16.04 box for development purposes
#
###

# Variables
DBHOST=localhost
DBNAME=involvesoft
DBUSER=root
DBPASSWD=root@123

echo -e "\n--- Okay, installing now... ---\n"

echo -e "\n--- Updating packages list ---\n"
apt-get -qq update

echo -e "\n--- Install base packages ---\n"
apt-get -y install vim curl build-essential python-software-properties git >> /home/vagrant/vm_build.log 2>&1

# MySQL setup for development purposes ONLY
echo -e "\n--- Install MySQL specific packages and settings ---\n"
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DBPASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"
apt-get -y install mysql-server phpmyadmin >> /home/vagrant/vm_build.log 2>&1

echo -e "\n--- Setting up our MySQL user and db ---\n"
mysql -uroot -p$DBPASSWD -e "CREATE DATABASE $DBNAME" >> /home/vagrant/vm_build.log 2>&1
mysql -uroot -p$DBPASSWD -e "grant all privileges on $DBNAME.* to '$DBUSER'@'localhost' identified by '$DBPASSWD'" > /home/vagrant/vm_build.log 2>&1

echo -e "\n--- Installing PHP-specific packages ---\n"
apt-get -y install php7.0 apache2 libapache2-mod-php7.0 php7.0-curl php7.0-gd php7.0-mysql php7.0-gettext >> /home/vagrant/vm_build.log 2>&1

echo -e "\n--- Enabling mod-rewrite ---\n"
a2enmod rewrite >> /home/vagrant/vm_build.log 2>&1

echo -e "\n--- Allowing Apache override to all ---\n"
sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf

echo -e "\n--- We definitly need to see the PHP errors, turning them on ---\n"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/apache2/php.ini

echo -e "\n--- Restarting Apache ---\n"
service apache2 restart >> /home/vagrant/vm_build.log 2>&1

echo -e "\n--- Installing Composer for PHP package management ---\n"
curl --silent https://getcomposer.org/installer | php >> /home/vagrant/vm_build.log 2>&1
mv composer.phar /usr/local/bin/composer

cd /var/www/html

echo -e "\n--- Installing project dependencies ---\n"
if [[ -s /var/www/html/composer.json ]] ;then
  sudo -u vagrant -H sh -c "composer install" >> /home/vagrant/vm_build.log 2>&1
fi