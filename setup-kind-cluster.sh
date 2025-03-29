#!/bin/bash

rootFolder=$(dirname "$BASH_SOURCE")
. "$rootFolder/.env"

ipAddress=$(
 ip addr show dev eth0 | \
 jq --raw-input --slurp --raw-output 'scan("inet (?<ip>\\d+\\.\\d+\\.\\d+\\.\\d+)")|.[0]'
)
echo "IP address: $ipAddress"

yq --yaml-output \
--arg cn "$KIND_CLUSTERNAME" \
--arg im "$KIND_IMAGE" \
--arg cni "$CNI_BIN_PATH" \
--arg ip "$ipAddress" \
'
(.name) |= ($cn) |
(.nodes[]) |= (
	(.image) |= ($im) |
	(select(.extraPortMappings!=null)|.extraPortMappings[].listenAddress) |= $ip |
	(select(.kubeadmConfigPatches!=null)|.kubeadmConfigPatches[]) |= sub("<replace>"; $ip) |
	(select(.extraMounts!=null)|.extraMounts[]) |= (
		(.hostPath) |= $cni |
		(.containerPath) |= $cni
	) 
)
' \
"$rootFolder/kind-config.yml" > "$rootFolder/kind-config-final.yml"

wget https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml \
--output-document="$rootFolder/kube-flannel.yml"


# kind create cluster --config "$rootFolder/kind-config-final.yml"