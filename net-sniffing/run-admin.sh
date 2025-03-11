#!/usr/bin/env bash

. ../scripts/demo-magic.sh 
TYPE_SPEED=${SPEED:-}

trap "unset KUBECONFIG
kubectl delete -f . -f target-app
rm -f *kubeconfig
" EXIT

echo "ℹ️ Create the target app"; read -s
pei "kubectl apply -f target-app/"
pei "kubectl wait --for=jsonpath='{.status.readyReplicas}=1' deploy/backend"
pei "kubectl wait --for=jsonpath='{.status.readyReplicas}=1' deploy/webapi"

echo "ℹ️ Create our app and user"
pei "kubectl apply -f n5-deploy.yaml"
pei "kubectl apply -f user/"

echo "ℹ️ Generate kubeconfig files"
pei "../scripts/makekubeconfig.sh user5"

echo "🛑 Run the scenario with less privileges now - execute ./run-user.sh. Press any key to finish.";read -s