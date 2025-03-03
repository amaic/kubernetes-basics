#!/bin/bash

rootFolder=$(dirname "$BASH_SOURCE")
echo "Root folder: $rootFolder"

kubeadm join \
0.0.0.0:6443 \
--config "$rootFolder/kubeadm-config.yaml"
-v 5

