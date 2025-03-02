#!/bin/bash

rootFolder=$(dirname "$BASH_SOURCE")
echo "Root folder: $rootFolder"

source "$rootFolder/../.env"

"$rootFolder/setup-cni.sh"
"$rootFolder/setup-runc.sh"
"$rootFolder/setup-crictl.sh"
"$rootFolder/setup-containerd.sh"
