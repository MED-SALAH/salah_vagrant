#!/bin/bash

# install server postgres

IP=$(hostname -I | awk '{print $2}')


echo "START - install postgres - "$IP
sudo bash
echo "[1]: install postgres"
sudo yum update -y >/dev/null
sudo yum  install -y git vim wget curl >/dev/null
sudo curl -O https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
sudo rpm -ivh pgdg-redhat-repo-latest.noarch.rpm
sudo yum install -y postgresql11-server
sudo /usr/pgsql-11/bin/postgresql-11-setup initdb
sudo -u postgres bash -c "psql -c \"CREATE USER vagrant WITH PASSWORD 'vagrant';\""
sudo -u postgres bash -c "psql -c \"CREATE DATABASE dev OWNER vagrant;\""
sudo -u postgres bash -c "psql -c \"CREATE DATABASE stage OWNER vagrant;\""
sudo -u postgres bash -c "psql -c \"CREATE DATABASE prod OWNER vagrant;\""
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /var/lib/pgsql/11/data/postgresql.conf
sed -i "s/127.0.0.1\/32/0.0.0.0\/0/g" /var/lib/pgsql/11/data/pg_hba.conf
sudo systemctl restart postgresql

echo "END - install postgres"
