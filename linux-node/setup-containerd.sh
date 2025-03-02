#!/bin/bash

rootFolder=$(dirname "$BASH_SOURCE")
source "$rootFolder/../.env"

tempOutputFolder=$(mktemp --directory)
echo "Temporary output folder: $tempOutputFolder"

wget https://github.com/containerd/containerd/releases/download/v$CONTAINERD_VERSION/containerd-$CONTAINERD_VERSION-linux-amd64.tar.gz \
--output-document="$tempOutputFolder/containerd.tar.gz"

sudo wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service \
--output-document="/usr/local/lib/systemd/system/containerd.service"

sudo tar --extract --file="$tempOutputFolder/containerd.tar.gz" --directory=/usr/local

sudo mkdir /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml > /dev/null

cat /etc/containerd/config.toml | \
tomlq --toml-output \
'(.plugins.["io.containerd.grpc.v1.cri"].containerd.runtimes.runc.options.SystemdCgroup) |= true ' | \
sudo tee /etc/containerd/config.toml > /dev/null


sudo systemctl daemon-reload
sudo systemctl enable --now containerd

rm --recursive "$tempOutputFolder"