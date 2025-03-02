#!/bin/bash

rootFolder=$(dirname "$BASH_SOURCE")
echo "Root folder: $rootFolder"

source "$rootFolder/../.env"

"$rootFolder/setup-cni.sh"
"$rootFolder/setup-containerd.sh"
"$rootFolder/setup-runc.sh"
