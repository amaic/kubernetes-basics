#!/bin/bash

rootFolder=$(dirname "$BASH_SOURCE")
echo "Root folder: $rootFolder"

source "$rootFolder/.env"

kind delete cluster --name "$KIND_CLUSTERNAME"

"$rootFolder/cleanup-kubetools.sh"
"$rootFolder/cleanup-kind.sh"
"$rootFolder/cleanup-cni.sh"
"$rootFolder/cleanup-docker.sh"
