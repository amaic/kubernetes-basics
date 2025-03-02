#!/bin/bash

rootFolder=$(dirname "$BASH_SOURCE")
source "$rootFolder/../.env"

tempOutputFolder=$(mktemp --directory)
echo "Temporary output folder: $tempOutputFolder"

wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$CRICTL_VERSION/crictl-$CRICTL_VERSION-linux-386.tar.gz \
--output-document="$tempOutputFolder/crictl.tar.gz"

sudo tar --extract --file="$tempOutputFolder/crictl.tar.gz" --directory=/usr/local/bin

rm --recursive "$tempOutputFolder"