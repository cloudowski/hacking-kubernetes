#!/bin/bash

set -euo pipefail

U=$1
CLUSTER=${U}
USER_KUBECONFIG=$U-kubeconfig

[ -z "$U" ] && { echo "Please provide a username" >&2; exit 2; }

TOKEN=$(kubectl get secret $U -o jsonpath='{.data.token}'|base64 --decode)

KUBE_CA=$(kubectl config view --minify=true --flatten -o json | jq '.clusters[0].cluster."certificate-authority-data"' -r)
KUBE_ENDPOINT=$(kubectl config view --minify=true --flatten -o json | jq '.clusters[0].cluster."server"' -r)

kubectl --kubeconfig=$USER_KUBECONFIG config set clusters.$CLUSTER.certificate-authority-data "$KUBE_CA"
kubectl --kubeconfig=$USER_KUBECONFIG config set-cluster $CLUSTER --server=$KUBE_ENDPOINT
kubectl --kubeconfig=$USER_KUBECONFIG config set-credentials $U --token=$TOKEN
kubectl --kubeconfig=$USER_KUBECONFIG config set-context $U --cluster=$CLUSTER --user=$U
kubectl --kubeconfig=$USER_KUBECONFIG config use-context $U