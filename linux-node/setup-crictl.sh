#!/bin/bash

rootFolder=$(dirname "$BASH_SOURCE")
source "$rootFolder/../.env"

tempOutputFolder=$(mktemp --directory)
echo "Temporary output folder: $tempOutputFolder"

wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$CRICTL_VERSION/crictl-$CRICTL_VERSION-linux-386.tar.gz \
--output-document="$tempOutputFolder/crictl.tar.gz"

sudo tar --extract --file="$tempOutputFolder/crictl.tar.gz" --directory=/usr/local/bin

cat <<"EOD" | sudo tee /etc/crictl.yaml > /dev/null
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 2
debug: false
pull-image-on-create: false
EOD

rm --recursive "$tempOutputFolder"