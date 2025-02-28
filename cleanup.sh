#!/bin/bash

rootFolder=$(dirname $BASH_SOURCE)
echo "Root folder: $rootFolder"

source "$rootFolder/.env"

"$rootFolder/cleanup-docker.sh"


