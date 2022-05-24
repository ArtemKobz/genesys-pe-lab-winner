#!/bin/bash
set -e
IFNAME=$1
ADDRESS="$(ip -4 addr show $IFNAME | grep "inet" | head -1 |awk '{print $2}' | cut -d/ -f1)"
sed -e "s/^.*${HOSTNAME}.*/${ADDRESS} ${HOSTNAME} ${HOSTNAME}.local/" -i /etc/hosts

# remove ubuntu-bionic entry
mkdir /home/osboxes
useradd osboxes -s /bin/bash -d /home/osboxes
chown osboxes /home/osboxes
swapoff -a
curl -L terminal.kodekloud.com | bash
su -c "curl -L terminal.kodekloud.com | bash" vagrant
sed -e '/^.*ubuntu-bionic.*/d' -i /etc/hosts

# Update /etc/hosts about other hosts
cat >> /etc/hosts <<EOF
192.168.56.2  master kubemaster
192.168.56.3  worker-1 kubenode01
192.168.56.4  worker-2 kubenode02
192.168.56.11 nfs01
EOF
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF
sudo sysctl --system
echo 'export PS1="${cyan}\h ${red}$ ${clear_attributes}"' >> /root/.bash_profile
echo 'export PS1="${cyan}\h ${red}$ ${clear_attributes}"' >> /home/vagrant/.bash_profile
echo 'sudo -i' >> /home/vagrant/.bash_profile
