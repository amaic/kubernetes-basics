#!/bin/bash

rootFolder=$(dirname "$BASH_SOURCE")
. "$rootFolder/.env"

tempOutputFolder=$(mktemp --directory)
echo "Temporary output folder: $tempOutputFolder"

# https://www.downloadkubernetes.com/
wget https://dl.k8s.io/v$KUBETOOLS_VERSION/bin/linux/$PLATFORM/kubeadm \
--output-document="$tempOutputFolder/kubeadm"

chmod +x "$tempOutputFolder/kubeadm"
sudo mv "$tempOutputFolder/kubeadm" /usr/local/bin/kubeadm

wget https://dl.k8s.io/v$KUBETOOLS_VERSION/bin/linux/$PLATFORM/kubectl \
--output-document="$tempOutputFolder/kubectl"

chmod +x "$tempOutputFolder/kubectl"
sudo mv "$tempOutputFolder/kubectl" /usr/local/bin/kubectl

cat <<"EOD" >> ~/.bashrc

source <(kubeadm completion bash)
source <(kubectl completion bash)
EOD

rm --recursive "$tempOutputFolder"