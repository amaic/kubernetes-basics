#!/bin/bash

rootFolder=$(dirname "$BASH_SOURCE")
echo "Root folder: $rootFolder"

source "$rootFolder/../.env"

"$rootFolder/cleanup-containerd.sh"
"$rootFolder/cleanup-crictl.sh"
"$rootFolder/cleanup-runc.sh"
"$rootFolder/cleanup-cni.sh"
