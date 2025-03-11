#!/usr/bin/env bash

. ../scripts/demo-magic.sh 
TYPE_SPEED=${SPEED:-}

pei "export KUBECONFIG=./user5-kubeconfig"
export KUBECONFIG=./user5-kubeconfig

echo "ℹ️ Get the tools";read -s
pei "kubectl wait --for=jsonpath='{.status.readyReplicas}=1' deploy/n5"
pei "kubectl exec deploy/n5 -ti -- sh -c 'apt update && apt install -y tcpdump iproute2'"
pe "kubectl exec deploy/n5 -ti -- ip a"

echo "ℹ️ Let's see some traffic";read -s
kubectl exec deploy/n5 -ti -- bash

echo "# Ooops 🤥";read -s

