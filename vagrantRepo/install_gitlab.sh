#!/bin/bash


IP=$(hostname -I | awk '{print $2}')

echo "START - install gitlab - "$IP
sudo bash
sudo yum update -y

echo "[1]: install gitlab"
yum  install -y vim git wget curl -vv
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
sudo yum install -y gitlab-ce
gitlab-ctl reconfigure
echo "END - install gitlab"



#sudo dpkg-reconfigure locales

