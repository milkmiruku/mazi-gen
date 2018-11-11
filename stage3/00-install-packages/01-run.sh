#!/bin/bash -e

on_chroot << EOF
update-alternatives --install /usr/bin/x-www-browser \
  x-www-browser /usr/bin/chromium-browser 86
update-alternatives --install /usr/bin/gnome-www-browser \
  gnome-www-browser /usr/bin/chromium-browser 86

pip install speedtest-cli

curl -sL https://deb.nodesource.com/setup_11.x | bash -
apt-get install -y nodejs

mysql -u root -p
CREATE DATABASE etherpad CHARACTER SET utf8 COLLATE utf8_general_ci;
GRANT ALL PRIVILEGES ON etherpad.* TO etherpad_user@localhost IDENTIFIED BY ‘password’;
FLUSH PRIVILEGES;
quit

cd /var/www/html
git clone git://github.com/ether/etherpad-lite.git
cd etherpad-lite
cp settings.json.template settings.json
#todo

adduser --system --home=/var/www/html/etherpad-lite/ --group etherpad
chown -R etherpad: /var/www/html/etherpad-lite/
bash /var/www/html/etherpad-lite/bin/run.sh
EOF
