#!/bin/bash

rootFolder=$(dirname "$BASH_SOURCE")
echo "Root folder: $rootFolder"

source "$rootFolder/.env"

# "$rootFolder/cleanup-kubectl.sh"
# "$rootFolder/cleanup-kind.sh"
# "$rootFolder/cleanup-cni.sh"
# "$rootFolder/cleanup-docker.sh"


kind delete cluster --name "$KIND_CLUSTERNAME"
