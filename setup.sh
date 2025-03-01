#!/bin/bash

rootFolder=$(dirname "$BASH_SOURCE")
echo "Root folder: $rootFolder"

source "$rootFolder/.env"

# "$rootFolder/setup-docker.sh"
# "$rootFolder/setup-cni.sh"
# "$rootFolder/setup-kind.sh"
# "$rootFolder/setup-kubectl.sh"

# sudo apt install -y jq yq

# wget https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml \
# --output-document="$rootFolder/kube-flannel.yml"

# wget https://raw.githubusercontent.com/kubernetes-sigs/sig-windows-tools/master/hostprocess/flannel/flanneld/flannel-overlay.yml \
# --output-document="$rootFolder/flannel-overlay.yml"

# wget https://raw.githubusercontent.com/kubernetes-sigs/sig-windows-tools/master/hostprocess/flannel/kube-proxy/kube-proxy.yml \
# --output-document="$rootFolder/kube-proxy.yml"

if [ ! -e /proc/sys/net/bridge/bridge-nf-call-iptables ]; 
then 
	echo "br_netfilter" | sudo tee /etc/modules-load.d/br_netfilter.conf
	sudo modprobe br_netfilter
fi

ipAddress=$(
 ip addr show dev eth0 | \
 jq --raw-input --slurp --raw-output 'scan("inet (?<ip>\\d+\\.\\d+\\.\\d+\\.\\d+)")|.[0]'
)
echo "IP address: $ipAddress"

yq --yaml-output \
--arg cn "$KIND_CLUSTERNAME" \
--arg im "$KIND_IMAGE" \
--arg ip "$ipAddress" \
'
(.name) |= ($cn) |
(.nodes[]) |= (
	(.image) |= ($im) |
	(select(.extraPortMappings!=null)|.extraPortMappings[].listenAddress) |= ($ip) |
	(select(.kubeadmConfigPatches!=null)|.kubeadmConfigPatches[]) |= (sub("0.0.0.0"; $ip))
)
' \
"$rootFolder/kind-config.yml" > "$rootFolder/kind-config-final.yml"

# kind create cluster --config "$rootFolder/kind-config-final.yml"

yq --yaml-output \
'
(select(.metadata.name=="kube-flannel-cfg")|.data.["net-conf.json"]) |= (fromjson|.Backend.VNI=4096|.Backend.Port=4789|tojson)
' \
"$rootFolder/kube-flannel.yml" > "$rootFolder/kube-flannel-final.yml"

# kubectl apply --filename "$rootFolder/kube-flannel-final.yml"

controlPlaneEndpoint=$(
kubectl get configmap --namespace kube-system kube-proxy --output json | \
jq '.data.["kubeconfig.conf"]' --raw-output | \
yq '.clusters[]|select(.name=="default")|.cluster.server' --raw-output
)
echo "Control plane endpoint: $controlPlaneEndpoint"

kubernetesServiceHost=$(
echo "$controlPlaneEndpoint" | jq --raw-input 'scan("^https?://[^:]+")' --raw-output
)
echo "Kubernetes service host: $kubernetesServiceHost"

kubernetesServicePort=$(
echo "$controlPlaneEndpoint" | jq --raw-input 'scan("\\d+$")' --raw-output
)
echo "Kubernetes service port: $kubernetesServicePort"

serviceSubnet=$(
kubectl get configmap --namespace kube-system kubeadm-config --output json | \
jq '.data.ClusterConfiguration' --raw-output | \
yq '.networking.serviceSubnet' --raw-output
)
echo "Service subnet: $serviceSubnet"

yq --yaml-output \
--arg fv "$FLANNEL_VERSION" \
--arg ho "$kubernetesServiceHost" \
--arg po "$kubernetesServicePort" \
--arg su "$serviceSubnet" \
--arg bp "$CNI_WIN_BIN_PATH" \
--arg cp "$CNI_WIN_CONFIG_PATH" \
'
(.spec.template.spec|select(.containers!=null).containers[]|select(.name=="kube-flannel")) |= (
	(.image) |= (sub("FLANNEL_VERSION"; $fv)) |
	(.env[]) |= (
		(select(.name=="KUBERNETES_SERVICE_HOST").value) |= ($ho) |
		(select(.name=="KUBERNETES_SERVICE_PORT").value) |= ($po) |
		(select(.name=="SERVICE_SUBNET").value) |= ($su) |
		(select(.name=="CNI_BIN_PATH").value) |= ($bp) |
		(select(.name=="CNI_CONFIG_PATH").value) |= ($cp)
	)
)
' \
"$rootFolder/flannel-overlay.yml" > "$rootFolder/flannel-overlay-final.yml"

# kubectl apply --filename "$rootFolder/flannel-overlay-final.yml"

yq --yaml-output \
--arg kp "$KUBE_WIN_PROXY_VERSION" \
--arg bp "$CNI_WIN_BIN_PATH" \
'
(.spec.template.spec|select(.containers!=null).containers[]|select(.name=="kube-proxy")) |= (
	(.image) |= (sub("KUBE_PROXY_VERSION"; $kp)) |
	(.env[]) |= (
		(select(.name=="CNI_BIN_PATH").value) |= ($bp)
	)
)
' \
"$rootFolder/kube-proxy.yml" > "$rootFolder/kube-proxy-final.yml"

kubectl apply --filename "$rootFolder/kube-proxy-final.yml"
