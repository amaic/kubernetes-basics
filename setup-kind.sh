#!/bin/bash

rootFolder=$(dirname "$BASH_SOURCE")
. "$rootFolder/.env"

# https://kind.sigs.k8s.io/docs/user/quick-start/#installing-from-release-binaries
# For AMD64 / x86_64
[ "$(uname -m)" = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v$KIND_VERSION/kind-linux-amd64
# For ARM64
[ "$(uname -m)" = aarch64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v$KIND_VERSION/kind-linux-arm64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

cat <<"EOD" >> ~/.bashrc

source <(kind completion bash)
EOD