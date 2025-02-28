#!/bin/bash

rootPath=$(dirname $BASH_SOURCE)

kubeFlannelFileMasterCopy="$rootPath/kube-flannel.yml"
kubeFlannelFileAdjusted="$rootPath/kube-flannel.adjusted.yml"
flannelOverlayFileMasterCopy="$rootPath/flannel-overlay.yml"
flannelOverlayFileAdjusted="$rootPath/flannel-overlay.adjusted.yml"

# wget https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml --output-document=$kubeFlannelFileMasterCopy
# wget https://raw.githubusercontent.com/kubernetes-sigs/sig-windows-tools/master/hostprocess/flannel/flanneld/flannel-overlay.yml --output-document=$flannelOverlayFileMasterCopy

# yq -Y 'if .metadata.name=="kube-flannel-cfg" then (.data.["net-conf.json"]=(.data.["net-conf.json"]|fromjson|.Backend.VNI=4096|.Backend.Port=4789|tojson)) end' \
# $kubeFlannelFileMasterCopy \
# > $kubeFlannelFileAdjusted


serviceSubnet=$( \
kubectl get configmaps --namespace kube-system kubeadm-config --output yaml | \
yq '.data.ClusterConfiguration' --raw-output | \
yq '.networking.serviceSubnet' --raw-output \
)
echo "Service subnet: $serviceSubnet"

controlPlaneEndpoint=$(\
kubectl get configmap --namespace kube-system kube-proxy --output json | \
jq '.data.["kubeconfig.conf"]' --raw-output | \
yq '.clusters[] | select(.name == "default") | .cluster.server' --raw-output \
)
echo "Control plane endpoint: $controlPlaneEndpoint"

kubernetesServiceHost=$(echo $controlPlaneEndpoint | jq --raw-input 'scan("https?:[^:]+")' --raw-output)
echo "Kubernetes service host: $kubernetesServiceHost"

kubernetesServicePort=$(echo $controlPlaneEndpoint | jq --raw-input 'scan("\\d+$")' --raw-output)
echo "Kubernetes service port: $kubernetesServicePort"

yq -Y 'if .metadata.name=="kube-flannel-ds-windows-amd64" then { a: "Hallo Welt"} end' $flannelOverlayFileMasterCopy \
> $flannelOverlayFileAdjusted


# sed 's/FLANNEL_VERSION/v0.21.5/g' 
# sed "s/KUBERNETES_SERVICE_HOST_VALUE/$kubernetesServiceHost/g" 
# sed "s/KUBERNETES_SERVICE_PORT_VALUE/$kubernetesServicePort/g" 
# kubectl apply -f -

# kubectl apply --filename ./$kubeFlannelFileAdjusted