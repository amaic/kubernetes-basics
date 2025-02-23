#!/bin/bash

serviceSubnet=$( \
kubectl get configmaps --namespace kube-system kubeadm-config --output json | \
jq '.data.ClusterConfiguration' --raw-output | \
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

cat kube-flannel.yml | 


# sed 's/FLANNEL_VERSION/v0.21.5/g' 
# sed "s/KUBERNETES_SERVICE_HOST_VALUE/$kubernetesServiceHost/g" 
# sed "s/KUBERNETES_SERVICE_PORT_VALUE/$kubernetesServicePort/g" 
# kubectl apply -f -
