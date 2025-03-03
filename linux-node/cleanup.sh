#!/bin/bash

rootFolder=$(dirname "$BASH_SOURCE")
echo "Root folder: $rootFolder"

source "$rootFolder/../.env"

"$rootFolder/../cleanup-kubetools.sh"
"$rootFolder/cleanup-crictl.sh"
"$rootFolder/cleanup-containerd.sh"
"$rootFolder/cleanup-runc.sh"
"$rootFolder/cleanup-cni.sh"

sudo apt remove -y kubelet
