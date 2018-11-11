#!/bin/bash -e

install -v -d					"${ROOTFS_DIR}/etc/systemd/system/dhcpcd.service.d"
install -v -m 644 files/wait.conf		"${ROOTFS_DIR}/etc/systemd/system/dhcpcd.service.d/"

install -v -d					"${ROOTFS_DIR}/etc/wpa_supplicant"
install -v -m 600 files/wpa_supplicant.conf	"${ROOTFS_DIR}/etc/wpa_supplicant/"

install -v -m 600 files/dnsmasq.conf	"${ROOTFS_DIR}/etc/"

install -v -d					"${ROOTFS_DIR}/etc/hostapd"
install -v -m 600 files/hostapd.conf	"${ROOTFS_DIR}/etc/hostapd/"

install -v -m 600 files/index.html	"${ROOTFS_DIR}/var/www/html/"
install -v -m 600 files/.htaccess	"${ROOTFS_DIR}/var/www/html/"

on_chroot << EOF
systemctl enable dnsmasq
sed -i '/^#.* ip_forward /s/^#//' /etc/sysctl.conf
a2enmod rewrite
sed -i '/^#.* AllowOverride None /s/None/all/' /etc/apache2/apache2.conf
EOF
