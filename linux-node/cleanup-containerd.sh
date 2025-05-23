#!/bin/bash

rootFolder=$(dirname "$BASH_SOURCE")
source "$rootFolder/../.env"

sudo systemctl disable --now containerd
sudo rm /usr/local/lib/systemd/system/containerd.service
sudo systemctl daemon-reload

sudo rm /usr/local/bin/containerd* /usr/local/bin/ctr
sudo rm --recursive /etc/containerd
sudo rm --recursive /run/containerd
sudo rm --recursive /var/lib/containerd
