#!/bin/bash

# install p1jenkins

IP=$(hostname -I | awk '{print $2}')

echo "START - install jenkins - "$IP
sudo bash
echo "[1]: install utils & ansible"
yum update -y -vv
yum  install -y vim git sshpass wget ansible gnupg2 curl -vv


echo "[2]: install java & jenkins"
yum install -y java-1.8.0-openjdk.x86_64
curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install -y jenkins
systemctl enable jenkins
systemctl start jenkins
sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp



echo "[2]: ansible custom"
sed -i 's/.*pipelining.*/pipelining = True/' /etc/ansible/ansible.cfg
sed -i 's/.*allow_world_readable_tmpfiles.*/allow_world_readable_tmpfiles = True/' /etc/ansible/ansible.cfg

echo "[3]: install docker & docker-composer"
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
usermod -aG docker jenkins 
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose 

echo "[4]: use registry without ssl"
echo "
{
 \"insecure-registries\" : [\"192.168.1.5:5000\"]
}
" >/etc/docker/daemon.json
systemctl daemon-reload
systemctl restart docker

echo "END - install jenkins"
