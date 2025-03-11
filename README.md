# Kubernetes Security Demos

Here are automated demo scenarions to show the risks of unsecured Pods running on Kubernetes.

* [node-disruption](node-disruption/)
* [imersonate-kubelet](imersonate-kubelet/)
* [net-eavesdropping](net-eavesdropping/)
* [impersonate-pod](impersonate-pod/)
* [break-in-with-cri](break-in-with-cri/)

## How to run the scenarios

There are various manifests, scripts and other resources in each directory.  
In order to run a prticular scenarion use these two scripts:

* **run-admin.sh** - run it first to prepare the environment (deploy the victim app, create unprivileged user etc.)
* **run-user.sh** - run it after the `run-admin.sh` script has prepared the environment

## Customization

The scripts assume that Kubernetes nodes have arm64 architecture. Adjust the scripts accordingly to download the necessary files (e.g. kubectl, curl) if a different architecure is used.  

For presentation you can set the asutomatic typing speed (disabled by default) with the **SPEED** parameter:

```shell
export SPEED=20
```