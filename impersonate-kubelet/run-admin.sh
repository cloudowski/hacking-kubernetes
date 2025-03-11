#!/usr/bin/env bash

. ../scripts/demo-magic.sh
TYPE_SPEED=${SPEED:-}

trap "unset KUBECONFIG
kubectl delete -f . -f user/ -f app/
rm -f *kubeconfig curl*
" EXIT

echo "ℹ️ Create our secret app";read -s
pei "kubectl apply -f app/"

echo "ℹ️ Create a user with limited permissions"
pei "kubectl apply -f user/"

echo "ℹ️ Generate custom kubeconfig for the user"
pei "../scripts/makekubeconfig.sh user6"

echo "🛑 Run the scenario with less privileges now - execute ./run-user.sh. Press any key to finish.";read -s