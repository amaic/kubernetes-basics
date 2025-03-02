#!/bin/bash

rootFolder=$(dirname "$BASH_SOURCE")
echo "Root folder: $rootFolder"

source "$rootFolder/../.env"

"$rootFolder/setup-cni.sh"
"$rootFolder/setup-runc.sh"
"$rootFolder/setup-containerd.sh"
"$rootFolder/../setup-kubetools.sh"
"$rootFolder/setup-crictl.sh"

sudo apt install -y jq yq

sudo swapoff --all

cat "/etc/fstab" | \
jq --raw-input \
'
(select(test("^[^#].*\\sswap\\s"))) |= ("# "+.)
' \
--raw-output | sudo tee "/etc/fstab" > /dev/null

