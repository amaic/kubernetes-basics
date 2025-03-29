#!/bin/bash

sed --in-place '/kubeadm/d' ~/.bashrc
sed --in-place '/kubectl/d' ~/.bashrc

sudo rm /usr/local/bin/kubeadm
sudo rm /usr/local/bin/kubectl

