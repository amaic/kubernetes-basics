#!/bin/bash

rootFolder=$(dirname "$BASH_SOURCE")
source "$rootFolder/../.env"

tempOutputFolder=$(mktemp --directory)
echo "Temporary output folder: $tempOutputFolder"

wget https://github.com/containernetworking/plugins/releases/download/$CNI_VERSION/cni-plugins-linux-amd64-$CNI_VERSION.tgz \
--output-document="$tempOutputFolder/cni-plugins.tgz"

sudo mkdir --parents /opt/cni/bin
sudo tar --extract --file="$tempOutputFolder/cni-plugins.tgz" --directory=/opt/cni/bin

rm --recursive "$tempOutputFolder"