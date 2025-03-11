#!/usr/bin/env bash

. ../scripts/demo-magic.sh
TYPE_SPEED=${SPEED:-}

trap "unset KUBECONFIG
kubectl delete -f .
rm -f *kubeconfig
" EXIT


echo "ℹ️ Create a user"; read -s
pei "kubectl apply -f user/"

echo "ℹ️ Generate kubeconfig files"
pei "../scripts/makekubeconfig.sh user4"

echo "🛑 Run the scenario with less privileges now - execute ./run-user.sh. Press any key to finish.";read -s