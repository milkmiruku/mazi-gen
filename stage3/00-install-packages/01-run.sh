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
[[ -d etherpad-lite ]] && rm -rf etherpad-lite;
git clone git://github.com/ether/etherpad-lite.git
cd etherpad-lite
cp settings.json.template settings.json
#todo

adduser --system --home=/var/www/html/etherpad-lite/ --group etherpad
chown -R etherpad: /var/www/html/etherpad-lite/
# bash /var/www/html/etherpad-lite/bin/run.sh


# for Mazi portal
gem install sinatra sequel sqlite3 rake thin rubyzip mysql --no-ri --no-rdoc

cd /root
[[ -d portal ]] && rm -rf portal;
git clone https://github.com/mazi-project/portal.git
cd portal
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

# service mazi-portal start
# service mazi-rest start

/etc/init.d/mysql stop
sleep 15
EOF
