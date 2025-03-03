#!/bin/bash

rootFolder=$(dirname "$BASH_SOURCE")
echo "Root folder: $rootFolder"

source "$rootFolder/../.env"

"$rootFolder/../cleanup-kubetools.sh"
"$rootFolder/cleanup-crictl.sh"
"$rootFolder/cleanup-containerd.sh"
"$rootFolder/cleanup-runc.sh"
"$rootFolder/cleanup-cni.sh"

sudo apt remove -y kubelet python3-tomli-w
sudo rm --recursive /var/lib/kubelet
sudo rm --recursive /etc/kubernetes
# sudo rm --recursive /usr/lib/systemd/system/kubelet.service.d
# sudo systemctl daemon-reload
