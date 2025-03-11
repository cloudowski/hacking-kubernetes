#!/usr/bin/env bash

. ../scripts/demo-magic.sh
TYPE_SPEED=${SPEED:-}

pei "export KUBECONFIG=./user4-kubeconfig"
export KUBECONFIG=./user4-kubeconfig

echo "ℹ️ Create our app";read -s
pei "kubectl apply -f n4-deploy.yaml"
pei "kubectl wait --for=jsonpath='{.status.readyReplicas}=1' deploy/n4"

echo "❓ Is the 'kill' command available?";read -s
pei "kubectl exec deploy/n4 -ti -- kill -l"

echo "ℹ️ Install the tools";read -s
pei "kubectl exec deploy/n4 -ti -- sh -c 'apt update && apt install -y procps'"
pei "kubectl exec deploy/n4 -ti -- sh -c bash"

echo "ℹ️ I need to become root";read -s
pei "kubectl patch deployment n4 --patch-file=root.patch"
pei "kubectl rollout status -w deploy/n4"
pei "kubectl exec deploy/n4 -ti -- sh -c 'apt update && apt install -y procps'"
pei "kubectl exec deploy/n4 -ti -- sh -c bash"

