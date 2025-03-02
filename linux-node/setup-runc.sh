#!/bin/bash

rootFolder=$(dirname "$BASH_SOURCE")
source "$rootFolder/../.env"

tempOutputFolder=$(mktemp --directory)
echo "Temporary output folder: $tempOutputFolder"

wget https://github.com/opencontainers/runc/releases/download/$RUNC_VERSION/runc.amd64 \
--output-document="$tempOutputFolder/runc.amd64"

sudo install --mode=755 "$tempOutputFolder/runc.amd64" /usr/local/sbin/runc

rm --recursive "$tempOutputFolder"