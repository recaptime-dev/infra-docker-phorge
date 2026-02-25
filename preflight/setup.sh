#!/bin/sh

set -e
set -x

# Move preflight files to their locations
mkdir /app/startup -pv

mv /preflight/nginx.conf /app/nginx.conf
mv /preflight/fastcgi.conf /app/fastcgi.conf

mv /preflight/run-phd.sh /app/run-phd.sh
mv /preflight/run-ssh.sh /app/run-ssh.sh
mv /preflight/run-aphlict.sh /app/run-aphlict.sh
mv /preflight/run-iomonitor.sh /app/run-iomonitor.sh

mv /preflight/10-boot-conf /app/startup/10-boot-conf

mv /preflight/php-fpm.conf /etc/php83/php-fpm.conf.template

mv /preflight/supervisord.conf /app/supervisord.conf
ln -s /app/supervisord.conf /etc/supervisor/supervisord.conf
mv /preflight/init.sh /app/init.sh

mv /preflight/preamble.php /srv/phorge/phorge/support/preamble.php

mkdir -pv /run/watch
mkdir /etc/phorge-ssh
mv /preflight/sshd_config.phorge /etc/phorge-ssh/sshd_config.phorge.template
mv /preflight/phorge-ssh-hook.sh /etc/phorge-ssh/phorge-ssh-hook.sh.template
mv /preflight/bake /bake
mkdir /opt/iomonitor
mv /preflight/iomonitor /opt/iomonitor
rm /preflight/setup.sh
cd /
ls /preflight
rmdir /preflight # This should now be empty; it's an error if it's not.

# Move the default SSH to port 2222
echo "" >> /etc/ssh/sshd_config
echo "Port 2222" >> /etc/ssh/sshd_config

# Configure Phorge SSH service
chown root:root /etc/phorge-ssh/*

# Setup logs directory for Phorge services and friends
mkdir /var/log/phorge
chown PHORGE:wwgrp-phorge -Rv /var/log/phorge