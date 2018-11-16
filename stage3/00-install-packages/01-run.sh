#!/bin/bash -e

on_chroot << EOF
update-alternatives --install /usr/bin/x-www-browser \
  x-www-browser /usr/bin/chromium-browser 86
update-alternatives --install /usr/bin/gnome-www-browser \
  gnome-www-browser /usr/bin/chromium-browser 86

pip install speedtest-cli


# for etherpad
curl -sL https://deb.nodesource.com/setup_11.x | bash -
apt-get install -y nodejs

/etc/init.d/mysql start
mysql -u root -e "CREATE DATABASE IF NOT EXISTS etherpad CHARACTER SET utf8 COLLATE utf8_general_ci; GRANT ALL PRIVILEGES ON etherpad.* TO etherpad_user@localhost IDENTIFIED BY 'password'; FLUSH PRIVILEGES;"

cd /var/www/html
mkdir -p etherpad-lite
cd etherpad-lite
git init
git remote set-url origin git://github.com/ether/etherpad-lite.git
git fetch
git checkout origin/master -f
cp settings.json.template settings.json
#todo

adduser --system --home=/var/www/html/etherpad-lite/ --group etherpad
chown -R etherpad: /var/www/html/etherpad-lite/
# bash /var/www/html/etherpad-lite/bin/run.sh


# for Mazi portal
gem install sinatra sequel sqlite3 rake thin rubyzip mysql --no-ri --no-rdoc

cd /root
mkdir -p portal
cd portal
git init
git remote set-url origin https://github.com/mazi-project/portal.git
git fetch
git checkout origin/master -f

rake init
rake db:migrate

cp init/mazi-portal /etc/init.d/mazi-portal
chmod +x /etc/init.d/mazi-portal
update-rc.d mazi-portal defaults
update-rc.d mazi-portal enable

# data collection service
# cp init/mazi-rest /etc/init.d/mazi-rest
# chmod +x /etc/init.d/mazi-rest
# update-rc.d mazi-rest enable

service mazi-portal start
# service mazi-rest start
EOF
