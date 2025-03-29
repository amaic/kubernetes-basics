#!/bin/bash

rootFolder=$(dirname "$BASH_SOURCE")
. "$rootFolder/.env"

tempOutputFolder=$(mktemp --directory)
echo "Temporary output folder: $tempOutputFolder"

# https://github.com/containernetworking/plugins/releases
wget https://github.com/containernetworking/plugins/releases/download/v$CNI_VERSION/cni-plugins-linux-amd64-v$CNI_VERSION.tgz \
--output-document="$tempOutputFolder/cni-plugins.tgz"

sudo mkdir --parents "$CNI_BIN_PATH"
sudo tar --extract --file="$tempOutputFolder/cni-plugins.tgz" --directory="$CNI_BIN_PATH"

rm --recursive "$tempOutputFolder"