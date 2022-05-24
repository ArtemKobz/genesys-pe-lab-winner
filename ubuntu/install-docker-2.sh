cd /tmp
curl -fsSL https://get.docker.com -o get-docker.sh
sh /tmp/get-docker.sh
echo '{"exec-opts": ["native.cgroupdriver=systemd"]}' >> /etc/docker/daemon.json
systemctl restart docker
