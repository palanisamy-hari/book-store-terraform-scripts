#!/bin/sh

# Arguments
if [ -n "${1}" ]; then
  CUSTOM_DNS=${1}
else
  CUSTOM_DNS=localhost
fi

# Install MicroK8s on Linux
sudo apt-get -y update
sudo snap install core
sudo snap install microk8s --classic
sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER ~/.kube
sudo microk8s config > ~/.kube/config

# Check the status while Kubernetes starts
sudo microk8s status --wait-ready

# install helm lib
sudo microk8s enable helm3
sudo microk8s enable storage
sudo microk8s enable dns
sudo microk8s enable ingress
sudo microk8s enable registry
sudo microk8s enable metallb
microk8s.kubectl config view --raw > $HOME/.kube/config

sudo microk8s kubectl create namespace zalenium

## Start your cluster

git clone https://github.com/zalando/zalenium.git
cd zalenium || return
helm install my-zalenium charts/zalenium --namespace zalenium