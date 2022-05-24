#!/bin/bash
export DEBIAN_FRONTEND=noninteractive 
apt-get update \
    && apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common \
    && curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update \
    && apt-get install -y kubelet kubeadm kubectl \
    && apt-mark hold kubelet kubeadm kubectl

rm /etc/containerd/config.toml
systemctl restart containerd
