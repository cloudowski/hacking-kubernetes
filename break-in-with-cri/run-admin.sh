#!/usr/bin/env bash

. ../scripts/demo-magic.sh
TYPE_SPEED=${SPEED:-}

trap "unset KUBECONFIG
kubectl delete -f user -f secret-app -f .
rm -f curl* trurl *kubeconfig
" EXIT

CONTAINER_RUNTIME_ENDPOINT=unix:///host/run/containerd/containerd.sock

echo "ℹ️ Create the victim app and less privileged user"; read -s
pei "kubectl apply -f user/"
pei "kubectl apply -f secret-app/"

echo "ℹ️ Generate kubeconfig files"
pei "../scripts/makekubeconfig.sh user2"

echo "🛑 Run the scenario with less privileges now - execute ./run-user.sh. Press any key to finish.";read -s
