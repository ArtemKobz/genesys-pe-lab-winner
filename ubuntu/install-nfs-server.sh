#!/bin/bash
export DEBIAN_FRONTEND=noninteractive 
apt-get update \
    && apt-get install -y \
	nfs-kernel-server

mkdir -p /mnt/nfs_share \
    && chown -R nobody:nogroup /mnt/nfs_share/ \
    && chmod 777 /mnt/nfs_share/

cat >> /etc/exports <<EOF
/mnt/nfs_share 192.168.56.2(rw,sync,no_subtree_check,no_root_squash)
/mnt/nfs_share 192.168.56.3(rw,sync,no_subtree_check,no_root_squash)
/mnt/nfs_share 192.168.56.4(rw,sync,no_subtree_check,no_root_squash)
EOF

exportfs -a
systemctl restart nfs-kernel-server

cd /mnt/nfs_share
mkdir -p consul/server0
mkdir -p consul/server1
mkdir -p consul/server2
chmod 777 -R consul

cd /mnt/nfs_share
mkdir -p kafka/zookeeper0
mkdir -p kafka/kafka0
chmod -R 777 kafka

cd /mnt/nfs_share
mkdir -p redis/master-0
mkdir -p redis/replica-0
chmod 777 -R redis

